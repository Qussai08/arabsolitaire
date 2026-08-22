import 'package:game_engine/game_engine.dart';

/// Win reward preview (economy not yet authoritative in Sprint 4).
final class WinRewardPreview {
  const WinRewardPreview({
    required this.remainingMoves,
    required this.earnedStreakCoins,
  });

  static const int _base = 50;

  final int remainingMoves;
  final int earnedStreakCoins;

  int get movesBonus => 2 * remainingMoves;
  int get total => _base + movesBonus + earnedStreakCoins;
}

enum HintPhase { idle, loading, available, noResult, inconclusive }

final class HintViewState {
  const HintViewState({
    this.phase = HintPhase.idle,
    this.suggestedAction,
  });

  final HintPhase phase;
  final GameAction? suggestedAction;

  static const idle = HintViewState();
  static const loading = HintViewState(phase: HintPhase.loading);
  static const noResult = HintViewState(phase: HintPhase.noResult);
  static const inconclusive = HintViewState(phase: HintPhase.inconclusive);

  HintViewState withAction(GameAction action) =>
      HintViewState(phase: HintPhase.available, suggestedAction: action);
}

enum DeadEndPhase { idle, checking, notDeadEnd, confirmed, inconclusive }

final class DeadEndViewState {
  const DeadEndViewState({this.phase = DeadEndPhase.idle});

  static const idle = DeadEndViewState();
  static const checking = DeadEndViewState(phase: DeadEndPhase.checking);
  static const notDeadEnd =
      DeadEndViewState(phase: DeadEndPhase.notDeadEnd);
  static const confirmed =
      DeadEndViewState(phase: DeadEndPhase.confirmed);
  static const inconclusive =
      DeadEndViewState(phase: DeadEndPhase.inconclusive);

  final DeadEndPhase phase;
}

sealed class GameplayViewState {
  const GameplayViewState();
}

final class GameplayLoading extends GameplayViewState {
  const GameplayLoading();
}

final class GameplayPlaying extends GameplayViewState {
  const GameplayPlaying({
    required this.gameState,
    required this.revision,
    this.hint = HintViewState.idle,
    this.deadEnd = DeadEndViewState.idle,
  });

  final GameState gameState;
  final int revision;
  final HintViewState hint;
  final DeadEndViewState deadEnd;

  GameplayPlaying copyWith({
    GameState? gameState,
    int? revision,
    HintViewState? hint,
    DeadEndViewState? deadEnd,
  }) {
    return GameplayPlaying(
      gameState: gameState ?? this.gameState,
      revision: revision ?? this.revision,
      hint: hint ?? this.hint,
      deadEnd: deadEnd ?? this.deadEnd,
    );
  }
}

final class GameplayWon extends GameplayViewState {
  const GameplayWon({required this.gameState, required this.reward});

  final GameState gameState;
  final WinRewardPreview reward;
}

final class GameplayOutOfMoves extends GameplayViewState {
  const GameplayOutOfMoves({required this.gameState});

  final GameState gameState;
}

final class GameplayConfirmedDeadEnd extends GameplayViewState {
  const GameplayConfirmedDeadEnd({required this.gameState});

  final GameState gameState;
}

final class GameplayError extends GameplayViewState {
  const GameplayError({required this.message, this.recoverable = true});

  final String message;
  final bool recoverable;
}
