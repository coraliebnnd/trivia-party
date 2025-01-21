import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_party/bloc/events/question_result_events.dart';
import 'package:trivia_party/bloc/states/question_result_state.dart';
import '../game.dart';
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
          lobbySettings: currentState.lobbySettings));
    }
  }
}