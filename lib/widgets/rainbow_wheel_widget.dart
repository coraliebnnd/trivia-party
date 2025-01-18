// Custom widget for the RainbowWheel
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:trivia_party/bloc/models/categories.dart';
import 'package:trivia_party/bloc/models/player.dart';

List<double> calculateProgressForPlayer(Player player, numberOfQuestions) {
  var artScore = player.score[categories[1]!.displayName]! / numberOfQuestions;
  var videoGameScore =
      player.score[categories[2]!.displayName]! / numberOfQuestions;
  var moviesTVScore =
      player.score[categories[3]!.displayName]! / numberOfQuestions;
  var sportScore =
      player.score[categories[4]!.displayName]! / numberOfQuestions;
  var musicScore =
      player.score[categories[5]!.displayName]! / numberOfQuestions;
  var bookScore = player.score[categories[6]!.displayName]! / numberOfQuestions;
  var progressArray = [
    artScore,
    videoGameScore,
    moviesTVScore,
    sportScore,
    musicScore,
    bookScore,
  ];
  return progressArray;
}

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
        painter:
            RainbowWheelPainter(progress: progress, borderWidth: borderWidth),
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
      ..strokeWidth = borderWidth * 0.3
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw segments
    for (var i = 0; i < lengthOfCategoriesWithoutRandom(categories); i++) {
      final startAngle =
          (i * 2 * 3.14159) / lengthOfCategoriesWithoutRandom(categories);
      final sweepAngle =
          (2 * 3.14159) / lengthOfCategoriesWithoutRandom(categories);
      var adjustedProgress = progress[i] + 0.15; // Minimum de 10%

      if (progress[i] == 0) {
        adjustedProgress = 0;
      }

      final currentRadius = radius * adjustedProgress.clamp(0.0, 1.0);

      paint.color = categories[i + 1]!.color;
      backgroundPaint.color = categories[i + 1]!.color.withOpacity(0.3);

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

      for (var i = 0; i < lengthOfCategoriesWithoutRandom(categories); i++) {
        final startAngle =
            (i * 2 * 3.14159) / lengthOfCategoriesWithoutRandom(categories);

        final endX = center.dx + radius * cos(startAngle);
        final endY = center.dy + radius * sin(startAngle);

        canvas.drawLine(center, Offset(endX, endY), linePaint);
      }
    }
  }

  int lengthOfCategoriesWithoutRandom(Map<int, Category> categoryMap) {
    // We don't draw the random category. So we just ignore it.
    return categoryMap.length - 1;
  }

  @override
  bool shouldRepaint(covariant RainbowWheelPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
