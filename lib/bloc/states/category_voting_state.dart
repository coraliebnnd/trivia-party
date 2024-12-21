import 'package:trivia_party/bloc/models/player.dart';
import 'package:trivia_party/bloc/states/game_state.dart';

class CategoryVotingState extends GameState {
  final Map<int, int> categoryIdToNumberOfVotesMap;
  final Player currentPlayer;
  final List<Player> players;

  const CategoryVotingState(
      {required this.categoryIdToNumberOfVotesMap,
      required this.currentPlayer,
      required this.players});

  @override
  List<Object?> get props =>
      [categoryIdToNumberOfVotesMap, currentPlayer, players];
}
