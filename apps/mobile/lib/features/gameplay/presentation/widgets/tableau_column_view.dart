import 'package:flutter/material.dart';
import 'package:game_engine/game_engine.dart';
import 'package:mobile/design_system/design_system.dart';
import 'package:mobile/features/gameplay/presentation/interaction/drag_payload.dart';
import 'package:mobile/features/gameplay/presentation/widgets/game_card_view.dart';

/// One Tableau column: face-down stack, then the exposed unit overlapping by 34px.
class TableauColumnView extends StatelessWidget {
  const TableauColumnView({
    super.key,
    required this.column,
    required this.columnIndex,
    required this.revision,
    required this.onDrop,
    this.highlightedCardId,
    this.associations = const {},
  });

  final TableauColumn column;
  final int columnIndex;
  final int revision;
  final void Function(DragPayload payload) onDrop;
  final String? highlightedCardId;
  final Map<AssociationId, AssociationDefinition> associations;

  @override
  Widget build(BuildContext context) {
    return DragTarget<DragPayload>(
      onWillAcceptWithDetails: (details) => details.data.revision == revision,
      onAcceptWithDetails: (details) => onDrop(details.data),
      builder: (context, candidates, rejected) {
        final accepting = candidates.isNotEmpty;
        final unit = column.exposedUnit;
        final faces = <Widget>[
          for (final _ in column.hiddenCards) const FaceDownCardView(),
          if (unit != null)
            for (final card in unit.cards)
              GameCardView(
                card: card,
                highlighted: highlightedCardId == card.id && !accepting,
                validTarget: accepting && card == unit.cards.last,
                countLabel: _countLabel(card),
              ),
        ];

        if (faces.isEmpty) {
          return _EmptyColumn(accepting: accepting);
        }

        const strip = MosaicSpacing.columnStackVisibleStrip;
        final height = strip * (faces.length - 1) + MosaicSizes.cardHeight;
        final stack = SizedBox(
          width: MosaicSizes.cardWidth,
          height: height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              for (var i = 0; i < faces.length; i++)
                Positioned(
                  top: strip * i,
                  child: IgnorePointer(child: faces[i]),
                ),
            ],
          ),
        );

        if (unit == null) {
          return stack;
        }

        final payload = DragPayload(
          sourceType: DragSourceType.tableau,
          sourceIndex: columnIndex,
          revision: revision,
        );
        final top = unit.cards.last;
        return Draggable<DragPayload>(
          hitTestBehavior: HitTestBehavior.opaque,
          data: payload,
          feedback: Material(
            color: Colors.transparent,
            child: GameCardView(
              card: top,
              highlighted: true,
              countLabel: _countLabel(top),
            ),
          ),
          childWhenDragging: Opacity(
            opacity: MosaicOpacity.disabled,
            child: stack,
          ),
          child: stack,
        );
      },
    );
  }

  String? _countLabel(GameCard card) {
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

class _EmptyColumn extends StatelessWidget {
  const _EmptyColumn({required this.accepting});

  final bool accepting;

  @override
  Widget build(BuildContext context) {
    final text = MosaicTheme.of(context).text;
    return MosaicDashedBorder(
      color: accepting ? MosaicColors.emerald600 : MosaicColors.line,
      strokeWidth: accepting ? MosaicBorder.dropTarget : MosaicBorder.normal,
      radius: MosaicRadii.md,
      dashPattern: MosaicDash.slotEmpty,
      child: SizedBox(
        width: MosaicSizes.cardWidth,
        height: MosaicSizes.cardHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MosaicIcon(
              MosaicIconKind.plus,
              size: 22,
              color: accepting
                  ? MosaicColors.emerald600
                  : MosaicColors.textMuted,
            ),
            const SizedBox(height: MosaicSpacing.s4),
            Text('عمود فارغ', style: text.labelS, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
