import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_party/bloc/events/category_vote_events.dart';
import 'package:trivia_party/bloc/events/question_screen_events.dart';
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
            currentState.category, currentState.currentPlayer);
      }
      emit(currentState.copyWith(isAnswerRevealed: true));
      Future.delayed(const Duration(seconds: 3), () {
        gameBloc.add(StartCategoryVoteEvent());
      });
    }
  }

  Future<void> onSubmitAnswer(
      SubmitAnswerEvent event, Emitter<GameState> emit) async {
    if (gameBloc.state is QuestionState) {
      emit((gameBloc.state as QuestionState)
          .copyWith(selectedAnswer: event.answer));
    }
  }
}
