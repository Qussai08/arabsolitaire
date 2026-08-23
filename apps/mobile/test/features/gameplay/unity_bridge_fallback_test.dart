import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/gameplay/application/gameplay_presentation_mode.dart';
import 'package:mobile/features/gameplay/application/gameplay_presentation_providers.dart';
import 'package:mobile/features/gameplay/bridge/unity_bridge_transport.dart';
import 'package:unity_bridge_contracts/unity_bridge_contracts.dart';

void main() {
  group('Gameplay presentation mode', () {
    test('defaults to flutter2d', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(
        container.read(gameplayPresentationModeProvider),
        GameplayPresentationMode.flutter2d,
      );
      expect(
        container.read(effectiveGameplayPresentationModeProvider),
        GameplayPresentationMode.flutter2d,
      );
    });

    test('unity3d falls back to flutter2d when Unity is not ready', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(gameplayPresentationModeProvider.notifier).state =
          GameplayPresentationMode.unity3d;
      container.read(unityRuntimeReadyProvider.notifier).state = false;

      expect(
        container.read(effectiveGameplayPresentationModeProvider),
        GameplayPresentationMode.flutter2d,
      );
    });

    test('unity3d is effective only when runtime is ready', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(gameplayPresentationModeProvider.notifier).state =
          GameplayPresentationMode.unity3d;
      container.read(unityRuntimeReadyProvider.notifier).state = true;

      expect(
        container.read(effectiveGameplayPresentationModeProvider),
        GameplayPresentationMode.unity3d,
      );
    });
  });

  group('MockUnityBridgeTransport', () {
    test('records outbound envelopes and relays inbound', () async {
      final transport = MockUnityBridgeTransport();
      addTearDown(transport.dispose);

      final received = <BridgeEnvelope>[];
      final sub = transport.inbound.listen(received.add);
      addTearDown(sub.cancel);

      final outbound = BridgeEnvelope(
        schemaVersion: kBridgeSchemaVersion,
        messageId: 'm1',
        sessionId: 's1',
        attemptId: 'a1',
        levelDefinitionId: 'l1',
        revision: 0,
        type: BridgeMessageType.pause,
        payload: const <String, Object?>{},
      );
      await transport.send(outbound);
      expect(transport.sent, hasLength(1));

      final inbound = BridgeEnvelope(
        schemaVersion: kBridgeSchemaVersion,
        messageId: 'u1',
        sessionId: 's1',
        attemptId: 'a1',
        levelDefinitionId: 'l1',
        revision: 0,
        type: BridgeMessageType.unityReady,
        payload: const <String, Object?>{},
      );
      transport.emitFromUnity(inbound);
      await Future<void>.delayed(Duration.zero);
      expect(received, hasLength(1));
      expect(received.first.type, BridgeMessageType.unityReady);
    });

    test('throws when Unity is simulated unavailable', () async {
      final transport = MockUnityBridgeTransport()..simulateUnavailable = true;
      addTearDown(transport.dispose);

      expect(
        () => transport.send(
          BridgeEnvelope(
            schemaVersion: kBridgeSchemaVersion,
            messageId: 'm1',
            sessionId: 's1',
            attemptId: 'a1',
            levelDefinitionId: 'l1',
            revision: 0,
            type: BridgeMessageType.pause,
            payload: const <String, Object?>{},
          ),
        ),
        throwsStateError,
      );
    });
  });
}
