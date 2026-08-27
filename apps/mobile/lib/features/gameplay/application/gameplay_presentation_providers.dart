import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/gameplay/application/gameplay_presentation_mode.dart';
import 'package:mobile/features/gameplay/bridge/unity_runtime_service.dart';

/// Default remains Flutter 2D until Unity is explicitly requested.
/// Pass `--dart-define=FORCE_UNITY3D=true` to launch Unity presentation in debug runs.
final gameplayPresentationModeProvider =
    StateProvider<GameplayPresentationMode>(
      (_) => const bool.fromEnvironment('FORCE_UNITY3D')
          ? GameplayPresentationMode.unity3d
          : GameplayPresentationMode.flutter2d,
    );

/// Set when Unity presentationCompleted handshake completes.
final unityRuntimeReadyProvider = StateProvider<bool>((_) => false);

/// Effective mode used by widgets that require an active Unity presentation surface.
final effectiveGameplayPresentationModeProvider =
    Provider<GameplayPresentationMode>((ref) {
      final requested = ref.watch(gameplayPresentationModeProvider);
      final phase = ref.watch(unityRuntimePhaseProvider);
      if (requested == GameplayPresentationMode.unity3d &&
          phase == UnityRuntimePhase.active) {
        return GameplayPresentationMode.unity3d;
      }
      return GameplayPresentationMode.flutter2d;
    });

/// True when user requested Unity and launch is in progress or active.
final unityLaunchRequestedProvider = Provider<bool>((ref) {
  final requested = ref.watch(gameplayPresentationModeProvider);
  if (requested != GameplayPresentationMode.unity3d) {
    return false;
  }
  final phase = ref.watch(unityRuntimePhaseProvider);
  return phase != UnityRuntimePhase.idle &&
      phase != UnityRuntimePhase.exited &&
      phase != UnityRuntimePhase.unavailable;
});
