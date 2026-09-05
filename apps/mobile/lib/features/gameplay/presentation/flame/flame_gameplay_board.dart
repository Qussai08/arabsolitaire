import 'dart:math' as math;

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:game_engine/game_engine.dart';
import 'package:mobile/features/gameplay/presentation/flame/flame_board_layout.dart';
import 'package:mobile/features/gameplay/presentation/interaction/drag_payload.dart';

/// Hosts the lightweight Flame renderer while Flutter keeps app-level UI.
class FlameGameplayBoard extends StatefulWidget {
  const FlameGameplayBoard({
    super.key,
    required this.gameState,
    required this.revision,
    required this.onAction,
    this.hintAction,
  });

  final GameState gameState;
  final int revision;
  final GameAction? hintAction;
  final ValueChanged<GameAction> onAction;

  @override
  State<FlameGameplayBoard> createState() => _FlameGameplayBoardState();
}

class _FlameGameplayBoardState extends State<FlameGameplayBoard> {
  late final ArabSolitaireFlameGame _game;

  @override
  void initState() {
    super.initState();
    _game = ArabSolitaireFlameGame(
      gameState: widget.gameState,
      revision: widget.revision,
      hintAction: widget.hintAction,
      onAction: (action) => widget.onAction(action),
    );
  }

  @override
  void didUpdateWidget(covariant FlameGameplayBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _game.updateSnapshot(
      gameState: widget.gameState,
      revision: widget.revision,
      hintAction: widget.hintAction,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'طاولة اللعب. اسحب الورقة أو اضغط عليها ثم اضغط على المكان.',
      child: ClipRect(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapUp: (details) => _game.handleTap(details.localPosition),
          onPanStart: (details) => _game.beginDrag(details.localPosition),
          onPanUpdate: (details) => _game.updateDrag(
            details.localPosition,
            horizontalDelta: details.delta.dx,
          ),
          onPanEnd: (_) => _game.endDrag(),
          onPanCancel: _game.cancelDrag,
          child: GameWidget<ArabSolitaireFlameGame>(
            game: _game,
            textDirection: TextDirection.rtl,
          ),
        ),
      ),
    );
  }
}

/// Presentation-only renderer. Rule decisions are emitted as [GameAction]s and
/// remain authoritative in the pure-Dart [GameEngine].
class ArabSolitaireFlameGame extends FlameGame {
  ArabSolitaireFlameGame({
    required GameState gameState,
    required int revision,
    required GameAction? hintAction,
    required ValueChanged<GameAction> onAction,
  }) : _gameState = gameState,
       _revision = revision,
       _hintAction = hintAction,
       _onAction = onAction;

  GameState _gameState;
  int _revision;
  GameAction? _hintAction;
  final ValueChanged<GameAction> _onAction;
  DragPayload? _selected;
  bool _dragging = false;
  Offset _dragPosition = Offset.zero;
  Offset _dragGrabOffset = Offset.zero;
  double _dragTilt = 0;
  double _elapsed = 0;

  FlameBoardLayout? get _layout {
    if (!hasLayout || size.x <= 0 || size.y <= 0) return null;
    return FlameBoardLayout.calculate(Size(size.x, size.y), _gameState);
  }

  @override
  Color backgroundColor() => const Color(0xFF071A1B);

  void updateSnapshot({
    required GameState gameState,
    required int revision,
    required GameAction? hintAction,
  }) {
    final revisionChanged = revision != _revision;
    _gameState = gameState;
    _revision = revision;
    _hintAction = hintAction;
    if (revisionChanged) {
      _selected = null;
      _dragging = false;
      _dragTilt = 0;
    }
  }

  void handleTap(Offset point) {
    final layout = _layout;
    if (layout == null) return;

    if (layout.stockPileRect.contains(point)) {
      _selected = null;
      if (_gameState.stock.canAdvance) {
        _onAction(const AdvanceStock());
      } else if (_gameState.stock.canRestore) {
        _onAction(const RestoreStock());
      }
      return;
    }

    final selected = _selected;
    if (selected != null) {
      final target = layout.dropTargetAt(point);
      if (target != null) {
        final action = FlameBoardLayout.resolveAction(selected, target);
        _selected = null;
        if (action != null) _onAction(action);
        return;
      }
      _selected = null;
      return;
    }

    _selected = layout.sourceAt(point, _revision);
  }

