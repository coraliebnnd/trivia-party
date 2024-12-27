import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_party/bloc/events/game_lobby_screen_events.dart';
import 'package:trivia_party/bloc/game.dart';
import 'package:trivia_party/bloc/models/lobby_settings.dart';
import 'package:trivia_party/bloc/models/player.dart';
import 'package:trivia_party/bloc/states/game_join_state.dart';
import 'package:trivia_party/bloc/states/game_lobby_state.dart';
import 'package:trivia_party/bloc/states/game_state.dart';
import 'package:trivia_party/bloc/states/home_screen_state.dart';

import '../../multiplayer/firebase_interface.dart';

class HomeScreenHandler {
  final GameBloc gameBloc;
  LobbySettings? settings;

  final colors = [
    Colors.blue,
    Colors.red,
    Colors.yellow,
    Colors.amber,
    Colors.deepPurpleAccent,
    Colors.lightGreen,
  ];
  int colorIndex = 0;

  HomeScreenHandler({required this.gameBloc});

  Future<void> onCreateGame(
      CreateGameEvent event, Emitter<GameState> emit) async {
    final currentPlayer = Player(
        name: event.playerName,
        id: DateTime.now().toString(),
        isHost: true,
        score: generateScoreMap());

    emit(const HomeScreenState());

    settings = await createLobby(currentPlayer);
    List<Player> players = [currentPlayer];
    gameBloc.lobbySettings = settings;

    emit(GameLobbyState(
        currentPlayer: currentPlayer,
        players: players,
        lobbySettings: settings!));

    gameBloc.startFirebaseListener();
  }

  Future<void> onJoinGame(JoinGameEvent event, Emitter<GameState> emit) async {
    settings = await joinLobby(event.gamePin, event.player);
    gameBloc.lobbySettings = settings;

    List<Player> players = [event.player];
    emit(GameLobbyState(
        currentPlayer: event.player,
        players: players,
        lobbySettings: settings!));

    gameBloc.startFirebaseListener();
  }

  Future<void> onSwitchToJoinGame(
      ShowJoinScreenEvent event, Emitter<GameState> emit) async {
    final newPlayer = Player(
        name: event.playerName,
        id: DateTime.now().toString(),
        isHost: false,
        score: generateScoreMap());

    emit(GameJoinState(player: newPlayer));
  }
}
