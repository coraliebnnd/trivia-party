import 'package:equatable/equatable.dart';
import 'package:trivia_party/bloc/player.dart';

class GameState extends Equatable {
  final GameStatus status;
  final String? gamePin;
  final List<Player> players;
  final Player? currentPlayer;
  final Map<String, int> categoryVotes; // Tracks category votes
  final Map<String, String> playerVotes; // Tracks each player's vote
  final int numberOfQuestions;
  final String? selectedCategory;
  final String? currentQuestion;
  final List<String>? currentAnswers;
  final String? selectedAnswer;
  final String? correctAnswer;
  final bool isAnswerCorrect;
  final bool isAnswerRevealed;
  final int timeRemaining;

  const GameState({
    this.status = GameStatus.initial,
    this.gamePin,
    this.players = const [],
    this.currentPlayer,
    this.categoryVotes = const {},
    this.playerVotes = const {}, // Initialize playerVotes as an empty map
    this.numberOfQuestions = 5,
    this.selectedCategory,
    this.currentQuestion,
    this.currentAnswers,
    this.correctAnswer,
    this.selectedAnswer,
    this.isAnswerCorrect = false,
    this.isAnswerRevealed = false,
    this.timeRemaining = 30,
  });

  @override
  List<Object?> get props => [
        status,
        gamePin,
        players,
        currentPlayer,
        categoryVotes,
        playerVotes, // Add playerVotes to props for comparison
        numberOfQuestions,
        selectedCategory,
        currentQuestion,
        currentAnswers,
        correctAnswer,
        timeRemaining,
        selectedAnswer,
        isAnswerRevealed,
        isAnswerCorrect
      ];

  GameState copyWith({
    GameStatus? status,
    String? gamePin,
    List<Player>? players,
    Player? currentPlayer,
    Map<String, int>? categoryVotes,
    Map<String, String>? playerVotes, // Allow updating playerVotes
    int? numberOfQuestions,
    String? selectedCategory,
    String? currentQuestion,
    List<String>? currentAnswers,
    String? correctAnswer,
    int? timeRemaining,
    bool? isAnswerCorrect,
    String? selectedAnswer,
    bool? isAnswerRevealed,
  }) {
    return GameState(
      status: status ?? this.status,
      gamePin: gamePin ?? this.gamePin,
      players: players ?? this.players,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      categoryVotes: categoryVotes ?? this.categoryVotes,
      playerVotes: playerVotes ?? this.playerVotes, // Copy updated playerVotes
      numberOfQuestions: numberOfQuestions ?? this.numberOfQuestions,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      currentAnswers: currentAnswers ?? this.currentAnswers,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      isAnswerCorrect: isAnswerCorrect ?? this.isAnswerCorrect,
      isAnswerRevealed: isAnswerRevealed ?? this.isAnswerRevealed,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      timeRemaining: timeRemaining ?? this.timeRemaining,
    );
  }
}
