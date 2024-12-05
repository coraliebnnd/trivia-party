import 'package:trivia_party/bloc/events/game_event.dart';

class CreateGameEvent extends GameEvent {
  final String playerName;
  final int numberOfQuestions;

  CreateGameEvent({
    required this.playerName,
    required this.numberOfQuestions,
  });

  @override
  List<Object?> get props => [playerName, numberOfQuestions];
}

class JoinGameEvent extends GameEvent {
  final String gamePin;
  final String playerName;

  JoinGameEvent({
    required this.gamePin,
    required this.playerName,
  });

  @override
  List<Object?> get props => [gamePin, playerName];
}
