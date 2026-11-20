import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mobile/design_system/mosaic_tokens.dart';

/// Zellige 8-point star used on cards, slots, and the selected badge.
///
/// Decorative. State is communicated by a separate label or badge, not by
/// this glyph's color.
class MosaicStar extends StatelessWidget {
  const MosaicStar({
    super.key,
    required this.size,
    required this.color,
    this.filled = false,
    this.strokeWidth = 1.5,
  });

  final double size;
  final Color color;
  final bool filled;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: CustomPaint(
        size: Size.square(size),
        painter: _StarPainter(
          color: color,
          filled: filled,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}

class _StarPainter extends CustomPainter {
  const _StarPainter({
    required this.color,
    required this.filled,
    required this.strokeWidth,
  });

  final Color color;
  final bool filled;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final inset = filled ? 0.0 : strokeWidth / 2;
    final outer = size.shortestSide / 2 - inset;
    final inner = outer * 0.42;
    final path = Path();
    for (var i = 0; i < 16; i++) {
      final radius = i.isEven ? outer : inner;
      final angle = -math.pi / 2 + i * math.pi / 8;
      final point = center + Offset(math.cos(angle), math.sin(angle)) * radius;
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    final paint = Paint()
      ..color = color
      ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_StarPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.filled != filled ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

/// Coin mark: saffron disc, pale inner disc, dark stroke.
class MosaicCoinIcon extends StatelessWidget {
  const MosaicCoinIcon({super.key, this.size = 20});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: CustomPaint(
        size: Size.square(size),
        painter: const _CoinPainter(),
      ),
    );
  }
}

class _CoinPainter extends CustomPainter {
  const _CoinPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2;
    canvas.drawCircle(center, radius, Paint()..color = MosaicColors.saffron500);
    canvas.drawCircle(
      center,
      radius * 0.58,
      Paint()..color = MosaicColors.saffron100,
    );
    canvas.drawCircle(
      center,
      radius - 0.8,
      Paint()
        ..color = MosaicColors.coinStroke
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.shortestSide * 0.08,
    );
  }

  @override
  bool shouldRepaint(_CoinPainter oldDelegate) => false;
}
