import 'package:flutter/material.dart';
import 'dart:math';

class CircularCountdown extends StatefulWidget {
  final int duration; // Duration in seconds
  final VoidCallback? onCountdownComplete; // Add callback property

  const CircularCountdown({
    super.key,
    required this.duration,
    this.onCountdownComplete, // Optional callback
  });

  @override
  CircularCountdownState createState() => CircularCountdownState();
}

class CircularCountdownState extends State<CircularCountdown>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final GlobalKey _containerKey = GlobalKey();
  Offset _containerPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    )..forward();

    // Add listener for countdown completion
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onCountdownComplete
            ?.call(); // Call the callback when countdown ends
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _calculatePosition());
  }

  void _calculatePosition() {
    RenderBox renderBox =
        _containerKey.currentContext!.findRenderObject() as RenderBox;
    Offset position = renderBox.localToGlobal(Offset.zero);
    setState(() {
      _containerPosition = position;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _containerKey,
      width: 200,
      height: 200,
      color: Colors.transparent,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: CircularCountdownPainter(
              progress: _controller.value,
              position: _containerPosition,
            ),
            child: Center(
              child: Text(
                '${(widget.duration * (1 - _controller.value)).ceil()}s',
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CircularCountdownPainter extends CustomPainter {
  final double progress;
  final Offset position;

  CircularCountdownPainter({required this.progress, required this.position});

  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 30.0;
    Paint backgroundPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    Paint progressPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt; // No rounded edges

    double radius = (size.width - strokeWidth) / 2;
    Offset center = Offset(size.width / 2, size.height / 2);

    // Adjust radius or drawing dynamically based on position
    // For example, make the arc bigger if it's closer to the top of the screen
    double distanceFromTop = position.dy;
    double scale =
        (1 - (distanceFromTop / 1000).clamp(0.0, 1.0)); // Scale by distance
    double adjustedRadius = radius * (1 + scale * 0.5);

    // Draw background circle
    canvas.drawCircle(center, adjustedRadius, backgroundPaint);

    // Draw progress arc
    double sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: adjustedRadius),
      -pi / 2, // Start from top
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Always repaint for animation
  }
}

void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CircularCountdown(duration: 10), // 10 seconds countdown
      ),
    ),
  ));
}
