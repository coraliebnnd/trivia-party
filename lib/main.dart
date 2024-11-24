import 'package:flutter/material.dart';
import 'package:trivia_party/screens/CategoryPreparation.dart';
import 'package:trivia_party/screens/CreateGame.dart';
import 'package:trivia_party/screens/Home.dart';
import 'package:trivia_party/screens/HowToPlay.dart';
import 'package:trivia_party/screens/VoteCategory.dart';

import 'Routes.dart';

void main() {
  runApp(const TriviaPartyApp());
}

class TriviaPartyApp extends StatelessWidget {
  const TriviaPartyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trivia Party',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Define routes
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        Routes.createGame: (context) => const CreateGame(),
        Routes.howToPlay: (context) => const HowToPlay(),
        Routes.voteCategory: (context) => const VoteCategory(),
        Routes.categoryPreparation: (context) => const CategoryPreparation(category: "Art", categoryColor: Colors.yellow)
      },
    );
  }
}
