import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_party/bloc/events/game_lobby_screen_events.dart';
import 'package:trivia_party/bloc/game.dart';
import 'package:trivia_party/bloc/models/lobby_settings.dart';
import 'package:trivia_party/bloc/models/player.dart';
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

  Future<void> onCreateGame(CreateGameEvent event, Emitter<GameState> emit) async {
    final currentPlayer = Player(
      name: event.playerName,
      id: DateTime.now().toString(),
      isHost: true,
    );

    emit(const HomeScreenState());

    settings = await createLobby(currentPlayer);

    emit(GameLobbyState(
      currentPlayer: currentPlayer,
      players: const [],
      lobbySettings: settings!
    ));


  }

  Future<void> onJoinGame(JoinGameEvent event, Emitter<GameState> emit) async {
    if (gameBloc.state is GameLobbyState) {
      final currentState = gameBloc.state as GameLobbyState;

      final newPlayer = Player(
        name: event.playerName,
        id: DateTime.now().toString(),
        color: colors[colorIndex % colors.length],
        isHost: false,
      );
      colorIndex++;

      final updatedPlayers = List<Player>.from(currentState.players)
        ..add(newPlayer);

      emit(GameLobbyState(
        currentPlayer: newPlayer,
        players: updatedPlayers,
        lobbySettings: settings!
      ));
    }
  }
}
