import 'package:trivia_party/bloc/models/categories.dart';
import 'package:trivia_party/bloc/models/lobby_settings.dart';
import 'package:trivia_party/bloc/models/player.dart';
import 'package:trivia_party/bloc/states/game_state.dart';

class QuestionResultState extends GameState {
  final List<Player> players;
  final Player currentPlayer;
  final Category currentCategory;
  final LobbySettings lobbySettings;

  const QuestionResultState(
      {required this.players,
        required this.currentPlayer,
        required this.currentCategory,
        required this.lobbySettings});

  @override
  List<Object?> get props => [players, currentPlayer, currentCategory, lobbySettings];
}
