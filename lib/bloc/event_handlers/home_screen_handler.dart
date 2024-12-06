import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_party/bloc/events/game_lobby_screen_events.dart';
import 'package:trivia_party/bloc/game.dart';
import 'package:trivia_party/bloc/models/player.dart';
import 'package:trivia_party/bloc/states/game_lobby_state.dart';
import 'package:trivia_party/bloc/states/game_state.dart';
import 'package:trivia_party/bloc/states/home_screen_state.dart';

import '../../multiplayer/firebase_interface.dart';

class HomeScreenHandler {
  final GameBloc gameBloc;

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
    );

    emit(const HomeScreenState());

    String gamePin = await createLobby(currentPlayer.name);

    emit(GameLobbyState(
      currentPlayer: currentPlayer,
      numberOfQuestions: 10,
      gamePin: gamePin,
      players: [currentPlayer],
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
        gamePin: currentState.gamePin,
        players: updatedPlayers,
        currentPlayer: newPlayer,
      ));
    }
  }
}
