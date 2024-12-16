import 'package:trivia_party/bloc/models/answer.dart';
import 'package:trivia_party/bloc/models/lobby_settings.dart';
import 'package:trivia_party/bloc/models/player.dart';
import 'package:trivia_party/bloc/states/game_state.dart';

class QuestionPreparationState extends GameState {
  final String category;
  final Player player;
  final List<Player> players;
  final String question;
  final List<Answer> answers;
  final LobbySettings lobbySettings;

  const QuestionPreparationState(
    this.category,
    this.player,
    this.players,
    this.lobbySettings, {
    this.question = '', // Default value for `question`
    this.answers = const [], // Default value for `answers`
  });

  @override
  List<Object?> get props =>
      [category, player, players, question, answers, lobbySettings];

  // The copyWith method
  QuestionPreparationState copyWith(
      {String? category,
      Player? player,
      List<Player>? players,
      String? question,
      List<Answer>? answers,
      LobbySettings? lobbySettings}) {
    return QuestionPreparationState(
      category ?? this.category,
      player ?? this.player,
      players ?? this.players,
      lobbySettings ?? this.lobbySettings,
      question: question ?? this.question,
      answers: answers ?? this.answers,
    );
  }
}
