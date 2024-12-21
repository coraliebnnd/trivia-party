import 'package:trivia_party/bloc/models/answer.dart';
import 'package:trivia_party/bloc/models/categories.dart';
import 'package:trivia_party/bloc/models/player.dart';
import 'package:trivia_party/bloc/states/game_state.dart';

class QuestionPreparationState extends GameState {
  final Category category;
  final Player player;
  final List<Player> players;
  final String question;
  final List<Answer> answers;

  const QuestionPreparationState(
    this.category,
    this.player,
    this.players, {
    this.question = '', // Default value for `question`
    this.answers = const [], // Default value for `answers`
  });

  @override
  List<Object?> get props => [category, player, players, question, answers];

  // The copyWith method
  QuestionPreparationState copyWith({
    Category? category,
    Player? player,
    List<Player>? players,
    String? question,
    List<Answer>? answers,
  }) {
    return QuestionPreparationState(
      category ?? this.category,
      player ?? this.player,
      players ?? this.players,
      question: question ?? this.question,
      answers: answers ?? this.answers,
    );
  }
}
