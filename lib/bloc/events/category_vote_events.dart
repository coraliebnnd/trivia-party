import 'package:trivia_party/bloc/events/game_event.dart';
import 'package:trivia_party/bloc/models/player.dart';

import '../models/categories.dart';

class StartCategoryVoteEvent extends GameEvent {}

class FinishedCategoryVoteEvent extends GameEvent {
  final Map<int, int> categoryVotes;
  final Player currentPlayer; // Optional field
  final List<Player> players; // Optional field

  // Constructor to initialize the fields
  FinishedCategoryVoteEvent(this.categoryVotes,
      {required this.currentPlayer, this.players = const []});

  @override
  List<Object?> get props => [categoryVotes, currentPlayer, players];
}

class VoteCategoryEvent extends GameEvent {
  final Category category;
  final Player player;

  VoteCategoryEvent(this.category, this.player);

  @override
  List<Object?> get props => [category, player];
}

class VotesUpdatedFirebase extends GameEvent {
  final Map<int, Category> updatedVoting;

  VotesUpdatedFirebase(this.updatedVoting);

  @override
  List<Object?> get props => [updatedVoting];
}

class CategorySetFirebase extends GameEvent {
  final Category category;

  CategorySetFirebase({required this.category});

  @override
  List<Object?> get props => [category];
}
