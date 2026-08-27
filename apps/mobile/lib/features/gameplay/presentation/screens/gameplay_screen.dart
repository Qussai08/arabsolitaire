import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_engine/game_engine.dart';
import 'package:mobile/features/gameplay/application/gameplay_controller.dart';
import 'package:mobile/features/gameplay/application/gameplay_presentation_mode.dart';
import 'package:mobile/features/gameplay/application/gameplay_presentation_providers.dart';
import 'package:mobile/features/gameplay/application/gameplay_providers.dart';
import 'package:mobile/features/gameplay/application/gameplay_state.dart';
import 'package:mobile/features/gameplay/bridge/unity_runtime_service.dart';
import 'package:mobile/features/gameplay/presentation/widgets/association_slots_view.dart';
import 'package:mobile/features/gameplay/presentation/widgets/gameplay_overlay.dart';
import 'package:mobile/features/gameplay/presentation/widgets/gameplay_toolbar.dart';
import 'package:mobile/features/gameplay/presentation/widgets/stock_view.dart';
import 'package:mobile/features/gameplay/presentation/widgets/tableau_view.dart';
import 'package:mobile/features/journey/presentation/screens/level_result_screen.dart';

/// Main gameplay screen — Sprint 4 vertical slice.
///
/// Default presentation is Flutter 2D. Unity 3D launches a native Activity when
/// [gameplayPresentationModeProvider] resolves to unity3d.
class GameplayScreen extends ConsumerStatefulWidget {
  const GameplayScreen({super.key});

  @override
  ConsumerState<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends ConsumerState<GameplayScreen>
    with WidgetsBindingObserver {
  var _unityLaunchAttempted = false;
  var _unityLaunchScheduled = false;

  void _scheduleUnityLaunch(GameplayPlaying state) {
    if (_unityLaunchAttempted || _unityLaunchScheduled) {
      return;
    }
    _unityLaunchScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _unityLaunchScheduled = false;
      if (!mounted) {
        return;
      }
      final current = ref.read(gameplayControllerProvider);
      if (current is GameplayPlaying) {
        unawaited(_maybeLaunchUnity(current));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_replaySnapshotOnResume());
    }
  }

  Future<void> _replaySnapshotOnResume() async {
    final service = ref.read(unityRuntimeServiceProvider);
    if (service == null) {
      return;
    }
    final playing = ref.read(gameplayControllerProvider);
    if (playing is GameplayPlaying) {
      // Coordinator resends authoritative state after background/resume.
      await service.launchIfActive(playing.gameState);
    }
  }

  Future<void> _maybeLaunchUnity(GameplayPlaying state) async {
    final requested = ref.read(gameplayPresentationModeProvider);
    if (requested != GameplayPresentationMode.unity3d || _unityLaunchAttempted) {
      return;
    }

    final service = ref.read(unityRuntimeServiceProvider);
    if (service == null) {
      ref.read(unityRuntimePhaseProvider.notifier).state =
          UnityRuntimePhase.error;
      ref.read(unityRuntimeErrorMessageProvider.notifier).state =
          'تعذر تهيئة خدمة Unity.';
      return;
    }

    _unityLaunchAttempted = true;
    await service.launch();
  }

