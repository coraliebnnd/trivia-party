import 'package:equatable/equatable.dart';
import 'package:trivia_party/bloc/player.dart';

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
  final Player player;

  VoteCategoryEvent(this.category, this.player);

  @override
  List<Object?> get props => [category, player];
}

class VoteCategoryFinishedEvent extends GameEvent {
  VoteCategoryFinishedEvent();

  @override
  List<Object?> get props => [];
}

class Answer {
  final String text;
  final bool isTrue;
  Answer(this.text, this.isTrue);
}

class CreateQuestionEvent extends GameEvent {
  final String question;
  final List<Answer> answers;
  CreateQuestionEvent(this.question, this.answers);

  @override
  List<Object?> get props => [question, answers];
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

class RevealAnswerEvent extends GameEvent {}
