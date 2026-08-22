import 'package:game_engine/src/event/game_event.dart';
import 'package:game_engine/src/model/game_state.dart';
import 'package:game_engine/src/transition/rejection_reason.dart';
import 'package:game_engine/src/transition/streak_effect.dart';

final class GameTransition {
  const GameTransition({
    required this.accepted,
    required this.previousState,
    required this.nextState,
    required this.moveCost,
    required this.events,
    this.rejectionReason,
    this.streakEffect,
  });

  final bool accepted;
  final GameState previousState;
  final GameState nextState;
  final int moveCost;
  final List<GameEvent> events;
  final RejectionReason? rejectionReason;
  final StreakEffect? streakEffect;

  factory GameTransition.rejected({
    required GameState previousState,
    required GameState nextState,
    required RejectionReason reason,
    required List<GameEvent> events,
  }) {
    return GameTransition(
      accepted: false,
      previousState: previousState,
      nextState: nextState,
      moveCost: 0,
      events: events,
      rejectionReason: reason,
    );
  }

  factory GameTransition.accepted({
    required GameState previousState,
    required GameState nextState,
    required int moveCost,
    required List<GameEvent> events,
    required StreakEffect streakEffect,
  }) {
    return GameTransition(
      accepted: true,
      previousState: previousState,
      nextState: nextState,
      moveCost: moveCost,
      events: events,
      streakEffect: streakEffect,
    );
  }
}
