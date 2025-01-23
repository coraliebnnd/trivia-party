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
      var playersInOrder = createSortedPlayerListForScoreboard(
          currentState.players, currentState);
      emit(LeaderboardState(
          currentPlayer: currentState.currentPlayer,
          players: playersInOrder,
          lobbySettings: currentState.lobbySettings));
    }
  }

  List<Player> createSortedPlayerListForScoreboard(
      List<Player> players, QuestionResultState currentState) {
    List<Player> playersInOrder = List.from(currentState.players);
    playersInOrder.sort((a, b) =>
        (numberOfCorrectAnswers(b, currentState) * 10000 + getTotalScore(a)) -
        (numberOfCorrectAnswers(a, currentState) * 10000 + getTotalScore(b)));
    swapFirstAndSecondPlayer(playersInOrder);
    return playersInOrder;
  }

  void swapFirstAndSecondPlayer(List<dynamic> players) {
    if (players.length > 1) {
      var temp0 = players[0];
      var temp1 = players[1];
      players[0] = temp1;
      players[1] = temp0;
    }
  }

  int getTotalScore(Player player) {
    return player.getTotalScore();
  }

  int numberOfCorrectAnswers(Player player, QuestionResultState state) {
    var numberOfQuestionsToBeAnswered = state.lobbySettings.numberOfQuestions;
    int numberOfCategoriesFilled = 0;
    for (var score in player.score.values) {
      numberOfCategoriesFilled +=
          score >= numberOfQuestionsToBeAnswered ? 1 : 0;
    }
    return numberOfCategoriesFilled;
  }
}
