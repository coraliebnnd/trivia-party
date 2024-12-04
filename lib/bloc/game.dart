// lib/blocs/game/game_bloc.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import "package:flutter_bloc/flutter_bloc.dart";
import 'package:trivia_party/bloc/player.dart';
import 'package:trivia_party/categories.dart';
import 'package:trivia_party/networking/question_loader.dart';
import 'game_event.dart';
import 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  Timer? _timer;
  final colors = [
    Colors.blue,
    Colors.red,
    Colors.yellow,
    Colors.amber,
    Colors.deepPurpleAccent,
    Colors.lightGreen,
  ];
  int color_index = 0;

  GameBloc() : super(const GameState()) {
    on<CreateGameEvent>(_onCreateGame);
    on<JoinGameEvent>(_onJoinGame);
    on<StartGameEvent>(_onStartGame);
    on<VoteCategoryEvent>(_onVoteCategory);
    on<SubmitAnswerEvent>(_onSubmitAnswer);
    on<TimerTickEvent>(_onTimerTick);
    on<CreateQuestionEvent>(_onCreateQuestion);
    on<RevealAnswerEvent>(_onRevealAnswer);
    on<VoteCategoryFinishedEvent>(_onVoteCategoryFinished);
  }

  Future<void> _onCreateGame(
    CreateGameEvent event,
    Emitter<GameState> emit,
  ) async {
    emit(state.copyWith(status: GameStatus.creating));

    // Generate a random game PIN
    final gamePin = _generateGamePin();

    // Create current player
    final currentPlayer = Player(
      name: event.playerName,
      id: DateTime.now().toString(),
    );

    emit(state.copyWith(
      status: GameStatus.creating,
      gamePin: gamePin,
      currentPlayer: currentPlayer,
      players: [currentPlayer],
      numberOfQuestions: event.numberOfQuestions,
    ));

    emit(state.copyWith(status: GameStatus.creating));

    emit(state.copyWith(
      status: GameStatus.creating,
      gamePin: gamePin,
      currentPlayer: currentPlayer,
      players: [currentPlayer],
      numberOfQuestions: event.numberOfQuestions,
    ));

    // List of other players to join
    final newPlayers = [
      'Coralie',
      'Niklas',
      'Jane',
      'Marianne',
      'John',
      'Michel',
    ];

    addPlayersAsync(newPlayers, gamePin);
  }

  Future<void> addPlayersAsync(List<String> newPlayers, String gamePin) async {
    for (var name in newPlayers) {
      await Future.delayed(Duration(seconds: 1)); // Add a 1-second delay
      add(JoinGameEvent(playerName: name, gamePin: gamePin));
    }
  }

  Future<void> _onJoinGame(
    JoinGameEvent event,
    Emitter<GameState> emit,
  ) async {
    emit(state.copyWith(status: GameStatus.joining));

    // Create new player
    final newPlayer = Player(
        name: event.playerName,
        id: DateTime.now().toString(),
        color: colors[color_index]);
    color_index += 1;

    // Add player to the game
    final updatedPlayers = List<Player>.from(state.players)..add(newPlayer);

    emit(state.copyWith(
      status: GameStatus.joining,
      currentPlayer: newPlayer,
      players: updatedPlayers,
    ));
  }

  Future<void> _onStartGame(
    StartGameEvent event,
    Emitter<GameState> emit,
  ) async {
    emit(state.copyWith(
      status: GameStatus.voting,
    ));
    _startTimer();
  }

  Future<void> _onVoteCategory(
    VoteCategoryEvent event,
    Emitter<GameState> emit,
  ) async {
    final currentPlayer = state.currentPlayer;

    // Ensure the current player exists
    if (currentPlayer == null) return;

    // Create a copy of the current votes
    final updatedVotes = Map<String, int>.from(state.categoryVotes);
    final updatedPlayerVotes = Map<String, String>.from(state.playerVotes);

    // Check if the player has already voted
    if (updatedPlayerVotes.containsKey(currentPlayer.id)) {
      // Remove the player's previous vote from the categoryVotes
      final previousCategory = updatedPlayerVotes[currentPlayer.id];
      if (previousCategory != null &&
          updatedVotes.containsKey(previousCategory)) {
        updatedVotes[previousCategory] = (updatedVotes[previousCategory]! - 1)
            .clamp(0, double.infinity)
            .toInt();
        if (updatedVotes[previousCategory] == 0) {
          updatedVotes.remove(previousCategory);
        }
      }
    }

    // Register the player's new vote
    updatedVotes[event.category] = (updatedVotes[event.category] ?? 0) + 1;
    updatedPlayerVotes[currentPlayer.id] = event.category;

    // Emit the updated state
    emit(state.copyWith(
      categoryVotes: updatedVotes,
      playerVotes: updatedPlayerVotes,
    ));
  }

  Future<void> _onSubmitAnswer(
    SubmitAnswerEvent event,
    Emitter<GameState> emit,
  ) async {
    print("submit Answer called");
    emit(state.copyWith(selectedAnswer: event.answer));
  }

  void _onTimerTick(
    TimerTickEvent event,
    Emitter<GameState> emit,
  ) {
    emit(state.copyWith(timeRemaining: event.remaining));

    if (event.remaining <= 0) {
      _timer?.cancel();
      if (state.status == GameStatus.voting) {
        emit(state.copyWith(status: GameStatus.questioning));
      }
    }
  }

  void _startTimer() {
    _timer?.cancel();
    const duration = Duration(seconds: 1);
    int remaining = 30;

    _timer = Timer.periodic(duration, (timer) {
      remaining--;
      add(TimerTickEvent(remaining));
    });
  }

  String _generateGamePin() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    final result = List.generate(6, (index) {
      final randomIndex = (random + index) % chars.length;
      return chars[randomIndex];
    });
    return result.join();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  Future<void> _onCreateQuestion(
      CreateQuestionEvent event, Emitter<GameState> emit) async {
    // Update the state with the new question and answers
    emit(state.copyWith(
      currentQuestion: event.question,
      currentAnswers: event.answers.map((answer) => answer.text).toList(),
      correctAnswer: event.answers.firstWhere((answer) => answer.isTrue).text,
      status: GameStatus.questioning, // Optional: Update status if needed
    ));
  }

  void _onRevealAnswer(RevealAnswerEvent event, Emitter<GameState> emit) {
    emit(state.copyWith(isAnswerRevealed: true));
  }

  void _onVoteCategoryFinished(
      VoteCategoryFinishedEvent event, Emitter<GameState> emit) {
    String currentCategory = "";
    int currentMaxVotes = -1;
    state.categoryVotes.forEach((category, votes) {
      if (votes > currentMaxVotes) {
        currentCategory = category;
        currentMaxVotes = votes;
      }
    });

    if (currentMaxVotes == 0 || currentCategory == "Random") {
      var categories_for_choice = [
        Categories.books,
        Categories.sport,
        Categories.music,
        Categories.movies_tv,
        Categories.video_game,
        Categories.art
      ];
      currentCategory =
          categories_for_choice[Random().nextInt(categories_for_choice.length)];
    }
    emit(state.copyWith(selectedCategory: currentCategory));

    QuestionLoader.loadQuestion().then((loadedQuestion) {
      if (loadedQuestion != null) {
        add(CreateQuestionEvent(
          loadedQuestion.question,
          loadedQuestion.answers,
        ));
      } else {
        print("Error loading Question");
      }
    });
  }
}
