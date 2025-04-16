import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_party/bloc/events/debug.dart';
import 'package:trivia_party/bloc/game.dart';
import 'package:trivia_party/bloc/models/lobby_settings.dart';
import 'package:trivia_party/bloc/models/player.dart';
import 'package:trivia_party/bloc/states/leaderboard_state.dart';
import 'package:trivia_party/screens/podium_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<GameBloc>().add(DebugEvent(LeaderboardState(
        currentPlayer: Player(
            name: "Niklas Z",
            id: "1",
            isHost: true,
            score: const {
              "Art": 1,
              "Sport": 0,
              "Music": 0,
              "Video Games": 0,
              "Movies / TV": 1
            }),
        players: [
          Player(name: "Hugo", id: "2", isHost: true, score: const {
            "Art": 0,
            "Sport": 0,
            "Music": 1,
            "Video Games": 0,
            "Movies / TV": 1
          }),
          Player(name: "Niklas", id: "1", isHost: true, score: const {
            "Art": 0,
            "Sport": 1,
            "Music": 1,
            "Video Games": 1,
            "Movies / TV": 0
          }),
          Player(name: "Marianne", id: "3", isHost: true, score: const {
            "Art": 1,
            "Sport": 1,
            "Music": 1,
            "Video Games": 1,
            "Movies / TV": 1
          }),
          Player(name: "Niklas E", id: "5", isHost: true, score: const {
            "Art": 1,
            "Sport": 1,
            "Music": 1,
            "Video Games": 1,
            "Movies / TV": 1,
          }),
          Player(name: "Coralie", id: "4", isHost: true, score: const {
            "Art": 1,
            "Sport": 1,
            "Music": 1,
            "Video Games": 1,
            "Movies / TV": 0
          }),
        ],
        lobbySettings: const LobbySettings(
            pin: "1", numberOfQuestions: 1, difficulty: "Easy"))));
    return const MaterialApp(
      home: Scaffold(
        body: PodiumScreen(),
      ),
    );
  }
}

Future<void> main() async {
  final navigatorKey = GlobalKey<NavigatorState>();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(BlocProvider(
    create: (context) => GameBloc(navigatorKey),
    child: const MyApp(),
  ));
}
