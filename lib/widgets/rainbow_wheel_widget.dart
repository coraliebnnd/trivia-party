// Custom widget for the RainbowWheel
import 'dart:math';

import 'package:flutter/material.dart';

class RainbowWheel extends StatelessWidget {
  final double size;
  final double borderWidth;
  final Color borderColor;
  final List<double> progress;

  const RainbowWheel({
    super.key,
    required this.size,
    required this.borderWidth,
    required this.borderColor,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
      ),
      child: CustomPaint(
        painter: RainbowWheelPainter(progress: progress, borderWidth: borderWidth),
      ),
    );
  }
}

// Custom painter for the rainbow wheel
class RainbowWheelPainter extends CustomPainter {
  final List<double> progress;
  final double borderWidth;

  RainbowWheelPainter({required this.progress, required this.borderWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;
    final Paint backgroundPaint = Paint()..style = PaintingStyle.fill;
    final Paint linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = borderWidth*0.3
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Colors for the wheel segments
    final colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.purple,
    ];

    // Draw segments
    for (var i = 0; i < colors.length; i++) {
      final startAngle = (i * 2 * 3.14159) / colors.length;
      final sweepAngle = (2 * 3.14159) / colors.length;
      final currentRadius = radius * progress[i];

      paint.color = colors[i];
      backgroundPaint.color = colors[i].withOpacity(0.3);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: currentRadius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      // Draw background
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        backgroundPaint,
      );

      // Draw lines
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        linePaint,
      );

      for (var i = 0; i < colors.length; i++) {
        final startAngle = (i * 2 * 3.14159) / colors.length;

        final endX = center.dx + radius * cos(startAngle);
        final endY = center.dy + radius * sin(startAngle);

        canvas.drawLine(center, Offset(endX, endY), linePaint);
      }

    }
  }

  @override
  bool shouldRepaint(covariant RainbowWheelPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
