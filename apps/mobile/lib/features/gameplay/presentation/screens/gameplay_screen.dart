import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_engine/game_engine.dart';
import 'package:mobile/features/gameplay/application/gameplay_controller.dart';
import 'package:mobile/features/gameplay/application/gameplay_presentation_mode.dart';
import 'package:mobile/features/gameplay/application/gameplay_presentation_providers.dart';
import 'package:mobile/features/gameplay/application/gameplay_providers.dart';
import 'package:mobile/features/gameplay/application/gameplay_state.dart';
import 'package:mobile/features/gameplay/presentation/widgets/association_slots_view.dart';
import 'package:mobile/features/gameplay/presentation/widgets/gameplay_overlay.dart';
import 'package:mobile/features/gameplay/presentation/widgets/gameplay_toolbar.dart';
import 'package:mobile/features/gameplay/presentation/widgets/stock_view.dart';
import 'package:mobile/features/gameplay/presentation/widgets/tableau_view.dart';
import 'package:mobile/features/journey/presentation/screens/level_result_screen.dart';

/// Main gameplay screen — Sprint 4 vertical slice.
///
/// Default presentation is Flutter 2D. Unity 3D is feature-flagged and only
/// used when [effectiveGameplayPresentationModeProvider] resolves to unity3d.
class GameplayScreen extends ConsumerWidget {
  const GameplayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewState = ref.watch(gameplayControllerProvider);
    final controller = ref.read(gameplayControllerProvider.notifier);
    final presentation = ref.watch(effectiveGameplayPresentationModeProvider);

    // Navigate to LevelResultScreen when the player wins.
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
          child: _buildBody(context, viewState, controller, presentation),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    GameplayViewState viewState,
    GameplayController controller,
    GameplayPresentationMode presentation,
  ) {
    return switch (viewState) {
      GameplayLoading() => const _LoadingView(),
      GameplayPlaying() => _buildPlayingScreen(
        context,
        viewState,
        controller,
        presentation,
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
    GameplayPresentationMode presentation,
  ) {
    // Phase 1: Unity host is a readiness placeholder; Flutter 2D remains the
    // playable surface until native embed lands.
    if (presentation == GameplayPresentationMode.unity3d) {
      return _UnityHostPlaceholder(
        revision: state.revision,
        movesRemaining: state.gameState.movesRemaining,
        onExit: () => Navigator.of(context).pop(),
        onFallbackToFlutter2d: () {
          // Parent listens via provider; placeholder just documents intent.
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

/// Placeholder host shown when unity3d mode is selected and marked ready.
/// Native Unity-as-a-Library embedding lands in a later phase.
class _UnityHostPlaceholder extends StatelessWidget {
  const _UnityHostPlaceholder({
    required this.revision,
    required this.movesRemaining,
    required this.onExit,
    required this.onFallbackToFlutter2d,
  });

  final int revision;
  final int movesRemaining;
  final VoidCallback onExit;
  final VoidCallback onFallbackToFlutter2d;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Unity 3D',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'وضع العرض التجريبي — المراجعة $revision',
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'الحركات المتبقية: $movesRemaining',
              style: const TextStyle(color: Colors.white54),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: onFallbackToFlutter2d,
              child: const Text('العودة إلى العرض الثنائي الأبعاد'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: onExit,
              child: const Text('خروج'),
            ),
          ],
        ),
      ),
    );
  }
}
