import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mobile/design_system/mosaic_tokens.dart';
import 'package:mobile/design_system/widgets/mosaic_pressable.dart';

/// Line icons from the component sheet. Stroke is 2px at 24px, round caps.
///
/// [MosaicIconKind.back] points toward the start (right in RTL).
/// [MosaicIconKind.forward] points toward the end (left in RTL).
/// Other glyphs do not flip.
enum MosaicIconKind {
  back,
  forward,
  pause,
  undo,
  hint,
  restart,
  lock,
  gift,
  check,
  close,
  play,
  settings,
  shop,
  deck,
  flame,
  flag,
  map,
  user,
  archive,
  plus,
  moves,
}

class MosaicIcon extends StatelessWidget {
  const MosaicIcon(
    this.kind, {
    super.key,
    this.size = 24,
    this.color = MosaicColors.emerald900,
  });

  final MosaicIconKind kind;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final directional =
        kind == MosaicIconKind.back || kind == MosaicIconKind.forward;
    // Painter draws the RTL glyph. Flip it when the ambient direction is LTR.
    final flip = directional && !rtl;
    Widget icon = CustomPaint(
      size: Size.square(size),
      painter: _IconPainter(kind: kind, color: color),
    );
    if (flip) {
      icon = Transform.flip(flipX: true, child: icon);
    }
    return ExcludeSemantics(child: icon);
  }
}

/// 40×40 paper icon button. Hit target is at least 44.
class MosaicIconButton extends StatelessWidget {
  const MosaicIconButton({
    super.key,
    required this.kind,
    required this.semanticsLabel,
    this.onPressed,
    this.color = MosaicColors.emerald900,
  });

  final MosaicIconKind kind;
  final String semanticsLabel;
  final VoidCallback? onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return MosaicPressable(
      onPressed: onPressed,
      semanticsLabel: semanticsLabel,
      borderRadius: BorderRadius.circular(MosaicRadii.md),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: MosaicColors.paper,
          borderRadius: BorderRadius.circular(MosaicRadii.md),
          border: Border.all(color: MosaicColors.line),
        ),
        child: SizedBox.square(
          dimension: 40,
          child: Center(child: MosaicIcon(kind, size: 20, color: color)),
        ),
      ),
    );
  }
}

class _IconPainter extends CustomPainter {
  const _IconPainter({required this.kind, required this.color});

