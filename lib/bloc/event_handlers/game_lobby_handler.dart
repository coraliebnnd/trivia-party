import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_party/bloc/events/home_screen_events.dart';
import 'package:trivia_party/bloc/game.dart';
import 'package:trivia_party/bloc/states/category_voting_state.dart';
import 'package:trivia_party/bloc/states/game_lobby_state.dart';
import 'package:trivia_party/bloc/states/game_state.dart';

class GameLobbyScreenHandler {
  final GameBloc gameBloc;

  const GameLobbyScreenHandler({required this.gameBloc});

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
}
