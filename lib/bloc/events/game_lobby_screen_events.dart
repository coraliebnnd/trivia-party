import 'package:trivia_party/bloc/events/game_event.dart';

class CreateGameEvent extends GameEvent {
  final String playerName;

  CreateGameEvent({
    required this.playerName,
  });

  @override
  List<Object?> get props => [playerName];
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

class StartFirebaseListenerEvent extends GameEvent {
  final String pin;

  StartFirebaseListenerEvent({
    required this.pin
  });

  @override
  List<Object?> get props => [pin];
}

class CancelFirebaseListenerEvent extends GameEvent {}