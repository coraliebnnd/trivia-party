import 'package:trivia_party/bloc/events/game_event.dart';
import 'package:trivia_party/bloc/models/answer.dart';

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

class RevealAnswerEvent extends GameEvent {}
