import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_party/bloc/events/home_screen_events.dart';
import 'package:trivia_party/bloc/game.dart';
import 'package:trivia_party/bloc/states/category_voting_state.dart';
import 'package:trivia_party/bloc/states/game_join_state.dart';
import 'package:trivia_party/bloc/states/game_lobby_state.dart';
import 'package:trivia_party/bloc/states/game_state.dart';
import 'package:trivia_party/bloc/states/leaderboard_state.dart';
import 'package:trivia_party/bloc/states/question_preparation_state.dart';
import 'package:trivia_party/bloc/states/question_result_state.dart';
import 'package:trivia_party/bloc/states/question_state.dart';
import 'package:trivia_party/screens/category_preparation_screen.dart';
import 'package:trivia_party/screens/game_join_screen.dart';
import 'package:trivia_party/screens/game_lobby_screen.dart';
import 'package:trivia_party/screens/home_screen.dart';
import 'package:trivia_party/screens/how_to_play_screen.dart';
import 'package:trivia_party/screens/question_result_screen.dart';
import 'package:trivia_party/screens/question_screen.dart';
import 'package:trivia_party/screens/podium_screen.dart';
import 'package:trivia_party/screens/vote_category_screen.dart';

import 'services/audio_manager.dart';
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

  AudioManager.playBackgroundMusic();

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
        final navigator = widget.navigatorKey.currentState;

        if (state is GameLobbyState) {
          navigator?.pushNamed(Routes.createGame);
        } else if (state is GameJoinState) {
          navigator?.pushNamed(Routes.joinGame);
        } else if (state is CategoryVotingState) {
          navigator?.pushNamed(Routes.voteCategory);
        } else if (state is QuestionPreparationState) {
          navigator?.pushNamed(Routes.categoryPreparation);
        } else if (state is QuestionState) {
          navigator?.pushNamed(Routes.question);
        }  if (state is QuestionResultState) {
          navigator?.pushNamed(Routes.questionResult);
        } else  if (state is LeaderboardState) {
          navigator?.pushNamed(Routes.leaderboard);
        } else if (state is HomeScreenState) {
          navigator?.pushNamed('/');
        }
      },
      child: MaterialApp(
        navigatorKey: widget.navigatorKey,
        title: 'Trivia Party',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const PopScope(
                canPop: false,
                child: Home(),
              ),
          Routes.createGame: (context) => PopScope(
                canPop: false,
                onPopInvokedWithResult: (bool didPop, Object? result) async {
                  context.read<GameBloc>().add(SwitchToHomeScreenEvent());
                },
                child: const CreateGame(),
              ),
          Routes.joinGame: (context) => PopScope(
                canPop: false,
                onPopInvokedWithResult: (bool didPop, Object? result) async {
                  context.read<GameBloc>().add(SwitchToHomeScreenEvent());
                },
                child: const GameJoinScreen(),
              ),
          Routes.howToPlay: (context) => const HowToPlay(),
          Routes.voteCategory: (context) => const PopScope(
                canPop: false,
                child: VoteCategory(),
              ),
          Routes.question: (context) => const PopScope(
                canPop: false,
                child: Question(),
              ),
          Routes.categoryPreparation: (context) => const PopScope(
                canPop: false,
                child: CategoryPreparation(),
              ),
          Routes.questionResult: (context) => const PopScope(
            canPop: false,
            child: QuestionResult(),
          ),
          Routes.leaderboard: (context) => const PopScope(
                canPop: false,
                child: PodiumScreen(),
              ),
        },
      ),
    );
  }
}
