import 'package:trivia_party/bloc/events/game_event.dart';

import '../models/player.dart';

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
  final Player player;

  JoinGameEvent({
    required this.gamePin,
    required this.player,
  });

  @override
  List<Object?> get props => [gamePin, player];
}

class PlayerJoinedEvent extends GameEvent {
  final Player player;

  PlayerJoinedEvent({
    required this.player
  });

  @override
  List<Object?> get props => [player];
}

class ShowJoinScreenEvent extends GameEvent {
  final String playerName;

  ShowJoinScreenEvent({
    required this.playerName
  });

  @override
  List<Object?> get props => [playerName];
}

class StartGameEvent extends GameEvent {

}

abstract class SettingsChangedEvent extends GameEvent {
  final int numberOfQuestions;

  SettingsChangedEvent({required this.numberOfQuestions});

  @override
  List<Object?> get props => [numberOfQuestions];
}

class SettingsChangedFirebaseEvent extends SettingsChangedEvent {
  SettingsChangedFirebaseEvent({required super.numberOfQuestions});
}

class SettingsChangedGameEvent extends SettingsChangedEvent {
  SettingsChangedGameEvent({required super.numberOfQuestions});
}
