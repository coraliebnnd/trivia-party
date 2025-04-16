import 'package:trivia_party/bloc/models/player.dart';
import 'package:trivia_party/bloc/states/leaderboard_state.dart';

List<Player> createSortedPlayerListForScoreboard(
    List<Player> players, LeaderboardState currentState) {
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

int numberOfCorrectAnswers(Player player, LeaderboardState state) {
  var numberOfQuestionsToBeAnswered = state.lobbySettings.numberOfQuestions;
  int numberOfCategoriesFilled = 0;
  for (var score in player.score.values) {
    numberOfCategoriesFilled += score >= numberOfQuestionsToBeAnswered ? 1 : 0;
  }
  return numberOfCategoriesFilled;
}
