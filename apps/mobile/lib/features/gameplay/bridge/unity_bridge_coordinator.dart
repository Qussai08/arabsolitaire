import 'dart:async';

import 'package:game_engine/game_engine.dart';

import 'package:mobile/features/gameplay/application/gameplay_bridge_host.dart';
import 'package:mobile/features/gameplay/application/gameplay_controller.dart';

import 'package:mobile/features/gameplay/application/gameplay_state.dart';

import 'package:mobile/features/gameplay/bridge/unity_bridge_transport.dart';

import 'package:unity_bridge_contracts/unity_bridge_contracts.dart';

/// Coordinates Unity bridge traffic around [GameplayController].

///

/// Never mutates [GameState] directly — only dispatches into the controller.

final class UnityBridgeCoordinator {
  UnityBridgeCoordinator({
    required this.controller,

    required this.transport,

    required this.sessionId,

    required this.attemptId,

    required this.levelDefinitionId,

    this.onPresentationCompleted,

    this.onExitRequested,
  }) : _session = BridgeSession(
         sessionId: sessionId,

         attemptId: attemptId,

         levelDefinitionId: levelDefinitionId,

         initialRevision: controller.revision,
       );

  final GameplayBridgeHost controller;

  final UnityBridgeTransport transport;

  final String sessionId;

  final String attemptId;

  final String levelDefinitionId;

  final void Function(int revision)? onPresentationCompleted;

  final Future<void> Function()? onExitRequested;

  final BridgeSession _session;

  StreamSubscription<BridgeEnvelope>? _subscription;

  bool _unityReady = false;

  var _exitInFlight = false;

  bool get unityReady => _unityReady;

  int get revision => _session.revision;

  Future<void> start() async {
    await _subscription?.cancel();

    _subscription = transport.inbound.listen(_onInbound);
  }

  Future<void> dispose() async {
    await _subscription?.cancel();

    _subscription = null;

    await transport.dispose();
  }

  Future<void> sendInitialize({
    bool musicEnabled = true,

    bool sfxEnabled = true,
  }) async {
    await transport.send(
      _session.buildOutbound(
        type: BridgeMessageType.initialize,

        payload: <String, Object?>{
          'presentationMode': 'unity3d',

          'audio': <String, Object?>{
            'musicEnabled': musicEnabled,

            'sfxEnabled': sfxEnabled,
          },
        },
      ),
    );
  }

  Future<void> sendStateSnapshot(GameState state) async {
    _session.restoreRevision(controller.revision);

    await transport.send(_session.snapshotEnvelope(state));
  }

  Future<void> sendPause() => transport.send(
    _session.buildOutbound(
      type: BridgeMessageType.pause,

      payload: const <String, Object?>{},
    ),
  );

  Future<void> sendResume() => transport.send(
    _session.buildOutbound(
      type: BridgeMessageType.resume,

      payload: const <String, Object?>{},
    ),
  );

  Future<void> sendShutdown() => transport.send(
    _session.buildOutbound(
      type: BridgeMessageType.shutdown,

      payload: const <String, Object?>{},
    ),
  );

  void _onInbound(BridgeEnvelope envelope) {
    switch (envelope.type) {
      case BridgeMessageType.unityReady:
        _handleUnityReady();

      case BridgeMessageType.actionIntent:
        _handleActionIntent(envelope);

      case BridgeMessageType.requestHint:
        unawaited(controller.requestHint());

      case BridgeMessageType.requestRestart:
        unawaited(controller.restart());

      case BridgeMessageType.requestExit:
        unawaited(_handleExitRequest());

      case BridgeMessageType.presentationCompleted:
        onPresentationCompleted?.call(envelope.revision);

      case BridgeMessageType.clientError:
        break;

      default:
        break;
    }
  }

  Future<void> _handleUnityReady() async {
    _unityReady = true;

    await sendInitialize();

    final playing = controller.viewState;

    if (playing is GameplayPlaying) {
      await sendStateSnapshot(playing.gameState);
    }
  }

  void _handleActionIntent(BridgeEnvelope envelope) {
    _session.restoreRevision(controller.revision);

    final result = _session.handleActionIntent(
      envelope: envelope,

      apply: (action) {
        final transition = controller.applyAction(action);

        if (transition != null) return transition;

        final state = _currentGameState();

        return GameTransition.rejected(
          previousState: state,

          nextState: state,

          reason: RejectionReason.stateInvariantViolation,

          events: const [],
        );
      },
    );

    _session.restoreRevision(controller.revision);

    switch (result) {
      case BridgeIntentApplied(:final response):
        unawaited(transport.send(response));

      case BridgeIntentRejected(:final error):
        unawaited(
          transport.send(
            _session.buildOutbound(
              type: BridgeMessageType.fatalError,

              payload: BridgePayloads.fatalError(
                code: 'intent_rejected',

                message: error.message,
              ),
            ),
          ),
        );
    }
  }

  Future<void> _handleExitRequest() async {
    if (_exitInFlight) {
      return;
    }

    _exitInFlight = true;

    final handler = onExitRequested;

    if (handler != null) {
      await handler();
    }
  }

  GameState _currentGameState() {
    final state = controller.viewState;

    return switch (state) {
      GameplayPlaying(:final gameState) => gameState,

      GameplayWon(:final gameState) => gameState,

      GameplayOutOfMoves(:final gameState) => gameState,

      GameplayConfirmedDeadEnd(:final gameState) => gameState,

      _ => throw StateError('No game state available for bridge intent'),
    };
  }
}
