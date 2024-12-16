import 'package:trivia_party/bloc/models/player.dart';
import 'package:trivia_party/bloc/states/game_state.dart';

class QuestionState extends GameState {
  final String currentQuestion;
  final String category;
  final List<String> currentAnswers;
  final String? selectedAnswer;
  final String? correctAnswer;
  final int timeRemaining;
  final bool isAnswerRevealed;
  final Player currentPlayer;

  final List<Player> players;

  const QuestionState(
      {required this.currentQuestion,
      required this.currentAnswers,
      required this.category,
      this.selectedAnswer,
      this.correctAnswer,
      this.timeRemaining = 30,
      this.isAnswerRevealed = false,
      required this.currentPlayer,
      this.players = const []});

  @override
  List<Object?> get props => [
        category,
        currentQuestion,
        currentAnswers,
        selectedAnswer,
        correctAnswer,
        timeRemaining,
        isAnswerRevealed,
        currentPlayer,
        players
      ];

  QuestionState copyWith({
    String? category,
    String? currentQuestion,
    List<String>? currentAnswers,
    String? selectedAnswer,
    String? correctAnswer,
    int? timeRemaining,
    bool? isAnswerRevealed,
    Player? currentPlayer,
    List<Player>? players,
  }) {
    return QuestionState(
      category: category ?? this.category,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      currentAnswers: currentAnswers ?? this.currentAnswers,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      isAnswerRevealed: isAnswerRevealed ?? this.isAnswerRevealed,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      players: players ?? this.players,
    );
  }
}
