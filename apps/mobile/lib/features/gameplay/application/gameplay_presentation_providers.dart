import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/gameplay/application/gameplay_presentation_mode.dart';

/// Default remains Flutter 2D until Unity readiness gates pass.
final gameplayPresentationModeProvider =
    StateProvider<GameplayPresentationMode>(
      (_) => GameplayPresentationMode.flutter2d,
    );

/// Set when the Unity runtime signals ready for the current attempt.
final unityRuntimeReadyProvider = StateProvider<bool>((_) => false);

/// Effective mode: unity3d only when flagged and runtime is ready.
final effectiveGameplayPresentationModeProvider =
    Provider<GameplayPresentationMode>((ref) {
      final requested = ref.watch(gameplayPresentationModeProvider);
      final unityReady = ref.watch(unityRuntimeReadyProvider);
      if (requested == GameplayPresentationMode.unity3d && unityReady) {
        return GameplayPresentationMode.unity3d;
      }
      return GameplayPresentationMode.flutter2d;
    });
