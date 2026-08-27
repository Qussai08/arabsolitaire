import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_engine/game_engine.dart';
import 'package:mobile/features/gameplay/application/gameplay_controller.dart';
import 'package:mobile/features/gameplay/application/gameplay_providers.dart';
import 'package:mobile/features/gameplay/application/gameplay_state.dart';
import 'package:mobile/features/gameplay/application/gameplay_presentation_providers.dart';
import 'package:mobile/features/gameplay/bridge/android_unity_bridge_transport.dart';
import 'package:mobile/features/gameplay/bridge/unity_bridge_coordinator.dart';
import 'package:mobile/features/gameplay/bridge/unity_bridge_transport.dart';
import 'package:unity_bridge_contracts/unity_bridge_contracts.dart';

enum UnityRuntimePhase {
  idle,
  checkingAvailability,
  unavailable,
  launching,
  waitingReady,
  active,
  error,
  exited,
}

final unityRuntimeAvailabilityProvider = FutureProvider<bool>((ref) async {
  if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
    return false;
  }
  return AndroidUnityBridgeTransport.isNativeAvailable();
});

final unityRuntimePhaseProvider = StateProvider<UnityRuntimePhase>(
  (_) => UnityRuntimePhase.idle,
);

final unityRuntimeErrorMessageProvider = StateProvider<String?>((_) => null);

/// Owns Unity bridge lifecycle for the current gameplay attempt.
final class UnityRuntimeService {
  UnityRuntimeService({
    required this.ref,
    required this.controller,
    required this.levelDefinitionId,
    required this.chapterId,
    required this.attemptId,
    this.readyTimeout = const Duration(seconds: 30),
  });

  final Ref ref;
  final GameplayController controller;
  final String levelDefinitionId;
  final String chapterId;
  final String attemptId;
  final Duration readyTimeout;

  UnityBridgeCoordinator? _coordinator;
  UnityBridgeTransport? _transport;
  Timer? _readyTimer;
  var _exitHandled = false;

  String get sessionId => '$levelDefinitionId:$attemptId';

  Future<bool> launch() async {
    ref.read(unityRuntimePhaseProvider.notifier).state =
        UnityRuntimePhase.checkingAvailability;

    final available = await ref.read(unityRuntimeAvailabilityProvider.future);
    if (!available) {
      ref.read(unityRuntimePhaseProvider.notifier).state =
          UnityRuntimePhase.unavailable;
      ref.read(unityRuntimeErrorMessageProvider.notifier).state =
          'تعذر تشغيل Unity على هذا الجهاز (يتطلب arm64-v8a).';
      return false;
    }

    final playing = controller.viewState;
    if (playing is! GameplayPlaying) {
      ref.read(unityRuntimePhaseProvider.notifier).state = UnityRuntimePhase.error;
      ref.read(unityRuntimeErrorMessageProvider.notifier).state =
          'اللعب غير جاهز بعد.';
      return false;
    }

    ref.read(unityRuntimePhaseProvider.notifier).state =
        UnityRuntimePhase.launching;

    final transport = AndroidUnityBridgeTransport();
    _transport = transport;
    await transport.startListening();

    _coordinator = UnityBridgeCoordinator(
      controller: controller,
      transport: transport,
      sessionId: sessionId,
      attemptId: attemptId,
      levelDefinitionId: levelDefinitionId,
      onPresentationCompleted: (revision) {
        ref.read(unityRuntimeReadyProvider.notifier).state = true;
        ref.read(unityRuntimePhaseProvider.notifier).state =
            UnityRuntimePhase.active;
        _readyTimer?.cancel();
      },
      onExitRequested: _handleExitRequested,
    );
    await _coordinator!.start();

    _readyTimer?.cancel();
    _readyTimer = Timer(readyTimeout, () {
      if (ref.read(unityRuntimePhaseProvider) == UnityRuntimePhase.waitingReady) {
        ref.read(unityRuntimePhaseProvider.notifier).state =
            UnityRuntimePhase.error;
        ref.read(unityRuntimeErrorMessageProvider.notifier).state =
            'انتهت مهلة تهيئة Unity.';
      }
    });

    ref.read(unityRuntimePhaseProvider.notifier).state =
        UnityRuntimePhase.waitingReady;

    try {
      await transport.openGameplay(
        sessionId: sessionId,
        attemptId: attemptId,
        levelDefinitionId: levelDefinitionId,
        chapterId: chapterId,
      );
      return true;
    } catch (error) {
      ref.read(unityRuntimePhaseProvider.notifier).state =
          UnityRuntimePhase.error;
      ref.read(unityRuntimeErrorMessageProvider.notifier).state =
          'تعذر فتح Unity.';
      await dispose();
      return false;
    }
  }

  Future<void> _handleExitRequested() async {
    if (_exitHandled) {
      return;
    }
    _exitHandled = true;

    final coordinator = _coordinator;
    if (coordinator != null) {
      final playing = controller.viewState;
      if (playing is GameplayPlaying) {
        await coordinator.sendStateSnapshot(playing.gameState);
      }
      await coordinator.sendShutdown();
    }

    if (_transport is AndroidUnityBridgeTransport) {
      await (_transport! as AndroidUnityBridgeTransport).finishUnityActivity();
    }

    ref.read(unityRuntimePhaseProvider.notifier).state = UnityRuntimePhase.exited;
    ref.read(unityRuntimeReadyProvider.notifier).state = false;
  }

  Future<void> dispose() async {
    _readyTimer?.cancel();
    _readyTimer = null;
    await _coordinator?.dispose();
    _coordinator = null;
    await _transport?.dispose();
    _transport = null;
  }

  Future<void> launchIfActive(GameState state) async {
    final coordinator = _coordinator;
    if (coordinator == null || !coordinator.unityReady) {
      return;
    }
    await coordinator.sendStateSnapshot(state);
  }
}

final unityRuntimeServiceProvider = Provider.autoDispose<UnityRuntimeService?>(
  (ref) {
    final controller = ref.watch(gameplayControllerProvider.notifier);
    final viewState = ref.watch(gameplayControllerProvider);
    if (viewState is! GameplayPlaying) {
      return null;
    }

    final level = ref.resolvePlayingLevel();
    return UnityRuntimeService(
      ref: ref,
      controller: controller,
      levelDefinitionId: level.levelDefinitionId,
      chapterId: level.chapterId,
      attemptId: viewState.gameState.attemptId,
    );
  },
);
