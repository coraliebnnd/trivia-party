import 'package:trivia_party/bloc/events/game_event.dart';
import 'package:trivia_party/bloc/models/player.dart';

class QuestionPreparationFinishedEvent extends GameEvent {}

class QuestionPeparationEvent extends GameEvent {
  final Player currentPlayer; // Optional field
  final List<Player> players; // Optional field
  final String category;
  // Constructor to initialize the fields
  QuestionPeparationEvent(this.category,
      {required this.currentPlayer, this.players = const []});

  @override
  List<Object?> get props => [category, currentPlayer, players];
}
