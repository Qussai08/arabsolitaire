import 'dart:isolate';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_engine/game_engine.dart';
import 'package:game_solver/game_solver.dart';
import 'package:level_generator/level_generator.dart';
import 'package:mobile/features/gameplay/application/gameplay_providers.dart';
import 'package:mobile/features/gameplay/application/gameplay_state.dart';
import 'package:mobile/features/gameplay/data/active_attempt_repository.dart';
import 'package:mobile/features/journey/domain/journey_models.dart';

/// Manages the full gameplay lifecycle for one attempt.
class GameplayController extends Notifier<GameplayViewState> {
  GameplayController({
    LevelConfiguration? config,
    ContentSelector? contentSelector,
  })  : _overrideConfig = config,
        _overrideSelector = contentSelector;

  final LevelConfiguration? _overrideConfig;
  final ContentSelector? _overrideSelector;

  final _engine = const GameEngine();
  int _revision = 0;
  int _hintRevision = -1;
  int _deadEndRevision = -1;
  late LevelDefinition _level;
  late LevelConfiguration _config;
  late ContentSelector _contentSelector;

  ActiveAttemptRepository get _repo =>
      ref.read(activeAttemptRepositoryProvider);

  @override
  GameplayViewState build() {
    _level = ref.resolvePlayingLevel();
    _config = _overrideConfig ?? ref.resolveLevelConfig(_level);
    _contentSelector =
        _overrideSelector ?? ref.resolveContentSelector(_level);
    Future.microtask(_initialize);
    return const GameplayLoading();
  }

  // ── Init ──────────────────────────────────────────────────────────────────

  Future<void> _initialize() async {
    try {
      final saved = await _repo.load();
      final sameLevel = _overrideConfig != null ||
          saved?.levelDefinitionId == _level.levelDefinitionId;
      if (saved != null && saved.isCompatible && sameLevel) {
        if (_engine.validate(saved.gameState)) {
          _revision = saved.revision;
          state = GameplayPlaying(
            gameState: saved.gameState,
            revision: _revision,
          );
          return;
        }
        await _repo.clear();
      }
      await _generateNew();
    } catch (e) {
      state = GameplayError(message: e.toString());
    }
  }

