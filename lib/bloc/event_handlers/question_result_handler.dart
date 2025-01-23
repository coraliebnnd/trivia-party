import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_party/bloc/events/question_result_events.dart';
import 'package:trivia_party/bloc/states/question_result_state.dart';
import '../events/category_vote_events.dart';
import '../events/leaderboard_events.dart';
import '../game.dart';
import '../models/player.dart';
import '../states/game_state.dart';
import '../states/question_state.dart';

class QuestionResultHandler {
  final GameBloc gameBloc;

  const QuestionResultHandler({required this.gameBloc});

  void onShowQuestionResult(ShowQuestionResultEvent event, Emitter<GameState> emit) {
    if (gameBloc.state is QuestionState) {
      var currentState = gameBloc.state as QuestionState;
      emit(QuestionResultState(
          currentPlayer: currentState.currentPlayer,
          players: currentState.players,
          currentCategory: currentState.category,
          lobbySettings: currentState.lobbySettings));
      Future.delayed(const Duration(seconds: 3), () {
        if (isAnyPlayerFinished(currentState.players,
            currentState.lobbySettings.numberOfQuestions)) {
          gameBloc.add(ShowLeaderBoardEvent());
        } else {
          gameBloc.add(StartCategoryVoteEvent());
        }
      });
    }
  }

  bool isAnyPlayerFinished(List<Player> players, int numberOfQuestions) {
    for (var player in players) {
      if (isPlayerFinished(player, numberOfQuestions)) {
        return true;
      }
    }
    return false;
  }

  bool isPlayerFinished(Player player, int numberOfQuestions) {
    for (var scoreEntry in player.score.values) {
      if (scoreEntry < numberOfQuestions) {
        return false;
      }
    }
    return true;
  }
}