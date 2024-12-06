import 'package:trivia_party/bloc/events/game_event.dart';
import 'package:trivia_party/bloc/models/player.dart';

class StartCategoryVoteEvent extends GameEvent {}

class FinishedCategoryVoteEvent extends GameEvent {
  final Map<String, int> categoryVotes;
  final Player currentPlayer; // Optional field
  final List<Player> players; // Optional field

  // Constructor to initialize the fields
  FinishedCategoryVoteEvent(this.categoryVotes,
      {required this.currentPlayer, this.players = const []});

  @override
  List<Object?> get props => [categoryVotes, currentPlayer, players];
}

class VoteCategoryEvent extends GameEvent {
  final String category;
  final Player player;

  VoteCategoryEvent(this.category, this.player);

  @override
  List<Object?> get props => [category, player];
}
