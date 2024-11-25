import 'package:equatable/equatable.dart';

abstract class GameEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

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

class StartGameEvent extends GameEvent {}

class VoteCategoryEvent extends GameEvent {
  final String category;

  VoteCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

class SubmitAnswerEvent extends GameEvent {
  final String answer;

  SubmitAnswerEvent(this.answer);

  @override
  List<Object?> get props => [answer];
}

class TimerTickEvent extends GameEvent {
  final int remaining;

  TimerTickEvent(this.remaining);

  @override
  List<Object?> get props => [remaining];
}
