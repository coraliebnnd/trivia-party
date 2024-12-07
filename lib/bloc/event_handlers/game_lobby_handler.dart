import 'dart:async';
import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_party/bloc/events/game_lobby_screen_events.dart';
import 'package:trivia_party/bloc/events/home_screen_events.dart';
import 'package:trivia_party/bloc/game.dart';
import 'package:trivia_party/bloc/states/category_voting_state.dart';
import 'package:trivia_party/bloc/states/game_lobby_state.dart';
import 'package:trivia_party/bloc/states/game_state.dart';

import '../models/player.dart';

class GameLobbyScreenHandler {
  final GameBloc gameBloc;

  StreamSubscription? _playersAddedSubscription;

  GameLobbyScreenHandler({required this.gameBloc});

  Future<void> onStartGame(
      StartGameEvent event, Emitter<GameState> emit) async {
    if (gameBloc.state is GameLobbyState) {
      var currentState = gameBloc.state as GameLobbyState;
      emit(
        CategoryVotingState(
            categoryVotes: const {},
            currentPlayer: currentState.currentPlayer,
            players: currentState.players),
      );
    }
  }

  Future<void> onStartFirebaseListener(StartFirebaseListenerEvent event, Emitter<GameState> emit) async {
    if (gameBloc.state is GameLobbyState) {
      cancelFirebaseListener();

      final currentState = gameBloc.state as GameLobbyState;
      final database = FirebaseDatabase.instance.ref();

      final pin = currentState.lobbySettings.pin;
      _playersAddedSubscription = database.child('lobbies/$pin/players').onChildAdded.listen((event) {
        final playerData = Map<String, dynamic>.from(event.snapshot.value as Map);

        final updatedPlayers = List<Player>.from(currentState.players)
          ..add(Player(
            name: playerData['name'],
            id: playerData['id'],
            isHost: playerData['isHost'],
            completedCategories: playerData['completedCategories'] ?? [],
            score: playerData['score'],
            color: Color(playerData['color'])
          ));

        emit(GameLobbyState(
          lobbySettings: currentState.lobbySettings,
          currentPlayer: currentState.currentPlayer,
          players: updatedPlayers
        ));
      });
    }
  }

  Future<void> onCancelFirebaseListener(CancelFirebaseListenerEvent event, Emitter<GameState> emit) async {
    cancelFirebaseListener();
  }

  void cancelFirebaseListener() {
    _playersAddedSubscription?.cancel();
  }
}