  @override
  Widget build(BuildContext context) {
    final viewState = ref.watch(gameplayControllerProvider);
    final controller = ref.read(gameplayControllerProvider.notifier);
    final requestedMode = ref.watch(gameplayPresentationModeProvider);
    final unityPhase = ref.watch(unityRuntimePhaseProvider);
    final unityError = ref.watch(unityRuntimeErrorMessageProvider);

    if (viewState is GameplayPlaying &&
        requestedMode == GameplayPresentationMode.unity3d) {
      _scheduleUnityLaunch(viewState);
    }

    ref.listen<GameplayViewState>(gameplayControllerProvider, (prev, next) {
      if (next is GameplayWon && prev is! GameplayWon) {
        final level = ref.read(currentPlayingLevelProvider);
        if (level != null) {
          Navigator.of(context).push<void>(
            MaterialPageRoute(
              builder: (_) => LevelResultScreen(
                reward: next.reward,
                levelId: level.levelDefinitionId,
                globalLevelNumber: level.globalLevelNumber,
              ),
            ),
          );
        }
      }
    });

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF0A1628),
        body: SafeArea(
          child: _buildBody(
            context,
            viewState,
            controller,
            requestedMode,
            unityPhase,
            unityError,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    GameplayViewState viewState,
    GameplayController controller,
    GameplayPresentationMode requestedMode,
    UnityRuntimePhase unityPhase,
    String? unityError,
  ) {
    return switch (viewState) {
      GameplayLoading() => const _LoadingView(),
      GameplayPlaying() => _buildPlayingScreen(
        context,
        viewState,
        controller,
        requestedMode,
        unityPhase,
        unityError,
      ),
      GameplayWon() ||
      GameplayOutOfMoves() ||
      GameplayConfirmedDeadEnd() ||
      GameplayError() => GameplayOverlay(
        state: viewState,
        onRestart: controller.restart,
        onExit: () => Navigator.of(context).pop(),
      ),
    };
  }

  Widget _buildPlayingScreen(
    BuildContext context,
    GameplayPlaying state,
    GameplayController controller,
    GameplayPresentationMode requestedMode,
    UnityRuntimePhase unityPhase,
    String? unityError,
  ) {
    if (requestedMode == GameplayPresentationMode.unity3d) {
      if (unityPhase == UnityRuntimePhase.unavailable ||
          unityPhase == UnityRuntimePhase.error) {
        return _UnityRecoverableErrorView(
          message: unityError ?? 'تعذر تشغيل Unity.',
          onRetry: () async {
            _unityLaunchAttempted = false;
            ref.read(unityRuntimePhaseProvider.notifier).state =
                UnityRuntimePhase.idle;
            await _maybeLaunchUnity(state);
          },
          onFallbackToFlutter2d: () {
            ref.read(gameplayPresentationModeProvider.notifier).state =
                GameplayPresentationMode.flutter2d;
            ref.read(unityRuntimePhaseProvider.notifier).state =
                UnityRuntimePhase.idle;
          },
          onExit: () => Navigator.of(context).pop(),
        );
      }

      if (unityPhase == UnityRuntimePhase.active) {
        return _UnityActivePlaceholder(
          revision: state.revision,
          onExit: () => Navigator.of(context).pop(),
        );
      }

      return _UnityLaunchingView(
        phase: unityPhase,
        onCancel: () {
          ref.read(gameplayPresentationModeProvider.notifier).state =
              GameplayPresentationMode.flutter2d;
          ref.read(unityRuntimePhaseProvider.notifier).state =
              UnityRuntimePhase.idle;
        },
      );
    }

    return Column(
      children: [
        GameplayToolbar(
          state: state,
          onUndo: () => controller.applyAction(const UndoLastMove()),
          onHint: controller.requestHint,
        ),
        Expanded(
          child: _buildBoard(
            context,
            state.gameState,
            state.revision,
            controller,
            hintAction: state.hint.suggestedAction,
          ),
        ),
        if (state.hint.phase == HintPhase.noResult)
          const _HintBanner(text: 'لا توجد حركة مقترحة'),
        if (state.hint.phase == HintPhase.inconclusive)
          const _HintBanner(text: 'تعذر إيجاد تلميح الآن'),
        if (state.deadEnd.phase == DeadEndPhase.checking)
          const _DeadEndCheckIndicator(),
      ],
    );
  }

  Widget _buildBoard(
    BuildContext context,
    GameState gameState,
    int revision,
    GameplayController controller, {
    GameAction? hintAction,
  }) {
    String? highlightedCardId;
    int? highlightedSlotIndex;

    if (hintAction != null) {
      switch (hintAction) {
        case MoveTableauToTableau(:final fromColumn):
          highlightedCardId =
              gameState.tableau[fromColumn].exposedUnit?.cards.first.id;
        case MoveTableauToSlot(:final fromColumn):
          highlightedCardId =
              gameState.tableau[fromColumn].exposedUnit?.cards.first.id;
        case MoveStockToTableau():
          highlightedCardId = gameState.stock.playableCard?.id;
        case MoveStockToSlot(:final slotIndex):
          highlightedCardId = gameState.stock.playableCard?.id;
          highlightedSlotIndex = slotIndex;
        default:
          break;
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          AssociationSlotsView(
            slots: gameState.slots,
            revision: revision,
            onDrop: (payload, slotIndex) {
              if (payload.revision != revision) return;
              final action = payload.toSlotAction(slotIndex);
              if (action != null) controller.applyAction(action);
            },
            highlightedSlotIndex: highlightedSlotIndex,
          ),
          const SizedBox(height: 14),
          TableauView(
            tableau: gameState.tableau,
            revision: revision,
            onDrop: (payload, targetColumn) {
              if (payload.revision != revision) return;
              final action = payload.toTableauAction(targetColumn);
              if (action != null) controller.applyAction(action);
            },
            highlightedCardId: highlightedCardId,
          ),
          const SizedBox(height: 16),
          StockView(
            stock: gameState.stock,
            revision: revision,
            onAdvance: () => controller.applyAction(const AdvanceStock()),
            onRestore: () => controller.applyAction(const RestoreStock()),
            onDropFromStock: (_) {},
            highlightedCardId: highlightedCardId,
          ),
        ],
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: Color(0xFF4ECDC4)),
          SizedBox(height: 16),
          Text(
            'جاري التجهيز...',
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _HintBanner extends StatelessWidget {
  const _HintBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A2D50),
      padding: const EdgeInsets.symmetric(vertical: 6),
      width: double.infinity,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white54, fontSize: 13),
      ),
    );
  }
}

