import 'package:trivia_party/bloc/models/player.dart';
import 'package:trivia_party/bloc/states/game_state.dart';

class GameLobbyState extends GameState {
  final Player currentPlayer;
  final String? gamePin;
  final List<Player> players;
  final int numberOfQuestions;
  const GameLobbyState({
    required this.currentPlayer,
    this.gamePin,
    this.players = const [],
    this.numberOfQuestions = 0,
  });

  @override
  List<Object?> get props => [currentPlayer, gamePin, players];
}
