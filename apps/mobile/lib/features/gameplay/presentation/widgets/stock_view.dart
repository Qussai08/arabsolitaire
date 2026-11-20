import 'package:flutter/material.dart';
import 'package:game_engine/game_engine.dart';
import 'package:mobile/design_system/design_system.dart';
import 'package:mobile/features/gameplay/presentation/interaction/drag_payload.dart';
import 'package:mobile/features/gameplay/presentation/widgets/game_card_view.dart';

/// Stock pile, waste fan, and restore control inside the caller's well.
class StockView extends StatelessWidget {
  const StockView({
    super.key,
    required this.stock,
    required this.revision,
    required this.onAdvance,
    required this.onRestore,
    required this.onDropFromStock,
    this.highlightedCardId,
    this.associations = const {},
  });

  final StockState stock;
  final int revision;
  final VoidCallback onAdvance;
  final VoidCallback onRestore;
  final void Function(DragPayload payload) onDropFromStock;
  final String? highlightedCardId;
  final Map<AssociationId, AssociationDefinition> associations;

  @override
  Widget build(BuildContext context) {
    final text = MosaicTheme.of(context).text;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _captioned(
          text,
          _buildPile(),
          'السحب: ${ArabicDigits.format(stock.undealt.length)}',
        ),
        const SizedBox(width: MosaicSpacing.s12),
        Expanded(
          child: _captioned(text, _buildFan(), 'العلوية فقط قابلة للعب'),
        ),
        _captioned(text, _buildRestore(), 'استعادة الورق'),
      ],
    );
  }

  Widget _captioned(MosaicTextStyles text, Widget child, String caption) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        const SizedBox(height: MosaicSpacing.s6),
        Text(caption, style: text.labelS, textAlign: TextAlign.center),
      ],
    );
  }

  Widget _buildPile() {
    if (!stock.canAdvance) {
      return const MosaicDashedBorder(
        color: MosaicColors.line,
        strokeWidth: MosaicBorder.normal,
        radius: MosaicRadii.md,
        dashPattern: MosaicDash.slotEmpty,
        child: SizedBox(
          width: MosaicSizes.cardWidth,
          height: MosaicSizes.cardHeight,
          child: Center(
            child: MosaicIcon(
              MosaicIconKind.deck,
              size: 22,
              color: MosaicColors.textMuted,
            ),
          ),
        ),
      );
    }
    return GestureDetector(
      onTap: onAdvance,
      child: Semantics(
        label: 'سحب ورقة',
        button: true,
        child: const FaceDownCardView(),
      ),
    );
  }

  Widget _buildRestore() {
    final enabled = stock.canRestore;
    return Opacity(
      opacity: enabled ? 1 : MosaicOpacity.disabled,
      child: GestureDetector(
        onTap: enabled ? onRestore : null,
        child: Semantics(
          label: 'استعادة الورق',
          button: true,
          enabled: enabled,
          child: Container(
            width: MosaicSizes.minTouchTarget,
            height: MosaicSizes.minTouchTarget,
            decoration: BoxDecoration(
              color: MosaicColors.paper,
              shape: BoxShape.circle,
              border: Border.all(color: MosaicColors.line),
            ),
            child: const Center(
              child: MosaicIcon(MosaicIconKind.restart, size: 22),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFan() {
    final visible = stock.visibleCards;
    if (visible.isEmpty) {
      return const SizedBox(
        width: MosaicSizes.cardWidth,
        height: MosaicSizes.cardHeight,
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MosaicSizes.cardWidth * visible.length;
        final step = visible.length <= 1
            ? 0.0
            : ((maxWidth - MosaicSizes.cardWidth) / (visible.length - 1)).clamp(
                18.0,
                36.0,
              );
        return SizedBox(
          height: MosaicSizes.cardHeight,
          width: MosaicSizes.cardWidth + step * (visible.length - 1),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              for (var i = 0; i < visible.length; i++)
                PositionedDirectional(
                  start: step * i,
                  child: _wasteCard(
                    visible[i],
                    playable: i == visible.length - 1,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _wasteCard(GameCard card, {required bool playable}) {
    final view = GameCardView(
      card: card,
      highlighted: highlightedCardId == card.id,
      countLabel: _count(card),
    );
    if (!playable) {
      return Opacity(opacity: MosaicOpacity.disabled, child: view);
    }
    final payload = DragPayload(
      sourceType: DragSourceType.stock,
      sourceIndex: 0,
      revision: revision,
    );
    return Semantics(
      label: 'ورقة من المخزون',
      child: Draggable<DragPayload>(
        data: payload,
        feedback: Material(
          color: Colors.transparent,
          child: GameCardView(
            card: card,
            highlighted: true,
            countLabel: _count(card),
          ),
        ),
        childWhenDragging: Opacity(
          opacity: MosaicOpacity.disabled,
          child: view,
        ),
        child: view,
      ),
    );
  }

  String? _count(GameCard card) {
    if (card is! AssociationCard) {
      return null;
    }
    final definition = associations[card.associationId];
    if (definition == null) {
      return null;
    }
    return cardCountLabel(definition.requiredMemberCount);
  }
}
