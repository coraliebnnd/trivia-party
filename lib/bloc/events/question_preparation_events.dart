import 'package:trivia_party/bloc/events/game_event.dart';
import 'package:trivia_party/bloc/models/categories.dart';
import 'package:trivia_party/bloc/models/player.dart';

class QuestionPreparationFinishedEvent extends GameEvent {}

class QuestionPeparationEvent extends GameEvent {
  final Player currentPlayer;
  final List<Player> players;
  final Category category;
  // Constructor to initialize the fields
  QuestionPeparationEvent(this.category,
      {required this.currentPlayer, this.players = const []});

  @override
  List<Object?> get props => [category, currentPlayer, players];
}

class QuestionLoadedByFirebaseEvent extends GameEvent {
  final Player currentPlayer; // Optional field
  final List<Player> players; // Optional field
  final Category category;
  final String question;
  final List<String> answers;
  final String correctAnswer;

  QuestionLoadedByFirebaseEvent(this.category, this.question, this.answers,
      this.correctAnswer, this.currentPlayer, this.players);

  @override
  List<Object?> get props =>
      [category, currentPlayer, players, question, answers, correctAnswer];
}