  void beginDrag(Offset point) {
    final layout = _layout;
    if (layout == null) return;
    final source = layout.sourceAt(point, _revision);
    if (source == null) return;
    final sourceRect = layout.sourceRect(source);
    if (sourceRect == null) return;

    _selected = source;
    _dragging = true;
    _dragPosition = point;
    _dragGrabOffset = point - sourceRect.topLeft;
    _dragTilt = 0;
  }

  void updateDrag(Offset point, {required double horizontalDelta}) {
    if (!_dragging) return;
    _dragPosition = point;
    _dragTilt = (_dragTilt * 0.7 + horizontalDelta * 0.018)
        .clamp(-0.09, 0.09)
        .toDouble();
  }

  void endDrag() {
    final layout = _layout;
    final selected = _selected;
    final target = layout?.dropTargetAt(_dragPosition);
    _dragging = false;
    _dragTilt = 0;
    _selected = null;
    if (selected == null || target == null) return;
    final action = FlameBoardLayout.resolveAction(selected, target);
    if (action != null) _onAction(action);
  }

  void cancelDrag() {
    _dragging = false;
    _dragTilt = 0;
    _selected = null;
  }

  @override
  void update(double dt) {
    _elapsed += dt;
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    final layout = _layout;
    if (layout == null) {
      super.render(canvas);
      return;
    }

    _drawEnvironment(canvas, layout);
    _drawSlots(canvas, layout);
    _drawTableau(canvas, layout);
    _drawStock(canvas, layout);
    if (_dragging && _selected != null) {
      _drawDraggedUnit(canvas, layout, _selected!);
    }
    super.render(canvas);
  }

