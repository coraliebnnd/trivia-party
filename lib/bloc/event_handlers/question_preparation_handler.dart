import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_party/bloc/events/question_preparation_events.dart';
import 'package:trivia_party/bloc/game.dart';
import 'package:trivia_party/bloc/models/answer.dart';
import 'package:trivia_party/bloc/states/game_state.dart';
import 'package:trivia_party/bloc/states/question_preparation_state.dart';
import 'package:trivia_party/bloc/states/question_state.dart';
import 'package:trivia_party/multiplayer/firebase_interface.dart';
import 'package:trivia_party/networking/question_loader.dart';

class QuestionPreparationScreenHandler {
  final GameBloc gameBloc;

  const QuestionPreparationScreenHandler({required this.gameBloc});

  Future<void> onQuestionLoadedByFirebase(
      QuestionLoadedByFirebaseEvent event, Emitter<GameState> emit) async {
    final currentState = gameBloc.state;
    if (currentState is QuestionPreparationState) {
      List<Answer> answers = [];
      for (var answer in event.answers) {
        answers.add(Answer(answer, answer == event.correctAnswer));
      }

      emit((currentState).copyWith(
        question: event.question,
        answers: answers,
      ));
    }
  }

  Future<void> onQuestionPreparationStarted(
    QuestionPeparationEvent event,
    Emitter<GameState> emit,
  ) async {
    final currentState = gameBloc.state;
    if (currentState is QuestionPreparationState) {
      try {
        final loadedQuestion = await QuestionLoader.loadQuestion();

        if (loadedQuestion != null && currentState.player.isHost) {
          pushQuestion(gameBloc.gamePin, loadedQuestion);
        }
      } catch (error) {
        // Handle any errors that may occur during question loading
        if (kDebugMode) {
          print('Error loading question: $error');
        }
      }
    }
  }

  Future<void> onQuestionPreparationFinished(
    QuestionPreparationFinishedEvent event,
    Emitter<GameState> emit,
  ) async {
    final currentState = gameBloc.state;
    if (currentState is QuestionPreparationState) {
      List<String> answers = [];
      String correctAnswer = "";
      for (var answer in currentState.answers) {
        answers.add(answer.text);
        if (answer.isTrue) {
          correctAnswer = answer.text;
        }
      }

      emit(QuestionState(
          category: currentState.category,
          currentQuestion: currentState.question,
          currentAnswers: answers,
          currentPlayer: currentState.player,
          correctAnswer: correctAnswer));
    }
  }
}
