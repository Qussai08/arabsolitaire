import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_engine/game_engine.dart';
import 'package:mobile/features/gameplay/application/gameplay_controller.dart';
import 'package:mobile/features/gameplay/application/gameplay_providers.dart';
import 'package:mobile/features/gameplay/application/gameplay_state.dart';
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

/// Main gameplay screen. The board is the Flutter Mosaic layout.
class GameplayScreen extends ConsumerStatefulWidget {
  const GameplayScreen({super.key});

  @override
  ConsumerState<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends ConsumerState<GameplayScreen> {
  @override
  Widget build(BuildContext context) {
    final viewState = ref.watch(gameplayControllerProvider);
    final controller = ref.read(gameplayControllerProvider.notifier);

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
        body: SafeArea(child: _buildBody(context, viewState, controller)),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    GameplayViewState viewState,
    GameplayController controller,
  ) {
    return switch (viewState) {
      GameplayLoading() => const _LoadingView(),
      GameplayPlaying() => _board(
        context,
        viewState.gameState,
        viewState.revision,
        controller,
        hintAction: viewState.hint.suggestedAction,
        hintPhase: viewState.hint.phase,
        deadEndChecking: viewState.deadEnd.phase == DeadEndPhase.checking,
      ),
      GameplayWon(:final gameState) ||
      GameplayOutOfMoves(:final gameState) ||
      GameplayConfirmedDeadEnd(:final gameState) => Stack(
        children: [
          _board(context, gameState, 0, controller, interactive: false),
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

  Widget _board(
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
