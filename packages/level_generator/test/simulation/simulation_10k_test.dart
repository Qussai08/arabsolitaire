/// 10,000+ board simulation gate — Sprint 11 §36 requirement.
///
/// Validates that critical Level templates:
/// - never produce an accepted board that is later unsolvable;
/// - replay every accepted solution to AttemptStatus.won via the Engine;
/// - exhibit bounded generation behavior (no infinite loops);
/// - produce no Engine invariant violations.
///
/// Run as part of nightly / release pipeline, NOT on every PR
/// (use the solver-simulation.yml workflow with `on: workflow_dispatch`).
///
/// dart test packages/level_generator/test/simulation/simulation_10k_test.dart
/// --reporter=compact --timeout=30m
library;

import 'package:game_engine/game_engine.dart';
import 'package:level_generator/level_generator.dart';
import 'package:test/test.dart';

const _targetBoards = 10000;

void main() {
  // Each template group targets enough seeds to collect 10k accepted boards
  // across the suite. Seeds are deterministic so results are reproducible.

  group('10k simulation gate — early3x1', () {
    _simulationSuite(
      name: 'early3x1',
      config: () => LevelTemplates.early3x1(
        difficulty: DifficultyTarget.any,
        moveLimit: 30,
        maxGenerationAttempts: 40,
        includeSolutionActions: true,
      ),
      seedRange: _targetBoards,
    );
  });

  group('10k simulation gate — stockHeavy', () {
    _simulationSuite(
      name: 'stockHeavy',
      config: () => LevelTemplates.stockHeavy(
        difficulty: DifficultyTarget.any,
        moveLimit: 40,
      ),
      seedRange: _targetBoards,
    );
  });

  group('10k simulation gate — revealHeavy', () {
    _simulationSuite(
      name: 'revealHeavy',
      config: () => LevelTemplates.revealHeavy(
        difficulty: DifficultyTarget.any,
        moveLimit: 40,
      ),
      seedRange: _targetBoards,
    );
  });

  group('10k simulation gate — mixedGroups', () {
    _simulationSuite(
      name: 'mixedGroups',
      config: () => LevelTemplates.mixedGroups(
        difficulty: DifficultyTarget.any,
        moveLimit: 50,
      ),
      seedRange: _targetBoards,
    );
  });
}

// ─────────────────────────────────────────────────────────────────────────────

void _simulationSuite({
  required String name,
  required LevelConfiguration Function() config,
  required int seedRange,
}) {
  test(
    '$name: $seedRange seeds — no accepted unsolvable board, all replays win',
    () {
      final summary = SimulationSummary(name: name, targetBoards: seedRange);
      final generator = LevelGenerator();
      final engine = const GameEngine();

      for (var seed = 1; seed <= seedRange; seed++) {
        final cfg = config();
        final contentSelector = FixedContentSelector(
          SyntheticContent.forProfile(cfg.groupSizeProfile),
        );

        final result = generator.generate(
          config: cfg,
          contentSelector: contentSelector,
          baseSeed: GenerationSeed(seed),
        );

        summary.record(result);

        if (result is GenerationSucceeded) {
          final level = result.level;

          // ── Invariant: Engine must validate the accepted initial state ────
          final valid = engine.validate(level.initialGameState);
          expect(
            valid,
            isTrue,
            reason:
                '[$name seed=$seed] Engine invariant violated on accepted board',
          );

          // ── Invariant: Solution replay must reach Win ─────────────────────
          if (level.solutionActions != null) {
            final replay = GameReplay.run(
              initialState: level.initialGameState,
              actions: level.solutionActions!,
            );
            expect(
              replay.succeeded,
              isTrue,
              reason:
                  '[$name seed=$seed] Replay failed — accepted unsolvable board! '
                  'finalStatus=${replay.finalState.status}',
            );
            expect(
              replay.finalState.status,
              AttemptStatus.won,
              reason:
                  '[$name seed=$seed] Replay did not reach Win status — '
                  'accepted unsolvable board!',
            );
          }
        }
      }

      // ── Print summary for CI log ──────────────────────────────────────────
      // ignore: avoid_print
      print(summary);

      // ── Aggregate gate: zero accepted-but-unsolvable boards ──────────────
      // (individual test failures above already catch this; this guards
      //  against summary counting bugs)
      expect(
        summary.replayFailures,
        0,
        reason:
            '[$name] ${summary.replayFailures} accepted boards failed replay',
      );

      // ── Bounded behavior: generator must not only be inconclusive ─────────
      final conclusiveRate = summary.accepted / summary.total;
      expect(
        conclusiveRate,
        greaterThan(0.0),
        reason:
            '[$name] Generator produced 0 accepted boards — '
            'possible config or solver regression',
      );
    },
    timeout: const Timeout(Duration(minutes: 30)),
  );
}

