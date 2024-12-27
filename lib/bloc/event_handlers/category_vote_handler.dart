import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_party/bloc/events/category_vote_events.dart';
import 'package:trivia_party/bloc/events/question_preparation_events.dart';
import 'package:trivia_party/bloc/game.dart';
import 'package:trivia_party/bloc/models/categories.dart';
import 'package:trivia_party/bloc/states/category_voting_state.dart';
import 'package:trivia_party/bloc/states/game_lobby_state.dart';
import 'package:trivia_party/bloc/states/game_state.dart';
import 'package:trivia_party/bloc/states/question_preparation_state.dart';
import 'package:trivia_party/bloc/states/question_state.dart';
import 'package:trivia_party/multiplayer/firebase_interface.dart';

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
          lobbySettings: currentState.lobbySettings,
          categoryIdToNumberOfVotesMap: const {},
        ),
      );
    } else if (currentState is QuestionState) {
      emit(
        CategoryVotingState(
            currentPlayer: currentState.currentPlayer,
            players: currentState.players,
            categoryIdToNumberOfVotesMap: const {},
            lobbySettings: currentState.lobbySettings),
      );
    }
  }

  Future<void> onVoteCategory(
      VoteCategoryEvent event, Emitter<GameState> emit) async {
    await voteForCategory(
        gameBloc.lobbySettings!.pin, event.category, event.player);
    // final currentState = gameBloc.state;
    // if (currentState is CategoryVotingState) {
    //   // Update category votes
    //   final updatedVotes = Map<String, int>.from(currentState.categoryVotes);
    //   updatedVotes[event.category] = (updatedVotes[event.category] ?? 0) + 1;
    //
    //   emit(CategoryVotingState(
    //       categoryVotes: updatedVotes,
    //       currentPlayer: currentState.currentPlayer,
    //       players: currentState.players));
    // }
  }

  Future<void> onVoteCategoryFinished(
      FinishedCategoryVoteEvent event, Emitter<GameState> emit) async {
    final currentState = gameBloc.state;
    if (currentState is CategoryVotingState) {
      final maxVotes = event.categoryVotes.values.reduce(max);
      final tiedCategories = event.categoryVotes.entries
          .where((entry) => entry.value == maxVotes)
          .map((entry) => entry.key)
          .toList();
      final random = Random();
      final mostVotedCategory =
          tiedCategories[random.nextInt(tiedCategories.length)];
      emit(QuestionPreparationState(categories[mostVotedCategory]!,
          event.currentPlayer, event.players, currentState.lobbySettings));
      gameBloc.add(QuestionPeparationEvent(categories[mostVotedCategory]!,
          currentPlayer: event.currentPlayer));
    }
  }

  Future<void> onVotesUpdated(
      VotesUpdatedFirebase event, Emitter<GameState> emit) async {
    final currentState = gameBloc.state as CategoryVotingState;
    Map<int, int> categoryIdToVotes = {};
    for (var key in categories.keys) {
      categoryIdToVotes[key] = categories[key]!.playerVotes.length;
    }
    emit(CategoryVotingState(
        currentPlayer: currentState.currentPlayer,
        players: currentState.players,
        categoryIdToNumberOfVotesMap: categoryIdToVotes,
        lobbySettings: currentState.lobbySettings));
  }
}
