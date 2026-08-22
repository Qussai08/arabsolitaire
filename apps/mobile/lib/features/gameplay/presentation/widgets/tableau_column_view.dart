import 'package:flutter/material.dart';
import 'package:game_engine/game_engine.dart';
import 'package:mobile/features/gameplay/presentation/interaction/drag_payload.dart';
import 'package:mobile/features/gameplay/presentation/widgets/game_card_view.dart';

/// One Tableau column: hidden cards (face-down stack) + exposed draggable unit.
class TableauColumnView extends StatelessWidget {
  const TableauColumnView({
    super.key,
    required this.column,
    required this.columnIndex,
    required this.revision,
    required this.onDrop,
    this.highlightedCardId,
    this.isDropTarget = false,
  });

  final TableauColumn column;
  final int columnIndex;
  final int revision;
  final void Function(DragPayload payload) onDrop;
  final String? highlightedCardId;
  final bool isDropTarget;

  @override
  Widget build(BuildContext context) {
    return DragTarget<DragPayload>(
      onWillAcceptWithDetails: (details) => details.data.revision == revision,
      onAcceptWithDetails: (details) => onDrop(details.data),
      builder: (context, candidates, rejected) {
        final accepting = candidates.isNotEmpty && isDropTarget;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: double.infinity,
          decoration: BoxDecoration(
            color: accepting
                ? const Color(0xFF2A5C2A).withAlpha((255 * 0.3).round())
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // Hidden cards — compact stack
              for (final _ in column.hiddenCards)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: FaceDownCardView(isSmall: column.hiddenCards.length > 3),
                ),
              // Exposed unit — draggable
              if (column.exposedUnit != null)
                _buildExposedUnit(context, column.exposedUnit!)
              else if (column.hiddenCards.isEmpty)
                _buildEmptyColumn(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExposedUnit(BuildContext context, MovableUnit unit) {
    final card = unit.cards.first;
    final highlighted = highlightedCardId == card.id;
    final payload = DragPayload(
      sourceType: DragSourceType.tableau,
      sourceIndex: columnIndex,
      revision: revision,
    );

    return Draggable<DragPayload>(
      data: payload,
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: 72,
          child: GameCardView(card: card, highlighted: true),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: GameCardView(card: card, highlighted: highlighted),
      ),
      child: GameCardView(card: card, highlighted: highlighted),
    );
  }

  Widget _buildEmptyColumn() {
    return Container(
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFF3A5A8C).withAlpha((255 * 0.4).round()),
          width: 1.2,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
    );
  }
}