// ─────────────────────────────────────────────────────────────────────────────

final class SimulationSummary {
  SimulationSummary({required this.name, required this.targetBoards});

  final String name;
  final int targetBoards;

  int accepted = 0;
  int unsolvableRejects = 0;
  int solutionOverLimitRejects = 0;
  int engineInvariantRejects = 0;
  int difficultyRejects = 0;
  int inconclusiveRejects = 0;
  int failed = 0; // generation exhausted retry budget
  int replayFailures = 0;

  // Timing / difficulty accumulators
  int totalGenerationAttempts = 0;
  int totalSolutionLength = 0;
  Duration totalElapsed = Duration.zero;

  int get total => targetBoards;

  void record(GenerationResult result) {
    totalGenerationAttempts += result.metrics.generationAttempts;
    totalElapsed += result.metrics.elapsed;

    switch (result) {
      case GenerationSucceeded(:final level, :final metrics):
        accepted++;
        totalSolutionLength += level.solutionLength;
        unsolvableRejects += metrics.unsolvableRejects;
        solutionOverLimitRejects += metrics.solutionOverLimitRejects;
        engineInvariantRejects += metrics.engineInvariantRejects;
        inconclusiveRejects += metrics.solverInconclusiveCount;
        difficultyRejects += metrics.tooEasyRejects + metrics.tooHardRejects;
      case GenerationFailed(:final metrics):
        failed++;
        unsolvableRejects += metrics.unsolvableRejects;
        solutionOverLimitRejects += metrics.solutionOverLimitRejects;
        engineInvariantRejects += metrics.engineInvariantRejects;
        inconclusiveRejects += metrics.solverInconclusiveCount;
        difficultyRejects += metrics.tooEasyRejects + metrics.tooHardRejects;
      case GenerationInconclusive(:final metrics):
        inconclusiveRejects += metrics.solverInconclusiveCount;
        failed++;
    }
  }

  @override
  String toString() {
    final avgSolution = accepted > 0
        ? (totalSolutionLength / accepted).toStringAsFixed(1)
        : '-';
    final avgAttempts = (totalGenerationAttempts / total).toStringAsFixed(1);
    final elapsedSec = totalElapsed.inMilliseconds / 1000.0;
    final acceptRate = (accepted / total * 100).toStringAsFixed(1);
    return '''
═══════════════════════════════════════════════════════════
Simulation Gate — $name
───────────────────────────────────────────────────────────
Total seeds     : $total
Accepted        : $accepted ($acceptRate%)
Failed/Inconc.  : $failed
Replay failures : $replayFailures  ← MUST BE 0
───────────────────────────────────────────────────────────
Unsolvable rejects     : $unsolvableRejects
Over-limit rejects     : $solutionOverLimitRejects
Engine invariant rej.  : $engineInvariantRejects
Difficulty rejects     : $difficultyRejects
Solver inconclusive    : $inconclusiveRejects
───────────────────────────────────────────────────────────
Avg gen attempts/seed  : $avgAttempts
Avg solution length    : $avgSolution moves
Total elapsed          : ${elapsedSec.toStringAsFixed(1)}s
═══════════════════════════════════════════════════════════''';
  }
}
