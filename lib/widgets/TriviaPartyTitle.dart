import 'package:flutter/material.dart';

// Custom widget for the title
class TriviaPartyTitle extends StatelessWidget {
  const TriviaPartyTitle({Key? key}) : super(key: key);

  @override
    Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/img/trivia_party_logo.png',
        width: 300,
        height: 200, 
        fit: BoxFit.contain,
      ),
    );
  }
}
