import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CountdownWithLoadingBar extends StatefulWidget {
  final int countdownSeconds;
  final VoidCallback onCountdownComplete;
  final double height; // Added height property for customization

  const CountdownWithLoadingBar({
    Key? key,
    required this.countdownSeconds,
    required this.onCountdownComplete,
    this.height = 20.0, // Default height value
  }) : super(key: key);

  @override
  State<CountdownWithLoadingBar> createState() =>
      _CountdownWithLoadingBarState();
}

class _CountdownWithLoadingBarState extends State<CountdownWithLoadingBar>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  late double _elapsedTime;
  late double _countdownDuration;
  bool _callbackTriggered = false; // Flag to ensure callback is sent only once

  @override
  void initState() {
    super.initState();
    _countdownDuration = widget.countdownSeconds.toDouble();
    _elapsedTime = 0.0;
    _ticker = Ticker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    setState(() {
      _elapsedTime = elapsed.inMilliseconds / 1000.0;

      // Trigger the callback only once
      if (_elapsedTime >= _countdownDuration && !_callbackTriggered) {
        _callbackTriggered = true; // Mark as triggered
        widget.onCountdownComplete();
      }
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  // This method calculates the color by blending green -> yellow -> red
  Color _getBlendedColor(double progress) {
    if (progress < 0.5) {
      return Color.lerp(Colors.green, Colors.yellow, progress / 0.5)!;
    } else {
      return Color.lerp(Colors.yellow, Colors.red, (progress - 0.5) / 0.5)!;
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = (_elapsedTime / _countdownDuration).clamp(0.0, 1.0);

    return SizedBox(
      height: widget.height, // Set height dynamically
      child: LinearProgressIndicator(
        value: progress,
        backgroundColor: Colors.transparent,
        color: _getBlendedColor(progress), // Blended color
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: const Text('Countdown Example')),
      body: Center(
        child: CountdownWithLoadingBar(
          countdownSeconds: 10,
          height: 50.0, // Example of using a custom height
          onCountdownComplete: () {
            print('Countdown complete!'); // Replace with your desired method
          },
        ),
      ),
    ),
  ));
}
