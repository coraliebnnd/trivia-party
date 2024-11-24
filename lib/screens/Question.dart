// lib/screens/question_screen.dart
import 'package:flutter/material.dart';

class Question extends StatefulWidget {
  const Question({Key? key}) : super(key: key);

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  final List<String> answers = [
    'Michaelangelo',
    'Botticelli',
    'Leonardo da Vinci',
    'Donatello',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black87,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Top status bar style content
                const SizedBox(height: 20),
                // Question container
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFE91E63), // Pink/magenta color
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Who painted\nthe Mona Lisa?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Answer buttons
                ...answers
                    .map((answer) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle answer selection
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 24,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              minimumSize: Size(double.infinity, 50),
                            ),
                            child: Text(
                              answer,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
                const Spacer(),
                // Bottom rainbow circle
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color(0xFFE91E63),
                      width: 3,
                    ),
                  ),
                  child: CustomPaint(
                    painter: RainbowWheelPainter(),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
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

void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Question(), // 10 seconds countdown
      ),
    ),
  ));
}
