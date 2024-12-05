import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: PodiumScreen(),
      ),
    );
  }
}

class PodiumScreen extends StatefulWidget {
  const PodiumScreen({super.key});

  @override
  PodiumScreenState createState() => PodiumScreenState();
}

class PodiumScreenState extends State<PodiumScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 100), // Duration of one full rotation
    )..repeat(); // Repeat the animation infinitely
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[900], // Base background color
          ),
          child: Stack(
            children: [
              // Sun Rays Background
              CustomPaint(
                size: Size.infinite,
                painter: RaysPainter(rotationAngle: _controller.value * 2 * pi),
              ),

              // Podium Bars (Center)
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Left bar
                      PodiumColumn(
                        rank: "2",
                        name: "Coralie",
                        score: "26",
                        color: Colors.purple,
                        heightFactor: 1.4,
                        width: 80,
                      ),
                      // Middle bar
                      PodiumColumn(
                        rank: "1",
                        name: "Niklas",
                        score: "30",
                        color: Colors.blue,
                        heightFactor: 1.8,
                        width: 100,
                      ),
                      // Right bar
                      PodiumColumn(
                        rank: "3",
                        name: "Marianne",
                        score: "22",
                        color: Colors.pink,
                        heightFactor: 1.2,
                        width: 80,
                      ),
                    ],
                  ),
                ],
              ),

              // Rankings List (Foreground)
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Expanded(child: SizedBox()), // Push list to bottom
                  const RankingTile(
                      rank: 4, name: "Jane", score: 18, color: Colors.orange),
                  const RankingTile(
                      rank: 5, name: "Michel", score: 15, color: Colors.yellow),
                  const RankingTile(
                      rank: 6, name: "John", score: 13, color: Colors.green),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text("Play again"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class RaysPainter extends CustomPainter {
  final double rotationAngle;

  RaysPainter({required this.rotationAngle});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white10 // Visible grey color for the rays
      ..style = PaintingStyle.fill;

    final center =
        Offset(size.width / 2, size.height / 6.5); // Rays originate here
    final radius = size.width * 1.5; // Length of the rays

    // Draw rays around the center
    for (double i = 0; i < 360; i += 15) {
      // Rotate the rays by the rotationAngle
      final angle1 = (i + rotationAngle * 180 / pi) * pi / 180;
      final angle2 = (i + 7.5 + rotationAngle * 180 / pi) * pi / 180;

      // Outer points of the rays
      final outerPoint1 = Offset(
        center.dx + radius * cos(angle1),
        center.dy + radius * sin(angle1),
      );

      final outerPoint2 = Offset(
        center.dx + radius * cos(angle2),
        center.dy + radius * sin(angle2),
      );

      // Draw the triangular ray
      final rayPath = Path()
        ..moveTo(center.dx, center.dy) // Starting at the center
        ..lineTo(outerPoint1.dx, outerPoint1.dy) // First outer point
        ..lineTo(outerPoint2.dx, outerPoint2.dy) // Second outer point
        ..close(); // Close the triangle

      canvas.drawPath(rayPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class PodiumColumn extends StatelessWidget {
  final String rank;
  final String name;
  final String score;
  final Color color;
  final double heightFactor;
  final double width;

  const PodiumColumn({
    super.key,
    required this.rank,
    required this.name,
    required this.score,
    required this.color,
    required this.heightFactor,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none, // Allow the avatar to overflow
      children: [
        // Podium Bar
        Container(
          width: width,
          height: 200 * heightFactor,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                rank,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24 * heightFactor,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        // Circular Avatar Above the Bar
        Positioned(
          top:
              -10 - 25 * 2 * heightFactor, // Increase this value to add spacing
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: color,
                radius: 25 * heightFactor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      score,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RankingTile extends StatelessWidget {
  final int rank;
  final String name;
  final int score;
  final Color color;

  const RankingTile({
    super.key,
    required this.rank,
    required this.name,
    required this.score,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color,
            child: Text(rank.toString(),
                style: const TextStyle(color: Colors.white)),
          ),
          title:
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          trailing: Text(
            score.toString(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
