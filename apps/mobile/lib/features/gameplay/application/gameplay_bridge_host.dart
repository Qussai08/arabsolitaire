import 'package:game_engine/game_engine.dart';
import 'package:mobile/features/gameplay/application/gameplay_state.dart';

/// Narrow surface used by Unity bridge coordination.
abstract interface class GameplayBridgeHost {
  GameplayViewState get viewState;

  int get revision;

  GameTransition? applyAction(GameAction action);

  Future<void> requestHint();

  Future<void> restart();
}
