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
import 'package:mobile/design_system/design_system.dart';
import 'package:mobile/features/economy/application/wallet_controller.dart';
import 'package:mobile/features/gameplay/presentation/widgets/association_slots_view.dart';
import 'package:mobile/features/gameplay/presentation/widgets/gameplay_chrome.dart';
import 'package:mobile/features/gameplay/presentation/widgets/gameplay_overlay.dart';
import 'package:mobile/features/gameplay/presentation/widgets/stock_view.dart';
import 'package:mobile/features/gameplay/presentation/widgets/tableau_view.dart';
import 'package:mobile/features/journey/data/journey_content.dart';
import 'package:mobile/features/journey/domain/journey_models.dart';
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
    if (requested != GameplayPresentationMode.unity3d ||
        _unityLaunchAttempted) {
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
        backgroundColor: MosaicColors.limestone,
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
      GameplayWon(:final gameState) ||
      GameplayOutOfMoves(:final gameState) ||
      GameplayConfirmedDeadEnd(:final gameState) => Stack(
        children: [
          _flutterBoard(context, gameState, 0, controller, interactive: false),
          GameplayOverlay(
            state: viewState,
            onRestart: controller.restart,
            onExit: () => Navigator.of(context).pop(),
          ),
        ],
      ),
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

    return _flutterBoard(
      context,
      state.gameState,
      state.revision,
      controller,
      hintAction: state.hint.suggestedAction,
      hintPhase: state.hint.phase,
      deadEndChecking: state.deadEnd.phase == DeadEndPhase.checking,
    );
  }

  Widget _flutterBoard(
    BuildContext context,
    GameState gameState,
    int revision,
    GameplayController controller, {
    GameAction? hintAction,
    HintPhase hintPhase = HintPhase.idle,
    bool deadEndChecking = false,
    bool interactive = true,
  }) {
    final wide = MediaQuery.sizeOf(context).width >= MosaicSizes.tabletWidth;
    final level =
        ref.watch(currentPlayingLevelProvider) ??
        JourneyContent.buildLevels().first;
    final chapter = JourneyContent.chapters
        .cast<ChapterDefinition?>()
        .firstWhere(
          (item) => item?.chapterId == level.chapterId,
          orElse: () => JourneyContent.chapters.first,
        );
    final wallet = ref.watch(walletControllerProvider);
    final readyWallet = wallet is WalletReady ? wallet.snapshot : null;
    final line = switch (hintPhase) {
      HintPhase.loading => 'أبحث عن حركة مناسبة…',
      HintPhase.available => 'جرّب البطاقة المظلّلة.',
      HintPhase.noResult => 'لا توجد حركة مقترحة',
      HintPhase.inconclusive => 'تعذر إيجاد تلميح الآن',
      HintPhase.idle => null,
    };

    final board = GameplayBoardLayout(
      header: GameplayTopBar(
        levelLabel: 'المستوى ${ArabicDigits.format(level.globalLevelNumber)}',
        chapterLabel: chapter?.titleAr ?? '',
        coins: readyWallet?.effectiveCoinBalance,
        onPause: interactive
            ? () {
                unawaited(
                  showGameplayPauseSheet(
                    context: context,
                    onRestart: () {
                      unawaited(controller.restart());
                    },
                    onExit: () => Navigator.of(context).pop(),
                  ),
                );
              }
            : () {},
      ),
      stats: GameplayStats(
        movesRemaining: gameState.movesRemaining,
        moveLimit: gameState.moveLimit,
        streakCurrent: gameState.streak.currentCounter,
        streakTarget: gameState.streak.targetTier,
      ),
      slots: AssociationSlotsView(
        slots: gameState.slots,
        revision: revision,
        vertical: wide,
        associations: gameState.associations,
        onDrop: (payload, slotIndex) {
          if (!interactive || payload.revision != revision) return;
          final action = payload.toSlotAction(slotIndex);
          if (action != null) controller.applyAction(action);
        },
        highlightedSlotIndex: _highlightedSlot(gameState, hintAction),
      ),
      tableau: TableauView(
        tableau: gameState.tableau,
        revision: revision,
        associations: gameState.associations,
        onDrop: (payload, targetColumn) {
          if (!interactive || payload.revision != revision) return;
          final action = payload.toTableauAction(targetColumn);
          if (action != null) controller.applyAction(action);
        },
        highlightedCardId: _highlightedCard(gameState, hintAction),
      ),
      stock: StockView(
        stock: gameState.stock,
        revision: revision,
        associations: gameState.associations,
        onAdvance: interactive
            ? () => controller.applyAction(const AdvanceStock())
            : () {},
        onRestore: interactive
            ? () => controller.applyAction(const RestoreStock())
            : () {},
        onDropFromStock: (_) {},
        highlightedCardId: _highlightedCard(gameState, hintAction),
      ),
      tools: GameplayBottomTools(
        canUndo: interactive && gameState.undo.available,
        hintLoading: hintPhase == HintPhase.loading,
        hintCount: readyWallet?.effectiveHintBalance,
        onHint: () {
          unawaited(controller.requestHint());
        },
        onUndo: () => controller.applyAction(const UndoLastMove()),
        onRestart: () {
          unawaited(controller.restart());
        },
      ),
      note: _boardNote(line, deadEndChecking),
    );
    if (!interactive) {
      return IgnorePointer(child: board);
    }
    return board;
  }

  Widget? _boardNote(String? line, bool deadEndChecking) {
    if (line == null && !deadEndChecking) {
      return null;
    }
    return Column(
      children: [
        if (line != null) MosaicShiboubBubble(line: line),
        if (deadEndChecking) ...[
          if (line != null) const SizedBox(height: MosaicSpacing.s8),
          const MosaicToast(
            tone: MosaicToastTone.info,
            title: 'جاري التحقق',
            message: 'نراجع إن كان للوضع مسار للفوز.',
          ),
        ],
      ],
    );
  }

  String? _highlightedCard(GameState gameState, GameAction? hintAction) {
    return switch (hintAction) {
      MoveTableauToTableau(:final fromColumn) ||
      MoveTableauToSlot(
        :final fromColumn,
      ) => gameState.tableau[fromColumn].exposedUnit?.cards.last.id,
      MoveStockToTableau() ||
      MoveStockToSlot() => gameState.stock.playableCard?.id,
      _ => null,
    };
  }

  int? _highlightedSlot(GameState gameState, GameAction? hintAction) {
    return switch (hintAction) {
      MoveStockToSlot(:final slotIndex) => slotIndex,
      _ => null,
    };
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
          CircularProgressIndicator(color: MosaicColors.emerald600),
          SizedBox(height: 16),
          Text(
            'جاري التجهيز...',
            style: TextStyle(
              color: MosaicColors.textMuted,
              fontFamily: MosaicFonts.readexPro,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

/// Shown while Unity Activity is foreground or reconnecting.
class _UnityActivePlaceholder extends StatelessWidget {
  const _UnityActivePlaceholder({required this.revision, required this.onExit});

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
  const _UnityLaunchingView({required this.phase, required this.onCancel});

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
