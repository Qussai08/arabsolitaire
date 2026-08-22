import 'package:game_engine/game_engine.dart';

/// Drag-and-drop payload for board interactions.
///
/// [revision] is checked at drop time to discard stale payloads.
final class DragPayload {
  const DragPayload({
    required this.sourceType,
    required this.sourceIndex,
    required this.revision,
  });

  final DragSourceType sourceType;
  final int sourceIndex;
  final int revision;

  /// Build the appropriate action for a Tableau column drop target.
  GameAction? toTableauAction(int targetColumn) {
    return switch (sourceType) {
      DragSourceType.tableau => MoveTableauToTableau(
          fromColumn: sourceIndex,
          toColumn: targetColumn,
        ),
      DragSourceType.stock =>
        MoveStockToTableau(toColumn: targetColumn),
    };
  }

  /// Build the appropriate action for an Association Slot drop target.
  GameAction? toSlotAction(int slotIndex) {
    return switch (sourceType) {
      DragSourceType.tableau =>
        MoveTableauToSlot(fromColumn: sourceIndex, slotIndex: slotIndex),
      DragSourceType.stock =>
        MoveStockToSlot(slotIndex: slotIndex),
    };
  }
}

enum DragSourceType { tableau, stock }
