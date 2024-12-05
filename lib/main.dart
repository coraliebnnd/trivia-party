import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_party/bloc/game.dart';
import 'package:trivia_party/bloc/states/category_voting_state.dart';
import 'package:trivia_party/bloc/states/game_lobby_state.dart';
import 'package:trivia_party/bloc/states/game_state.dart';
import 'package:trivia_party/bloc/states/question_preparation_state.dart';
import 'package:trivia_party/bloc/states/question_state.dart';
import 'package:trivia_party/screens/CategoryPreparation.dart';
import 'package:trivia_party/screens/GameLobbyScreen.dart';
import 'package:trivia_party/screens/Home.dart';
import 'package:trivia_party/screens/HowToPlay.dart';
import 'package:trivia_party/screens/Question.dart';
import 'package:trivia_party/screens/VoteCategory.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'Routes.dart';

Future<void> main() async {
  final navigatorKey = GlobalKey<NavigatorState>();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(BlocProvider(
    create: (context) => GameBloc(navigatorKey),
    child: TriviaPartyApp(navigatorKey: navigatorKey),
  ));
}

class TriviaPartyApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const TriviaPartyApp({super.key, required this.navigatorKey});

  @override
  State<TriviaPartyApp> createState() => _TriviaPartyAppState();
}

class _TriviaPartyAppState extends State<TriviaPartyApp> {
  GameState? lastState = null;

  @override
  Widget build(BuildContext context) {
    return BlocListener<GameBloc, GameState>(
      listener: (context, state) {
        if (state.runtimeType == lastState.runtimeType) {
          return;
        }
        lastState = state;
        // Use navigatorKey for navigation
        if (state is GameLobbyState) {
          widget.navigatorKey.currentState?.pushNamed(Routes.createGame);
        } else if (state is CategoryVotingState) {
          widget.navigatorKey.currentState?.pushNamed(Routes.voteCategory);
        } else if (state is QuestionPreparationState) {
          widget.navigatorKey.currentState
              ?.pushNamed(Routes.categoryPreparation);
        } else if (state is QuestionState) {
          widget.navigatorKey.currentState?.pushNamed(Routes.question);
        }
      },
      child: MaterialApp(
        navigatorKey: widget.navigatorKey,
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
          Routes.categoryPreparation: (context) => const CategoryPreparation(),
        },
      ),
    );
  }
}
