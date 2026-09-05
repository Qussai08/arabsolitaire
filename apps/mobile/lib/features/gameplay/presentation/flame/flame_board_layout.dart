import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:game_engine/game_engine.dart';
import 'package:mobile/features/gameplay/presentation/interaction/drag_payload.dart';

@immutable
sealed class FlameDropTarget {
  const FlameDropTarget();
}

final class FlameTableauTarget extends FlameDropTarget {
  const FlameTableauTarget(this.columnIndex);

  final int columnIndex;
}

final class FlameSlotTarget extends FlameDropTarget {
  const FlameSlotTarget(this.slotIndex);

  final int slotIndex;
}

/// Geometry shared by Flame rendering and Flutter pointer handling.
@immutable
final class FlameBoardLayout {
  const FlameBoardLayout({
    required this.size,
    required this.cardSize,
    required this.slotRects,
    required this.tableauRects,
    required this.exposedUnitRects,
    required this.stockPileRect,
    required this.wasteCardRects,
    required this.hiddenCardOffset,
    required this.unitCardOffset,
  });

  factory FlameBoardLayout.calculate(Size size, GameState state) {
    const edge = 12.0;
    const columnGap = 5.0;
    final columnCount = math.max(1, state.tableau.length);
    final availableWidth = math.max(1.0, size.width - edge * 2);
    final fittedWidth =
        (availableWidth - columnGap * (columnCount - 1)) / columnCount;
    final cardWidth = math.min(82.0, math.max(30.0, fittedWidth));
    final cardHeight = cardWidth * 1.28;
    final cardSize = Size(cardWidth, cardHeight);

    final slotCount = math.max(1, state.slots.length);
    const preferredSlotGap = 8.0;
    final fittedSlotWidth =
        (availableWidth - preferredSlotGap * (slotCount - 1)) / slotCount;
    final slotWidth = math.min(cardWidth, math.max(30.0, fittedSlotWidth));
    final slotHeight = slotWidth * 1.28;
    final slotGap = math.min(preferredSlotGap, slotWidth * 0.18);
    final slotRowWidth = slotWidth * slotCount + slotGap * (slotCount - 1);
    final slotStartX = (size.width - slotRowWidth) / 2;
    const slotY = 22.0;
    final slotRects = <Rect>[
      for (var i = 0; i < state.slots.length; i++)
        Rect.fromLTWH(
          slotStartX + i * (slotWidth + slotGap),
          slotY,
          slotWidth,
          slotHeight,
        ),
    ];

    final tableauY = slotY + slotHeight + 34;
    final idealStockY = size.height - cardHeight - 28;
    final stockY = math.max(tableauY + cardHeight + 28, idealStockY);
    final targetHeight = math.max(cardHeight, stockY - tableauY - 20);
    final tableauRects = <Rect>[];
    final exposedUnitRects = <Rect?>[];
    const hiddenOffset = 8.0;
    final unitOffset = math.max(12.0, cardHeight * 0.19);

    for (var i = 0; i < state.tableau.length; i++) {
      final x = size.width - edge - cardWidth - i * (cardWidth + columnGap);
      final target = Rect.fromLTWH(x, tableauY, cardWidth, targetHeight);
      tableauRects.add(target);

      final column = state.tableau[i];
      final unit = column.exposedUnit;
      if (unit == null) {
        exposedUnitRects.add(null);
      } else {
        final y = tableauY + column.hiddenCards.length * hiddenOffset;
        final height = cardHeight + (unit.cards.length - 1) * unitOffset;
        exposedUnitRects.add(Rect.fromLTWH(x, y, cardWidth, height));
      }
    }

    final stockPileRect = Rect.fromLTWH(
      size.width - edge - cardWidth,
      stockY,
      cardWidth,
      cardHeight,
    );
    final wasteCardRects = <Rect>[];
    final fanOffset = math.min(cardWidth * 0.42, 28.0);
    for (var i = 0; i < state.stock.visibleCards.length; i++) {
      wasteCardRects.add(
        Rect.fromLTWH(
          stockPileRect.left - 12 - cardWidth - i * fanOffset,
          stockY,
          cardWidth,
          cardHeight,
        ),
      );
    }

    return FlameBoardLayout(
      size: size,
      cardSize: cardSize,
      slotRects: slotRects,
      tableauRects: tableauRects,
      exposedUnitRects: exposedUnitRects,
      stockPileRect: stockPileRect,
      wasteCardRects: wasteCardRects,
      hiddenCardOffset: hiddenOffset,
      unitCardOffset: unitOffset,
    );
  }

  final Size size;
  final Size cardSize;
  final List<Rect> slotRects;
  final List<Rect> tableauRects;
  final List<Rect?> exposedUnitRects;
  final Rect stockPileRect;
  final List<Rect> wasteCardRects;
  final double hiddenCardOffset;
  final double unitCardOffset;

  DragPayload? sourceAt(Offset point, int revision) {
    for (var i = 0; i < exposedUnitRects.length; i++) {
      if (exposedUnitRects[i]?.contains(point) ?? false) {
        return DragPayload(
          sourceType: DragSourceType.tableau,
          sourceIndex: i,
          revision: revision,
        );
      }
    }
    if (wasteCardRects.isNotEmpty && wasteCardRects.last.contains(point)) {
      return DragPayload(
        sourceType: DragSourceType.stock,
        sourceIndex: 0,
        revision: revision,
      );
    }
    return null;
  }

  FlameDropTarget? dropTargetAt(Offset point) {
    for (var i = 0; i < slotRects.length; i++) {
      if (slotRects[i].contains(point)) return FlameSlotTarget(i);
    }
    for (var i = 0; i < tableauRects.length; i++) {
      if (tableauRects[i].contains(point)) return FlameTableauTarget(i);
    }
    return null;
  }

  Rect? sourceRect(DragPayload payload) {
    return switch (payload.sourceType) {
      DragSourceType.tableau => exposedUnitRects[payload.sourceIndex],
      DragSourceType.stock =>
        wasteCardRects.isEmpty ? null : wasteCardRects.last,
    };
  }

  static GameAction? resolveAction(
    DragPayload payload,
    FlameDropTarget target,
  ) {
    return switch (target) {
      FlameTableauTarget(:final columnIndex) =>
        payload.sourceType == DragSourceType.tableau &&
                payload.sourceIndex == columnIndex
            ? null
            : payload.toTableauAction(columnIndex),
      FlameSlotTarget(:final slotIndex) => payload.toSlotAction(slotIndex),
    };
  }
}
