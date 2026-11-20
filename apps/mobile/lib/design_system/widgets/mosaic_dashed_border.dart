import 'package:flutter/material.dart';

/// Rounded rectangle stroke drawn as a dash pattern.
///
/// Flutter's [Border] cannot dash. Slots and the valid-target card use this
/// so those states stay recognizable without color.
class MosaicDashedBorder extends StatelessWidget {
  const MosaicDashedBorder({
    super.key,
    required this.color,
    required this.strokeWidth,
    required this.radius,
    required this.dashPattern,
    required this.child,
  });

  final Color color;
  final double strokeWidth;
  final double radius;
  final List<double> dashPattern;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: MosaicDashedBorderPainter(
        color: color,
        strokeWidth: strokeWidth,
        radius: radius,
        dashPattern: dashPattern,
      ),
      child: child,
    );
  }
}

class MosaicDashedBorderPainter extends CustomPainter {
  const MosaicDashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.radius,
    required this.dashPattern,
  });

  final Color color;
  final double strokeWidth;
  final double radius;
  final List<double> dashPattern;

  @override
  void paint(Canvas canvas, Size size) {
    final inset = strokeWidth / 2;
    final rect = Rect.fromLTWH(
      inset,
      inset,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(_dashed(path), paint);
  }

  Path _dashed(Path source) {
    final dest = Path();
    for (final metric in source.computeMetrics()) {
      var distance = 0.0;
      var draw = true;
      var index = 0;
      while (distance < metric.length) {
        final length = dashPattern[index % dashPattern.length];
        final next = (distance + length).clamp(0.0, metric.length);
        if (draw) {
          dest.addPath(metric.extractPath(distance, next), Offset.zero);
        }
        distance = next;
        draw = !draw;
        index++;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(MosaicDashedBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.radius != radius ||
        oldDelegate.dashPattern != dashPattern;
  }
}
