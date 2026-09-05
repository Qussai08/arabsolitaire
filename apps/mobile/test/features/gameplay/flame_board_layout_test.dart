import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:game_engine/game_engine.dart';
import 'package:mobile/features/gameplay/presentation/flame/flame_board_layout.dart';
import 'package:mobile/features/gameplay/presentation/interaction/drag_payload.dart';

void main() {
  group('FlameBoardLayout', () {
    test('fits RTL tableau, slots, and stock inside a portrait board', () {
      final state = _testState();
      final layout = FlameBoardLayout.calculate(const Size(390, 720), state);

      expect(layout.tableauRects, hasLength(state.tableau.length));
      expect(layout.slotRects, hasLength(state.slots.length));
      expect(layout.wasteCardRects, hasLength(state.stock.visibleCards.length));
      expect(
        layout.tableauRects.first.left,
        greaterThan(layout.tableauRects.last.left),
      );

      for (final rect in [
        ...layout.tableauRects,
        ...layout.slotRects,
        layout.stockPileRect,
        ...layout.wasteCardRects,
      ]) {
        expect(rect.left, greaterThanOrEqualTo(0));
        expect(rect.right, lessThanOrEqualTo(390));
      }
    });

    test('maps exposed cards and playable stock to revisioned payloads', () {
      final state = _testState();
      final layout = FlameBoardLayout.calculate(const Size(390, 720), state);

      final tableauSource = layout.sourceAt(
        layout.exposedUnitRects.first!.center,
        7,
      );
      final stockSource = layout.sourceAt(layout.wasteCardRects.last.center, 7);

      expect(tableauSource?.sourceType, DragSourceType.tableau);
      expect(tableauSource?.sourceIndex, 0);
      expect(tableauSource?.revision, 7);
      expect(stockSource?.sourceType, DragSourceType.stock);
      expect(stockSource?.revision, 7);
    });

    test('fits five association slots on a narrow phone', () {
      final base = _testState();
      final state = GameState(
        attemptId: base.attemptId,
        levelDefinitionId: base.levelDefinitionId,
        associations: base.associations,
        tableau: base.tableau,
        stock: base.stock,
        slots: const [
          AssociationSlot(index: 0),
          AssociationSlot(index: 1),
          AssociationSlot(index: 2),
          AssociationSlot(index: 3),
          AssociationSlot(index: 4),
        ],
        moveLimit: base.moveLimit,
        movesRemaining: base.movesRemaining,
      );
      final layout = FlameBoardLayout.calculate(const Size(320, 600), state);

      expect(layout.slotRects.first.left, greaterThanOrEqualTo(0));
      expect(layout.slotRects.last.right, lessThanOrEqualTo(320));
    });

    test('resolves drop targets into authoritative engine actions', () {
      const tableauPayload = DragPayload(
        sourceType: DragSourceType.tableau,
        sourceIndex: 0,
        revision: 2,
      );
      const stockPayload = DragPayload(
        sourceType: DragSourceType.stock,
        sourceIndex: 0,
        revision: 2,
      );

      expect(
        FlameBoardLayout.resolveAction(
          tableauPayload,
          const FlameTableauTarget(1),
        ),
        const MoveTableauToTableau(fromColumn: 0, toColumn: 1),
      );
      expect(
        FlameBoardLayout.resolveAction(stockPayload, const FlameSlotTarget(0)),
        const MoveStockToSlot(slotIndex: 0),
      );
      expect(
        FlameBoardLayout.resolveAction(
          tableauPayload,
          const FlameTableauTarget(0),
        ),
        isNull,
      );
    });
  });
}

GameState _testState() {
  const firstMember = MemberCard(id: 'شمس', associationId: 'sky');
  const secondMember = MemberCard(id: 'قمر', associationId: 'sky');
  const association = AssociationCard(id: 'السماء', associationId: 'sky');
  return GameState(
    attemptId: 'attempt',
    levelDefinitionId: 'level',
    associations: const {},
    tableau: [
      columnWithTop(firstMember),
      columnWithTop(association),
      const TableauColumn(),
    ],
    stock: const StockState(waste: [secondMember]),
    slots: const [AssociationSlot(index: 0), AssociationSlot(index: 1)],
    moveLimit: 20,
    movesRemaining: 20,
  );
}
