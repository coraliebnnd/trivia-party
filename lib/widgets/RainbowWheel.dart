// Custom widget for the RainbowWheel
import 'package:flutter/material.dart';

class RainbowWheel extends StatelessWidget {
  final double size;
  final double borderWidth;
  final Color borderColor;

  const RainbowWheel({
    Key? key,
    required this.size,
    required this.borderWidth,
    required this.borderColor,
  }) : super(key: key);

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
        painter: RainbowWheelPainter(),
      ),
    );
  }
}

// Custom painter for the rainbow wheel
class RainbowWheelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;

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

      paint.color = colors[i];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