  Future<void> _generateNew() async {
    state = const GameplayLoading();
    try {
      final baseSeed = GenerationSeed(
        DateTime.now().millisecondsSinceEpoch & 0x7FFFFFFF,
      );
      final capturedConfig = _config;
      final capturedSelector = _contentSelector;

      final result = await Isolate.run(() {
        return LevelGenerator().generate(
          config: capturedConfig,
          contentSelector: capturedSelector,
          baseSeed: baseSeed,
        );
      });

      switch (result) {
        case GenerationSucceeded(:final level):
          _revision = 0;
          await _repo.save(SavedAttempt(
            levelDefinitionId: level.levelDefinitionId,
            attemptId: level.initialGameState.attemptId,
            seed: level.seed.value,
            gameState: level.initialGameState,
            rulesVersion: level.rulesVersion,
            saveSchemaVersion: level.initialGameState.saveSchemaVersion,
            generatorVersion: level.generatorVersion,
            revision: _revision,
          ));
          state = GameplayPlaying(
            gameState: level.initialGameState,
            revision: _revision,
          );
        case GenerationFailed() || GenerationInconclusive():
          state = const GameplayError(
            message: 'تعذر تجهيز المستوى. حاول مرة أخرى.',
          );
      }
    } catch (e) {
      state = GameplayError(message: e.toString());
    }
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  void applyAction(GameAction action) {
    final playing = _asPlaying();
    if (playing == null) return;

    final transition = _engine.applyAction(playing.gameState, action);
    _revision++;

    final next = transition.nextState;
    _persistAsync(next);

    if (transition.accepted) {
      if (next.status == AttemptStatus.won) {
        state = GameplayWon(
          gameState: next,
          reward: WinRewardPreview(
            remainingMoves: next.movesRemaining,
            earnedStreakCoins: next.streak.earnedStreakCoins,
          ),
        );
      } else if (next.status == AttemptStatus.outOfMoves) {
        state = GameplayOutOfMoves(gameState: next);
      } else {
        state = GameplayPlaying(
          gameState: next,
          revision: _revision,
          hint: HintViewState.idle,
        );
        _scheduleDeadEndCheck(next);
      }
    } else {
      // Invalid action: streak may have been reset — persist updated state.
      state = playing.copyWith(
        gameState: next,
        revision: _revision,
        hint: HintViewState.idle,
      );
    }
  }

  Future<void> requestHint() async {
    final playing = _asPlaying();
    if (playing == null) return;

    final requestedRevision = _revision;
    _hintRevision = requestedRevision;

    state = playing.copyWith(hint: HintViewState.loading);

    final gameState = playing.gameState;
    try {
      final result = await Isolate.run(() {
        return GameSolver().findHint(
          state: gameState,
          options: const SolverOptions(
            timeout: Duration(seconds: 8),
            maxExpandedNodes: 100000,
          ),
        );
      });

      if (_revision != _hintRevision) return;
      final current = _asPlaying();
      if (current == null) return;

      final nextHint = switch (result) {
        HintAvailable(:final action) => HintViewState.idle.withAction(action),
        HintNoWinningContinuation() => HintViewState.noResult,
        HintInconclusive() || HintAlreadyWon() => HintViewState.inconclusive,
      };
      state = current.copyWith(hint: nextHint);
    } catch (_) {
      final current = _asPlaying();
      if (current != null) state = current.copyWith(hint: HintViewState.idle);
    }
  }

  Future<void> _scheduleDeadEndCheck(GameState gameState) async {
    final checkRevision = _revision;
    _deadEndRevision = checkRevision;

    final current = _asPlaying();
    if (current == null) return;
    state = current.copyWith(deadEnd: DeadEndViewState.checking);

    try {
      final result = await Isolate.run(() {
        return GameSolver().evaluateDeadEnd(
          state: gameState,
          options: const SolverOptions(
            timeout: Duration(seconds: 5),
            maxExpandedNodes: 80000,
          ),
        );
      });

      if (_revision != _deadEndRevision) return;
      final currentPlaying = _asPlaying();
      if (currentPlaying == null) return;

      switch (result) {
        case ConfirmedDeadEnd():
          state = GameplayConfirmedDeadEnd(
            gameState: currentPlaying.gameState,
          );
        case NotDeadEnd():
          state = currentPlaying.copyWith(
            deadEnd: DeadEndViewState.notDeadEnd,
          );
        case DeadEndInconclusive():
          state = currentPlaying.copyWith(
            deadEnd: DeadEndViewState.inconclusive,
          );
        case DeadEndAlreadyWon() || DeadEndOutOfMoves():
          break;
      }
    } catch (_) {
      // Timed out — leave state as-is.
    }
  }

  Future<void> restart() async {
    _revision = 0;
    _hintRevision = -1;
    _deadEndRevision = -1;
    await _repo.clear();
    await _generateNew();
  }

  Future<void> retryGeneration() => _generateNew();

  void dismissHint() {
    final playing = _asPlaying();
    if (playing != null) state = playing.copyWith(hint: HintViewState.idle);
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  GameplayPlaying? _asPlaying() {
    final s = state;
    return s is GameplayPlaying ? s : null;
  }

  void _persistAsync(GameState gameState) {
    _repo
        .save(SavedAttempt(
          levelDefinitionId: gameState.levelDefinitionId,
          attemptId: gameState.attemptId,
          seed: 0,
          gameState: gameState,
          rulesVersion: gameState.rulesVersion,
          saveSchemaVersion: gameState.saveSchemaVersion,
          generatorVersion: '',
          revision: _revision,
        ))
        .ignore();
  }
}
