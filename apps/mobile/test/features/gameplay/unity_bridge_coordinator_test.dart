import 'package:flutter_test/flutter_test.dart';
import 'package:game_engine/game_engine.dart';
import 'package:mobile/features/gameplay/application/gameplay_bridge_host.dart';
import 'package:mobile/features/gameplay/application/gameplay_state.dart';
import 'package:mobile/features/gameplay/bridge/unity_bridge_coordinator.dart';
import 'package:mobile/features/gameplay/bridge/unity_bridge_transport.dart';
import 'package:unity_bridge_contracts/unity_bridge_contracts.dart';

final class _FakeGameplayBridgeHost implements GameplayBridgeHost {
  _FakeGameplayBridgeHost(this._state);

  final GameplayViewState _state;
  GameTransition? nextTransition;

  @override
  GameplayViewState get viewState => _state;

  @override
  int get revision {
    final state = _state;
    if (state is GameplayPlaying) {
      return state.revision;
    }
    return 0;
  }

  @override
  GameTransition? applyAction(GameAction action) => nextTransition;

  @override
  Future<void> requestHint() async {}

  @override
  Future<void> restart() async {}
}

GameState _minimalState() {
  return GameState(
    attemptId: 'attempt-1',
    levelDefinitionId: 'cairo-1',
    associations: const {},
    tableau: const [],
    stock: const StockState(),
    slots: const [],
    moveLimit: 30,
    movesRemaining: 30,
  );
}

void main() {
  group('UnityBridgeCoordinator', () {
    test('unityReady sends initialize and state snapshot', () async {
      final transport = MockUnityBridgeTransport();
      addTearDown(transport.dispose);

      final controller = _FakeGameplayBridgeHost(
        GameplayPlaying(gameState: _minimalState(), revision: 0),
      );

      final coordinator = UnityBridgeCoordinator(
        controller: controller,
        transport: transport,
        sessionId: 's1',
        attemptId: 'attempt-1',
        levelDefinitionId: 'cairo-1',
      );
      addTearDown(coordinator.dispose);
      await coordinator.start();

      transport.emitFromUnity(
        const BridgeEnvelope(
          schemaVersion: kBridgeSchemaVersion,
          messageId: 'ready-1',
          sessionId: 's1',
          attemptId: 'attempt-1',
          levelDefinitionId: 'cairo-1',
          revision: 0,
          type: BridgeMessageType.unityReady,
          payload: const <String, Object?>{},
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(transport.sent, hasLength(2));
      expect(transport.sent.first.type, BridgeMessageType.initialize);
      expect(transport.sent.last.type, BridgeMessageType.stateSnapshot);
      expect(coordinator.unityReady, isTrue);
    });

    test('accepted action intent returns transitionResult', () async {
      final transport = MockUnityBridgeTransport();
      addTearDown(transport.dispose);

      final gameState = _minimalState();
      final controller = _FakeGameplayBridgeHost(
        GameplayPlaying(gameState: gameState, revision: 0),
      );
      controller.nextTransition = GameTransition.accepted(
        previousState: gameState,
        nextState: gameState,
        moveCost: 1,
        events: const [],
        streakEffect: StreakEffect.neutral,
      );

      final coordinator = UnityBridgeCoordinator(
        controller: controller,
        transport: transport,
        sessionId: 's1',
        attemptId: 'attempt-1',
        levelDefinitionId: 'cairo-1',
      );
      addTearDown(coordinator.dispose);
      await coordinator.start();

      transport.emitFromUnity(
        const BridgeEnvelope(
          schemaVersion: kBridgeSchemaVersion,
          messageId: 'intent-1',
          sessionId: 's1',
          attemptId: 'attempt-1',
          levelDefinitionId: 'cairo-1',
          revision: 0,
          type: BridgeMessageType.actionIntent,
          requestId: 'req-1',
          payload: BridgePayloads.actionIntent(
            action: const MoveTableauToTableau(fromColumn: 0, toColumn: 1),
          ),
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(transport.sent, hasLength(1));
      expect(transport.sent.single.type, BridgeMessageType.transitionResult);
    });

    test('presentationCompleted invokes callback', () async {
      final transport = MockUnityBridgeTransport();
      addTearDown(transport.dispose);

      var completedRevision = -1;
      final coordinator = UnityBridgeCoordinator(
        controller: _FakeGameplayBridgeHost(
          GameplayPlaying(gameState: _minimalState(), revision: 0),
        ),
        transport: transport,
        sessionId: 's1',
        attemptId: 'attempt-1',
        levelDefinitionId: 'cairo-1',
        onPresentationCompleted: (revision) => completedRevision = revision,
      );
      addTearDown(coordinator.dispose);
      await coordinator.start();

      transport.emitFromUnity(
        BridgeEnvelope(
          schemaVersion: kBridgeSchemaVersion,
          messageId: 'pc-1',
          sessionId: 's1',
          attemptId: 'attempt-1',
          levelDefinitionId: 'cairo-1',
          revision: 4,
          type: BridgeMessageType.presentationCompleted,
          payload: const <String, Object?>{'revision': 4},
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(completedRevision, 4);
    });
  });
}
