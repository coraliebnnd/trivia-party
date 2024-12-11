import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_party/bloc/events/game_lobby_screen_events.dart';
import 'package:trivia_party/bloc/game.dart';
import 'package:trivia_party/bloc/states/game_lobby_state.dart';
import 'package:trivia_party/bloc/states/game_state.dart';
import 'package:trivia_party/multiplayer/firebase_interface.dart';

import '../models/player.dart';

class GameLobbyScreenHandler {
  final GameBloc gameBloc;

  GameLobbyScreenHandler({required this.gameBloc});

  Future<void> onStartGame(StartGameEvent event, Emitter<GameState> emit) async {
    if (gameBloc.state is GameLobbyState) {
      final currentState = gameBloc.state as GameLobbyState;
      await startGame(currentState.lobbySettings.pin);
    }
  }

  Future<void> onPlayerJoined(PlayerJoinedEvent event, Emitter<GameState> emit) async {
    if (gameBloc.state is GameLobbyState) {
      final currentState = gameBloc.state as GameLobbyState;
      emit(GameLobbyState(
          lobbySettings: currentState.lobbySettings,
          currentPlayer: currentState.currentPlayer,
          players: List<Player>.from(currentState.players)..add(event.player)
      ));
    }
  }
}
