import 'package:equatable/equatable.dart';
import 'package:trivia_party/bloc/player.dart';

class GameState extends Equatable {
  final GameStatus status;
  final String? gamePin;
  final List<Player> players;
  final Player? currentPlayer;
  final Map<String, int> categoryVotes;
  final int numberOfQuestions;
  final String? selectedCategory;
  final String? currentQuestion;
  final List<String>? currentAnswers;
  final String? correctAnswer;
  final int timeRemaining;

  const GameState({
    this.status = GameStatus.initial,
    this.gamePin,
    this.players = const [],
    this.currentPlayer,
    this.categoryVotes = const {},
    this.numberOfQuestions = 5,
    this.selectedCategory,
    this.currentQuestion,
    this.currentAnswers,
    this.correctAnswer,
    this.timeRemaining = 30,
  });

  @override
  List<Object?> get props => [
        status,
        gamePin,
        players,
        currentPlayer,
        categoryVotes,
        numberOfQuestions,
        selectedCategory,
        currentQuestion,
        currentAnswers,
        correctAnswer,
        timeRemaining,
      ];

  GameState copyWith({
    GameStatus? status,
    String? gamePin,
    List<Player>? players,
    Player? currentPlayer,
    Map<String, int>? categoryVotes,
    int? numberOfQuestions,
    String? selectedCategory,
    String? currentQuestion,
    List<String>? currentAnswers,
    String? correctAnswer,
    int? timeRemaining,
  }) {
    return GameState(
      status: status ?? this.status,
      gamePin: gamePin ?? this.gamePin,
      players: players ?? this.players,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      categoryVotes: categoryVotes ?? this.categoryVotes,
      numberOfQuestions: numberOfQuestions ?? this.numberOfQuestions,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      currentAnswers: currentAnswers ?? this.currentAnswers,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      timeRemaining: timeRemaining ?? this.timeRemaining,
    );
  }
}
