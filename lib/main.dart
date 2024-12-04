import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_party/bloc/game.dart';
import 'package:trivia_party/screens/CategoryPreparation.dart';
import 'package:trivia_party/screens/CreateGame.dart';
import 'package:trivia_party/screens/Home.dart';
import 'package:trivia_party/screens/HowToPlay.dart';
import 'package:trivia_party/screens/Question.dart';
import 'package:trivia_party/screens/VoteCategory.dart';

import 'Routes.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => GameBloc(),
      child: const TriviaPartyApp(),
    ),
  );
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
        Routes.question: (context) => const Question(),
        Routes.categoryPreparation: (context) => const CategoryPreparation()
      },
    );
  }
}
