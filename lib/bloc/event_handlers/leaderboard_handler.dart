import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_party/bloc/events/leaderboard_events.dart';
import 'package:trivia_party/bloc/game.dart';
import 'package:trivia_party/bloc/models/player.dart';
import 'package:trivia_party/bloc/states/game_state.dart';
import 'package:trivia_party/bloc/states/leaderboard_state.dart';
import 'package:trivia_party/bloc/states/question_result_state.dart';

class LeaderBoardHandler {
  final GameBloc gameBloc;

  const LeaderBoardHandler({required this.gameBloc});

  Future<void> onShowLeaderBoard(
      ShowLeaderBoardEvent event, Emitter<GameState> emit) async {
    if (gameBloc.state is QuestionResultState) {
      var currentState = gameBloc.state as QuestionResultState;
      emit(LeaderboardState(
          currentPlayer: currentState.currentPlayer,
          players: currentState.players,
          lobbySettings: currentState.lobbySettings));
    }
  }
}
