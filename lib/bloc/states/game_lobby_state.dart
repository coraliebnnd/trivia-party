import 'package:trivia_party/bloc/models/lobby_settings.dart';
import 'package:trivia_party/bloc/models/player.dart';
import 'package:trivia_party/bloc/states/game_state.dart';

class GameLobbyState extends GameState {
  final Player currentPlayer;
  final List<Player> players;
  final LobbySettings lobbySettings;

  const GameLobbyState({
    required this.currentPlayer,
    required this.players,
    required this.lobbySettings
  });

  @override
  List<Object?> get props => [currentPlayer, lobbySettings, players];
}
