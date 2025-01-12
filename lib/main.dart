import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_party/bloc/game.dart';
import 'package:trivia_party/bloc/states/category_voting_state.dart';
import 'package:trivia_party/bloc/states/game_join_state.dart';
import 'package:trivia_party/bloc/states/game_lobby_state.dart';
import 'package:trivia_party/bloc/states/game_state.dart';
import 'package:trivia_party/bloc/states/leaderboard_state.dart';
import 'package:trivia_party/bloc/states/question_preparation_state.dart';
import 'package:trivia_party/bloc/states/question_state.dart';
import 'package:trivia_party/screens/category_preparation_screen.dart';
import 'package:trivia_party/screens/game_join_screen.dart';
import 'package:trivia_party/screens/game_lobby_screen.dart';
import 'package:trivia_party/screens/home_screen.dart';
import 'package:trivia_party/screens/how_to_play_screen.dart';
import 'package:trivia_party/screens/question_screen.dart';
import 'package:trivia_party/screens/podium_screen.dart';
import 'package:trivia_party/screens/vote_category_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'bloc/states/home_screen_state.dart';
import 'firebase_options.dart';

import 'routes.dart';

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
  GameState? lastState;

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
        } else if (state is GameJoinState) {
          widget.navigatorKey.currentState?.pushNamed(Routes.joinGame);
        } else if (state is CategoryVotingState) {
          widget.navigatorKey.currentState?.pushNamed(Routes.voteCategory);
        } else if (state is QuestionPreparationState) {
          widget.navigatorKey.currentState
              ?.pushNamed(Routes.categoryPreparation);
        } else if (state is QuestionState) {
          widget.navigatorKey.currentState?.pushNamed(Routes.question);
        } else if (state is LeaderboardState) {
          widget.navigatorKey.currentState?.pushNamed(Routes.leaderboard);
        } else if (state is HomeScreenState) {
          widget.navigatorKey.currentState?.pushNamed('/');
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
          Routes.joinGame: (context) => const GameJoinScreen(),
          Routes.howToPlay: (context) => const HowToPlay(),
          Routes.voteCategory: (context) => const VoteCategory(),
          Routes.question: (context) => const Question(),
          Routes.categoryPreparation: (context) => const CategoryPreparation(),
          Routes.leaderboard: (context) => const PodiumScreen(),
        },
      ),
    );
  }
}
