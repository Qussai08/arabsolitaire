import 'package:game_engine/src/action/game_action.dart';
import 'package:game_engine/src/model/game_state.dart';
import 'package:game_engine/src/transition/game_engine.dart';
import 'package:game_engine/src/transition/game_transition.dart';
import 'package:game_engine/src/transition/rejection_reason.dart';

final class GameReplayResult {
  const GameReplayResult({
    required this.finalState,
    required this.transitions,
    this.failedAtIndex,
    this.failureReason,
  });

  final GameState finalState;
  final List<GameTransition> transitions;
  final int? failedAtIndex;
  final RejectionReason? failureReason;

  bool get succeeded => failedAtIndex == null;
}

/// Replay actions through the authoritative engine API.
abstract final class GameReplay {
  static GameReplayResult run({
    required GameState initialState,
    required List<GameAction> actions,
    GameEngine engine = const GameEngine(),
    bool stopOnReject = true,
  }) {
    var state = initialState;
    final transitions = <GameTransition>[];

    for (var i = 0; i < actions.length; i++) {
      final transition = engine.applyAction(state, actions[i]);
      transitions.add(transition);
      state = transition.nextState;
      if (!transition.accepted && stopOnReject) {
        return GameReplayResult(
          finalState: state,
          transitions: transitions,
          failedAtIndex: i,
          failureReason: transition.rejectionReason,
        );
      }
    }

    return GameReplayResult(finalState: state, transitions: transitions);
  }
}
