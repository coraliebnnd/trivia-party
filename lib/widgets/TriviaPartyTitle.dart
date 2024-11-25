import 'package:flutter/material.dart';

// Custom widget for the title
class TriviaPartyTitle extends StatelessWidget {
  const TriviaPartyTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'TRIVIA\nPARTY',
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: [
          Shadow(
            blurRadius: 3,
            color: Colors.black,
            offset: Offset(1, 1),
          ),
        ],
      ),
    );
  }
}