  void _drawEnvironment(Canvas canvas, FlameBoardLayout layout) {
    final bounds = Offset.zero & layout.size;
    final background = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF123F3D), Color(0xFF082422), Color(0xFF061817)],
        stops: [0, 0.55, 1],
      ).createShader(bounds);
    canvas.drawRect(bounds, background);

    final haze = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0, -0.75),
        radius: 0.9,
        colors: [const Color(0xFFE4B85A).withAlpha(75), Colors.transparent],
      ).createShader(bounds);
    canvas.drawRect(bounds, haze);

    final horizon = math.min(128.0, layout.size.height * 0.22);
    final skyline = Paint()..color = const Color(0xFF0A2A29).withAlpha(185);
    final skylinePath = Path()
      ..moveTo(0, horizon)
      ..lineTo(0, horizon - 24)
      ..lineTo(layout.size.width * 0.12, horizon - 24)
      ..lineTo(layout.size.width * 0.12, horizon - 42)
      ..lineTo(layout.size.width * 0.2, horizon - 42)
      ..lineTo(layout.size.width * 0.2, horizon - 18)
      ..lineTo(layout.size.width * 0.36, horizon - 18)
      ..lineTo(layout.size.width * 0.5, horizon - 54)
      ..lineTo(layout.size.width * 0.64, horizon - 18)
      ..lineTo(layout.size.width * 0.8, horizon - 18)
      ..lineTo(layout.size.width * 0.8, horizon - 36)
      ..lineTo(layout.size.width * 0.9, horizon - 36)
      ..lineTo(layout.size.width * 0.9, horizon - 22)
      ..lineTo(layout.size.width, horizon - 22)
      ..lineTo(layout.size.width, horizon)
      ..close();
    canvas.drawPath(skylinePath, skyline);

    final planeTop = horizon - 2;
    final plane = Path()
      ..moveTo(layout.size.width * 0.08, layout.size.height)
      ..lineTo(layout.size.width * 0.22, planeTop)
      ..lineTo(layout.size.width * 0.78, planeTop)
      ..lineTo(layout.size.width * 0.92, layout.size.height)
      ..close();
    canvas.drawPath(
      plane,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF276B5C), Color(0xFF16463E)],
        ).createShader(bounds),
    );

    final perspectiveLine = Paint()
      ..color = const Color(0xFFB9E4C9).withAlpha(22)
      ..strokeWidth = 1;
    for (var i = 1; i < 7; i++) {
      final t = i / 7;
      final y = planeTop + (layout.size.height - planeTop) * t * t;
      final inset = layout.size.width * (0.22 - 0.14 * t);
      canvas.drawLine(
        Offset(inset, y),
        Offset(layout.size.width - inset, y),
        perspectiveLine,
      );
    }

    _drawText(
      canvas,
      'دار الروابط',
      Rect.fromLTWH(0, 3, layout.size.width, 28),
      color: const Color(0xFFFFE5A2).withAlpha(220),
      fontSize: 13,
      weight: FontWeight.w700,
    );

    final motePaint = Paint()..color = const Color(0xFFFFD37A).withAlpha(80);
    for (var i = 0; i < 8; i++) {
      final phase = _elapsed * (0.35 + i * 0.025) + i * 1.7;
      final x = (i + 0.7) * layout.size.width / 9 + math.sin(phase) * 6;
      final y = 42 + (i % 4) * 25 + math.cos(phase * 0.8) * 5;
      canvas.drawCircle(Offset(x, y), 1.1 + (i % 2) * 0.5, motePaint);
    }
  }

  void _drawSlots(Canvas canvas, FlameBoardLayout layout) {
    for (var i = 0; i < layout.slotRects.length; i++) {
      final rect = layout.slotRects[i];
      final slot = _gameState.slots[i];
      final highlighted = _hintTargetsSlot(i);
      _drawTargetFrame(
        canvas,
        rect,
        highlighted: highlighted,
        filled: !slot.isEmpty,
      );

      final stack = slot.activeAssociation;
      if (stack == null) {
        _drawText(
          canvas,
          '+',
          rect,
          color: const Color(0xFFD8E8D9).withAlpha(110),
          fontSize: layout.cardSize.width * 0.34,
          weight: FontWeight.w300,
        );
        continue;
      }

      final cards = stack.cards;
      final compactOffset = math.min(5.0, layout.cardSize.height * 0.06);
      for (var cardIndex = 0; cardIndex < cards.length; cardIndex++) {
        final cardRect = Rect.fromLTWH(
          rect.left,
          rect.top + cardIndex * compactOffset,
          rect.width,
          rect.height - cardIndex * compactOffset,
        );
        _drawCard(
          canvas,
          cards[cardIndex],
          cardRect,
          compact: true,
          stackCount: cards.length,
        );
      }
    }
  }

  void _drawTableau(Canvas canvas, FlameBoardLayout layout) {
    for (
      var columnIndex = 0;
      columnIndex < _gameState.tableau.length;
      columnIndex++
    ) {
      final column = _gameState.tableau[columnIndex];
      final targetRect = layout.tableauRects[columnIndex];
      final selectedFromColumn =
          _selected?.sourceType == DragSourceType.tableau &&
          _selected?.sourceIndex == columnIndex;

      if (column.isEmpty) {
        _drawTargetFrame(
          canvas,
          Rect.fromLTWH(
            targetRect.left,
            targetRect.top,
            targetRect.width,
            layout.cardSize.height,
          ),
          highlighted: _hintTargetsTableau(columnIndex),
        );
      }

      for (var i = 0; i < column.hiddenCards.length; i++) {
        _drawCardBack(
          canvas,
          Rect.fromLTWH(
            targetRect.left,
            targetRect.top + i * layout.hiddenCardOffset,
            layout.cardSize.width,
            layout.cardSize.height,
          ),
        );
      }

      final unit = column.exposedUnit;
      if (unit == null || (_dragging && selectedFromColumn)) continue;
      final baseY =
          targetRect.top + column.hiddenCards.length * layout.hiddenCardOffset;
      for (var i = 0; i < unit.cards.length; i++) {
        final card = unit.cards[i];
        final rect = Rect.fromLTWH(
          targetRect.left,
          baseY + i * layout.unitCardOffset,
          layout.cardSize.width,
          layout.cardSize.height,
        );
        _drawCard(
          canvas,
          card,
          rect,
          highlighted: selectedFromColumn || _hintStartsAtTableau(columnIndex),
          stackCount: unit.cards.length,
        );
      }
    }
  }

  void _drawStock(Canvas canvas, FlameBoardLayout layout) {
    final stock = _gameState.stock;
    if (stock.canAdvance) {
      _drawCardBack(canvas, layout.stockPileRect);
      _drawText(
        canvas,
        '${stock.undealt.length}',
        layout.stockPileRect.deflate(layout.cardSize.width * 0.28),
        color: Colors.white.withAlpha(210),
        fontSize: 12,
        weight: FontWeight.w700,
      );
    } else if (stock.canRestore) {
      _drawTargetFrame(canvas, layout.stockPileRect, highlighted: true);
      _drawText(
        canvas,
        '↻',
        layout.stockPileRect,
        color: const Color(0xFFFFD775),
        fontSize: layout.cardSize.width * 0.42,
        weight: FontWeight.w500,
      );
    } else {
      _drawTargetFrame(canvas, layout.stockPileRect);
    }

    final visibleCards = stock.visibleCards;
    for (var i = 0; i < visibleCards.length; i++) {
      final isPlayable = i == visibleCards.length - 1;
      final isDraggingStock =
          _dragging && _selected?.sourceType == DragSourceType.stock;
      if (isPlayable && isDraggingStock) continue;
      _drawCard(
        canvas,
        visibleCards[i],
        layout.wasteCardRects[i],
        highlighted:
            isPlayable &&
            (_selected?.sourceType == DragSourceType.stock ||
                _hintStartsAtStock()),
        muted: !isPlayable,
      );
    }
  }

  void _drawDraggedUnit(
    Canvas canvas,
    FlameBoardLayout layout,
    DragPayload payload,
  ) {
    final List<GameCard> cards = switch (payload.sourceType) {
      DragSourceType.tableau =>
        _gameState.tableau[payload.sourceIndex].exposedUnit?.cards ?? const [],
      DragSourceType.stock => <GameCard>[
        if (_gameState.stock.playableCard case final card?) card,
      ],
    };
    if (cards.isEmpty) return;

    final topLeft = _dragPosition - _dragGrabOffset;
    final totalHeight =
        layout.cardSize.height + (cards.length - 1) * layout.unitCardOffset;
    final center = topLeft + Offset(layout.cardSize.width / 2, totalHeight / 2);
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(_dragTilt);
    canvas.translate(-center.dx, -center.dy);
    for (var i = 0; i < cards.length; i++) {
      _drawCard(
        canvas,
        cards[i],
        Rect.fromLTWH(
          topLeft.dx,
          topLeft.dy + i * layout.unitCardOffset,
          layout.cardSize.width,
          layout.cardSize.height,
        ),
        highlighted: true,
        elevated: true,
        stackCount: cards.length,
      );
    }
    canvas.restore();
  }

  void _drawTargetFrame(
    Canvas canvas,
    Rect rect, {
    bool highlighted = false,
    bool filled = false,
  }) {
    final pulse = 0.65 + math.sin(_elapsed * 4) * 0.2;
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(8));
    if (filled) {
      canvas.drawRRect(
        rrect,
        Paint()..color = const Color(0xFF103D38).withAlpha(120),
      );
    }
    canvas.drawRRect(
      rrect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = highlighted ? 2.2 : 1.2
        ..color = highlighted
            ? const Color(0xFFFFD775).withAlpha((255 * pulse).round())
            : const Color(0xFFB8DCCF).withAlpha(70),
    );
  }

  void _drawCardBack(Canvas canvas, Rect rect) {
    final shadow = RRect.fromRectAndRadius(
      rect.shift(const Offset(3, 5)),
      const Radius.circular(7),
    );
    canvas.drawRRect(shadow, Paint()..color = Colors.black.withAlpha(75));
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(7));
    canvas.drawRRect(rrect, Paint()..color = const Color(0xFF173F66));
    canvas.drawRRect(
      rrect.deflate(3),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = const Color(0xFFE6C675).withAlpha(170),
    );
    final motif = Path()
      ..moveTo(rect.center.dx, rect.top + rect.height * 0.24)
      ..lineTo(rect.right - rect.width * 0.22, rect.center.dy)
      ..lineTo(rect.center.dx, rect.bottom - rect.height * 0.24)
      ..lineTo(rect.left + rect.width * 0.22, rect.center.dy)
      ..close();
    canvas.drawPath(
      motif,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = const Color(0xFFE6C675).withAlpha(135),
    );
  }

  void _drawCard(
    Canvas canvas,
    GameCard card,
    Rect rect, {
    bool highlighted = false,
    bool compact = false,
    bool muted = false,
    bool elevated = false,
    int stackCount = 1,
  }) {
    final associationColor = _associationColor(card.associationId);
    final isAssociation = card is AssociationCard;
    final radius = Radius.circular(math.max(5.0, rect.width * 0.09));
    final shadowOffset = elevated ? const Offset(7, 10) : const Offset(3, 5);
    final rrect = RRect.fromRectAndRadius(rect, radius);

    if (highlighted) {
      final glowAlpha = (80 + 35 * math.sin(_elapsed * 5)).round();
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect.inflate(4), radius),
        Paint()
          ..color = const Color(0xFFFFD775).withAlpha(glowAlpha)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );
    }

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.shift(shadowOffset), radius),
      Paint()..color = Colors.black.withAlpha(elevated ? 105 : 70),
    );
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = muted
            ? const Color(0xFFD7D7CF)
            : isAssociation
            ? associationColor
            : const Color(0xFFFFFCF2),
    );
    canvas.drawRRect(
      rrect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = highlighted ? 2 : 1
        ..color = highlighted
            ? const Color(0xFFFFDF87)
            : isAssociation
            ? const Color(0xFFFFE5A2).withAlpha(155)
            : associationColor.withAlpha(165),
    );

    if (!isAssociation) {
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(rect.left, rect.top, rect.width, rect.height * 0.1),
          topLeft: radius,
          topRight: radius,
        ),
        Paint()..color = associationColor,
      );
    }

    final textRect = rect.deflate(math.max(4.0, rect.width * 0.08));
    _drawText(
      canvas,
      card.id,
      textRect,
      color: isAssociation ? Colors.white : const Color(0xFF17201E),
      fontSize: compact
          ? math.max(8.0, rect.width * 0.12)
          : math.max(9.0, rect.width * 0.145),
      weight: isAssociation ? FontWeight.w700 : FontWeight.w600,
    );

    if (stackCount > 1) {
      final badgeRect = Rect.fromCircle(
        center: Offset(rect.right - 9, rect.top + 9),
        radius: 8,
      );
      canvas.drawOval(
        badgeRect,
        Paint()..color = const Color(0xFF0B2524).withAlpha(215),
      );
      _drawText(
        canvas,
        '$stackCount',
        badgeRect,
        color: Colors.white,
        fontSize: 8,
        weight: FontWeight.w700,
      );
    }
  }

  void _drawText(
    Canvas canvas,
    String text,
    Rect rect, {
    required Color color,
    required double fontSize,
    required FontWeight weight,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: weight,
          height: 1.05,
        ),
      ),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.center,
      maxLines: 2,
      ellipsis: '…',
    )..layout(maxWidth: math.max(1.0, rect.width));
    painter.paint(
      canvas,
      Offset(
        rect.left + (rect.width - painter.width) / 2,
        rect.top + (rect.height - painter.height) / 2,
      ),
    );
  }

  Color _associationColor(String associationId) {
    const palette = [
      Color(0xFF1F6F78),
      Color(0xFF8F4D45),
      Color(0xFF6657A8),
      Color(0xFFB17628),
      Color(0xFF3E7354),
    ];
    final hash = associationId.codeUnits.fold<int>(0, (sum, e) => sum + e);
    return palette[hash % palette.length];
  }

  bool _hintStartsAtTableau(int columnIndex) {
    return switch (_hintAction) {
      MoveTableauToTableau(:final fromColumn) ||
      MoveTableauToSlot(:final fromColumn) => fromColumn == columnIndex,
      _ => false,
    };
  }

  bool _hintStartsAtStock() {
    return _hintAction is MoveStockToTableau || _hintAction is MoveStockToSlot;
  }

  bool _hintTargetsTableau(int columnIndex) {
    return switch (_hintAction) {
      MoveTableauToTableau(:final toColumn) ||
      MoveStockToTableau(:final toColumn) => toColumn == columnIndex,
      _ => false,
    };
  }

  bool _hintTargetsSlot(int slotIndex) {
    return switch (_hintAction) {
      MoveTableauToSlot(slotIndex: final target) ||
      MoveStockToSlot(slotIndex: final target) => target == slotIndex,
      _ => false,
    };
  }
}
