import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_party/bloc/events/category_vote_events.dart';
import 'package:trivia_party/bloc/events/question_preparation_events.dart';
import 'package:trivia_party/bloc/game.dart';
import 'package:trivia_party/bloc/states/category_voting_state.dart';
import 'package:trivia_party/bloc/states/game_lobby_state.dart';
import 'package:trivia_party/bloc/states/game_state.dart';
import 'package:trivia_party/bloc/states/question_preparation_state.dart';
import 'package:trivia_party/bloc/states/question_state.dart';

class CategoryVoteScreenHandler {
  final GameBloc gameBloc;

  CategoryVoteScreenHandler({required this.gameBloc});

  Future<void> onStartCategoryVoting(
    StartCategoryVoteEvent event,
    Emitter<GameState> emit,
  ) async {
    final currentState = gameBloc.state;

    if (currentState is GameLobbyState) {
      emit(
        CategoryVotingState(
          currentPlayer: currentState.currentPlayer,
          players: currentState.players,
        ),
      );
    } else if (currentState is QuestionState) {
      emit(
        CategoryVotingState(
          currentPlayer: currentState.currentPlayer,
          players: currentState.players,
        ),
      );
    }
  }

  Future<void> onVoteCategory(
      VoteCategoryEvent event, Emitter<GameState> emit) async {
    final currentState = gameBloc.state;
    if (currentState is CategoryVotingState) {
      // Update category votes
      final updatedVotes = Map<String, int>.from(currentState.categoryVotes);
      updatedVotes[event.category] = (updatedVotes[event.category] ?? 0) + 1;

      emit(CategoryVotingState(
          categoryVotes: updatedVotes,
          currentPlayer: currentState.currentPlayer,
          players: currentState.players));
    }
  }

  Future<void> onVoteCategoryFinished(
      FinishedCategoryVoteEvent event, Emitter<GameState> emit) async {
    final currentState = gameBloc.state;
    if (currentState is CategoryVotingState) {
      String mostVotedCategory = event.categoryVotes.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;
      emit(QuestionPreparationState(
          mostVotedCategory, event.currentPlayer, event.players));
      gameBloc.add(QuestionPeparationEvent(mostVotedCategory,
          currentPlayer: event.currentPlayer));
    }
  }
}
