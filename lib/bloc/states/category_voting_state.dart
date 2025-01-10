import 'package:trivia_party/bloc/models/lobby_settings.dart';
import 'package:trivia_party/bloc/models/player.dart';
import 'package:trivia_party/bloc/states/game_state.dart';

class CategoryVotingState extends GameState {
  final Map<int, int> categoryIdToNumberOfVotesMap;
  final Player currentPlayer;
  final List<Player> players;
  final LobbySettings lobbySettings;

  const CategoryVotingState(
      {required this.categoryIdToNumberOfVotesMap,
      required this.currentPlayer,
      required this.players,
        required this.lobbySettings});

  @override
  List<Object?> get props =>
      [categoryIdToNumberOfVotesMap, currentPlayer, players, lobbySettings];
}
