import 'package:game_engine/game_engine.dart';

/// Authoritative transition payload sent to Unity after Dart applies an action.
final class TransitionResultPayload {
  const TransitionResultPayload({
    required this.accepted,
    required this.nextState,
    required this.moveCost,
    required this.events,
    required this.newRevision,
    this.rejectionReason,
    this.streakEffect,
  });

  final bool accepted;
  final GameState nextState;
  final int moveCost;
  final List<GameEvent> events;
  final int newRevision;
  final RejectionReason? rejectionReason;
  final StreakEffect? streakEffect;

  factory TransitionResultPayload.fromTransition({
    required GameTransition transition,
    required int newRevision,
  }) {
    return TransitionResultPayload(
      accepted: transition.accepted,
      nextState: transition.nextState,
      moveCost: transition.moveCost,
      events: transition.events,
      newRevision: newRevision,
      rejectionReason: transition.rejectionReason,
      streakEffect: transition.streakEffect,
    );
  }
}

abstract final class TransitionResultCodec {
  static Map<String, Object?> encode(TransitionResultPayload result) {
    return {
      'accepted': result.accepted,
      'nextState': GameStateCodec.encode(result.nextState),
      'moveCost': result.moveCost,
      'events': [for (final e in result.events) e.toJson()],
      'newRevision': result.newRevision,
      if (result.rejectionReason != null)
        'rejectionReason': result.rejectionReason!.name,
      if (result.streakEffect != null) 'streakEffect': result.streakEffect!.name,
    };
  }

  static TransitionResultPayload decode(Map<String, Object?> json) {
    final accepted = json['accepted'];
    if (accepted is! bool) {
      throw const FormatException('transitionResult.accepted is required');
    }
    final nextStateRaw = json['nextState'];
    if (nextStateRaw is! Map) {
      throw const FormatException('transitionResult.nextState is required');
    }
    final moveCost = json['moveCost'];
    if (moveCost is! int) {
      throw const FormatException('transitionResult.moveCost is required');
    }
    final newRevision = json['newRevision'];
    if (newRevision is! int) {
      throw const FormatException('transitionResult.newRevision is required');
    }
    final eventsRaw = json['events'];
    if (eventsRaw is! List) {
      throw const FormatException('transitionResult.events is required');
    }

    final rejection = json['rejectionReason'];
    final streak = json['streakEffect'];

    return TransitionResultPayload(
      accepted: accepted,
      nextState: GameStateCodec.decode(Map<String, Object?>.from(nextStateRaw)),
      moveCost: moveCost,
      events: const <GameEvent>[],
      newRevision: newRevision,
      rejectionReason: rejection is String
          ? RejectionReason.values.byName(rejection)
          : null,
      streakEffect: streak is String
          ? StreakEffect.values.byName(streak)
          : null,
    );
  }
}
