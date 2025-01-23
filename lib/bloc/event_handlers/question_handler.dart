import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_party/bloc/events/question_screen_events.dart';
import 'package:trivia_party/bloc/events/question_result_events.dart';
import 'package:trivia_party/bloc/game.dart';
import 'package:trivia_party/bloc/states/game_state.dart';
import 'package:trivia_party/bloc/states/question_state.dart';
import 'package:trivia_party/multiplayer/firebase_interface.dart';


class QuestionScreenHandler {
  final GameBloc gameBloc;

  const QuestionScreenHandler({required this.gameBloc});

  void onRevealAnswer(RevealAnswerEvent event, Emitter<GameState> emit) {
    if (gameBloc.state is QuestionState) {
      final currentState = gameBloc.state as QuestionState;
      if (currentState.correctAnswer == currentState.selectedAnswer) {
        increaseScoreForCategory(currentState.lobbySettings.pin,
            currentState.category.displayName, currentState.currentPlayer);
      }
      emit(currentState.copyWith(isAnswerRevealed: true));
      Future.delayed(const Duration(seconds: 2), () {
          gameBloc.add(ShowQuestionResultEvent());
      });
    }
  }

/*  bool isAnyPlayerFinished(List<Player> players, int numberOfQuestions) {
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
  } */

  Future<void> onSubmitAnswer(
      SubmitAnswerEvent event, Emitter<GameState> emit) async {
    if (gameBloc.state is QuestionState) {
      emit((gameBloc.state as QuestionState)
          .copyWith(selectedAnswer: event.answer));
    }
  }
}
