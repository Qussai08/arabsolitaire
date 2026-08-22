import 'package:flutter/material.dart';
import 'package:game_engine/game_engine.dart';
import 'package:mobile/features/gameplay/presentation/interaction/drag_payload.dart';
import 'package:mobile/features/gameplay/presentation/widgets/tableau_column_view.dart';

/// Horizontal row of Tableau columns.
class TableauView extends StatelessWidget {
  const TableauView({
    super.key,
    required this.tableau,
    required this.revision,
    required this.onDrop,
    this.highlightedCardId,
  });

  final List<TableauColumn> tableau;
  final int revision;
  final void Function(DragPayload payload, int targetColumn) onDrop;
  final String? highlightedCardId;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < tableau.length; i++)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: TableauColumnView(
                column: tableau[i],
                columnIndex: i,
                revision: revision,
                onDrop: (payload) => onDrop(payload, i),
                highlightedCardId: highlightedCardId,
              ),
            ),
          ),
      ],
    );
  }
}