  final MosaicIconKind kind;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.shortestSide * (2 / 24)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final scale = size.shortestSide / 24;
    canvas.save();
    canvas.scale(scale);
    switch (kind) {
      case MosaicIconKind.back || MosaicIconKind.forward:
        _arrow(canvas, stroke, pointsRight: kind == MosaicIconKind.back);
      case MosaicIconKind.pause:
        canvas.drawLine(const Offset(8, 5), const Offset(8, 19), stroke);
        canvas.drawLine(const Offset(16, 5), const Offset(16, 19), stroke);
      case MosaicIconKind.undo:
        final arc = Path()
          ..addArc(
            const Rect.fromLTWH(5, 5, 14, 14),
            math.pi * 0.2,
            math.pi * 1.45,
          );
        canvas.drawPath(arc, stroke);
        _arrowHead(canvas, stroke, const Offset(6, 10), const Offset(6, 16));
      case MosaicIconKind.hint:
        canvas.drawCircle(const Offset(12, 9), 4.2, stroke);
        canvas.drawLine(const Offset(12, 13.2), const Offset(12, 16), stroke);
        canvas.drawLine(const Offset(9.5, 19), const Offset(14.5, 19), stroke);
      case MosaicIconKind.restart || MosaicIconKind.moves:
        final arc = Path()
          ..addArc(
            const Rect.fromLTWH(5, 5, 14, 14),
            -math.pi * 0.15,
            math.pi * 1.6,
          );
        canvas.drawPath(arc, stroke);
        _arrowHead(canvas, stroke, const Offset(17, 6), const Offset(19, 9));
      case MosaicIconKind.lock:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(6, 11, 12, 8),
            const Radius.circular(1.5),
          ),
          stroke,
        );
        final shackle = Path()
          ..moveTo(8.5, 11)
          ..arcToPoint(
            const Offset(15.5, 11),
            radius: const Radius.circular(3.5),
            rotation: math.pi,
          );
        canvas.drawPath(shackle, stroke);
      case MosaicIconKind.gift:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(4, 10, 16, 9),
            const Radius.circular(1.5),
          ),
          stroke,
        );
        canvas.drawLine(const Offset(12, 10), const Offset(12, 19), stroke);
        canvas.drawLine(const Offset(4, 13.5), const Offset(20, 13.5), stroke);
        canvas.drawLine(const Offset(12, 10), const Offset(8, 6), stroke);
        canvas.drawLine(const Offset(12, 10), const Offset(16, 6), stroke);
      case MosaicIconKind.check:
        canvas.drawLine(const Offset(5, 12.5), const Offset(10, 17.5), stroke);
        canvas.drawLine(const Offset(10, 17.5), const Offset(19, 7), stroke);
      case MosaicIconKind.close:
        canvas.drawLine(const Offset(6, 6), const Offset(18, 18), stroke);
        canvas.drawLine(const Offset(18, 6), const Offset(6, 18), stroke);
      case MosaicIconKind.play:
        final path = Path()
          ..moveTo(8, 6)
          ..lineTo(18, 12)
          ..lineTo(8, 18)
          ..close();
        canvas.drawPath(path, stroke);
      case MosaicIconKind.settings:
        canvas.drawLine(const Offset(4, 8), const Offset(20, 8), stroke);
        canvas.drawLine(const Offset(4, 12), const Offset(20, 12), stroke);
        canvas.drawLine(const Offset(4, 16), const Offset(20, 16), stroke);
        canvas.drawCircle(const Offset(9, 8), 1.6, stroke);
        canvas.drawCircle(const Offset(15, 12), 1.6, stroke);
        canvas.drawCircle(const Offset(11, 16), 1.6, stroke);
      case MosaicIconKind.shop:
        final bag = Path()
          ..moveTo(6, 9)
          ..lineTo(8, 20)
          ..lineTo(16, 20)
          ..lineTo(18, 9)
          ..close();
        canvas.drawPath(bag, stroke);
        canvas.drawArc(
          const Rect.fromLTWH(8, 5, 8, 8),
          math.pi,
          math.pi,
          false,
          stroke,
        );
      case MosaicIconKind.deck:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(6, 7, 12, 12),
            const Radius.circular(2),
          ),
          stroke,
        );
        canvas.drawLine(const Offset(8, 5), const Offset(18, 5), stroke);
        canvas.drawLine(const Offset(18, 5), const Offset(18, 15), stroke);
      case MosaicIconKind.flame:
        final flame = Path()
          ..moveTo(12, 3)
          ..cubicTo(12, 8, 7, 9, 7, 14)
          ..cubicTo(7, 18, 9.5, 21, 12, 21)
          ..cubicTo(14.5, 21, 17, 18, 17, 14)
          ..cubicTo(17, 9, 12, 8, 12, 3);
        canvas.drawPath(flame, stroke);
      case MosaicIconKind.flag:
        canvas.drawLine(const Offset(6, 4), const Offset(6, 20), stroke);
        final flag = Path()
          ..moveTo(6, 5)
          ..lineTo(17, 5)
          ..lineTo(14, 9)
          ..lineTo(17, 13)
          ..lineTo(6, 13);
        canvas.drawPath(flag, stroke);
      case MosaicIconKind.map:
        canvas.drawLine(const Offset(8, 5), const Offset(8, 19), stroke);
        canvas.drawLine(const Offset(16, 5), const Offset(16, 19), stroke);
        canvas.drawLine(const Offset(4, 8), const Offset(12, 5), stroke);
        canvas.drawLine(const Offset(12, 5), const Offset(20, 8), stroke);
        canvas.drawLine(const Offset(4, 16), const Offset(12, 19), stroke);
        canvas.drawLine(const Offset(12, 19), const Offset(20, 16), stroke);
        canvas.drawLine(const Offset(4, 8), const Offset(4, 16), stroke);
        canvas.drawLine(const Offset(20, 8), const Offset(20, 16), stroke);
        canvas.drawLine(const Offset(12, 5), const Offset(12, 19), stroke);
      case MosaicIconKind.user:
        canvas.drawCircle(const Offset(12, 8), 3.2, stroke);
        canvas.drawArc(
          const Rect.fromLTWH(5, 13, 14, 10),
          math.pi,
          math.pi,
          false,
          stroke,
        );
      case MosaicIconKind.archive:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(4, 8, 16, 11),
            const Radius.circular(1.5),
          ),
          stroke,
        );
        canvas.drawLine(const Offset(4, 12), const Offset(20, 12), stroke);
        canvas.drawLine(const Offset(10, 12), const Offset(10, 15), stroke);
        canvas.drawLine(const Offset(10, 15), const Offset(14, 15), stroke);
        canvas.drawLine(const Offset(14, 15), const Offset(14, 12), stroke);
      case MosaicIconKind.plus:
        canvas.drawLine(const Offset(12, 5), const Offset(12, 19), stroke);
        canvas.drawLine(const Offset(5, 12), const Offset(19, 12), stroke);
    }
    canvas.restore();
  }

  void _arrow(Canvas canvas, Paint stroke, {required bool pointsRight}) {
    if (pointsRight) {
      canvas.drawLine(const Offset(5, 12), const Offset(18, 12), stroke);
      canvas.drawLine(const Offset(13, 7), const Offset(18, 12), stroke);
      canvas.drawLine(const Offset(13, 17), const Offset(18, 12), stroke);
    } else {
      canvas.drawLine(const Offset(19, 12), const Offset(6, 12), stroke);
      canvas.drawLine(const Offset(11, 7), const Offset(6, 12), stroke);
      canvas.drawLine(const Offset(11, 17), const Offset(6, 12), stroke);
    }
  }

  void _arrowHead(Canvas canvas, Paint stroke, Offset from, Offset tip) {
    canvas.drawLine(from, tip, stroke);
    canvas.drawLine(tip, tip + const Offset(4, -1), stroke);
  }

  @override
  bool shouldRepaint(_IconPainter oldDelegate) {
    return oldDelegate.kind != kind || oldDelegate.color != color;
  }
}