class _DeadEndCheckIndicator extends StatelessWidget {
  const _DeadEndCheckIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A1A2D),
      padding: const EdgeInsets.symmetric(vertical: 4),
      width: double.infinity,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white30,
            ),
          ),
          SizedBox(width: 8),
          Text(
            'جاري التحقق...',
            style: TextStyle(color: Colors.white30, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

/// Shown while Unity Activity is foreground or reconnecting.
class _UnityActivePlaceholder extends StatelessWidget {
  const _UnityActivePlaceholder({
    required this.revision,
    required this.onExit,
  });

  final int revision;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: Color(0xFF4ECDC4)),
          const SizedBox(height: 16),
          Text(
            'Unity نشط — المراجعة $revision',
            style: const TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: onExit, child: const Text('خروج')),
        ],
      ),
    );
  }
}

class _UnityLaunchingView extends StatelessWidget {
  const _UnityLaunchingView({
    required this.phase,
    required this.onCancel,
  });

  final UnityRuntimePhase phase;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final label = switch (phase) {
      UnityRuntimePhase.checkingAvailability => 'جاري التحقق من Unity...',
      UnityRuntimePhase.launching => 'جاري فتح Unity...',
      UnityRuntimePhase.waitingReady => 'جاري تهيئة اللوحة...',
      _ => 'جاري التحميل...',
    };

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: Color(0xFF4ECDC4)),
          const SizedBox(height: 16),
          Text(label, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          TextButton(onPressed: onCancel, child: const Text('إلغاء')),
        ],
      ),
    );
  }
}

class _UnityRecoverableErrorView extends StatelessWidget {
  const _UnityRecoverableErrorView({
    required this.message,
    required this.onRetry,
    required this.onFallbackToFlutter2d,
    required this.onExit,
  });

  final String message;
  final VoidCallback onRetry;
  final VoidCallback onFallbackToFlutter2d;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: onRetry,
              child: const Text('إعادة المحاولة'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: onFallbackToFlutter2d,
              child: const Text('العب بالعرض الثنائي الأبعاد'),
            ),
            const SizedBox(height: 12),
            TextButton(onPressed: onExit, child: const Text('خروج')),
          ],
        ),
      ),
    );
  }
}
