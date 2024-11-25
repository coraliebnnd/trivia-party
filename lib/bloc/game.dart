// lib/blocs/game/game_bloc.dart
import 'dart:async';
import 'package:flutter/material.dart';
import "package:flutter_bloc/flutter_bloc.dart";
import 'package:trivia_party/bloc/player.dart';
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
    // Update category votes
    final updatedVotes = Map<String, int>.from(state.categoryVotes);
    updatedVotes[event.category] = (updatedVotes[event.category] ?? 0) + 1;

    emit(state.copyWith(
      categoryVotes: updatedVotes,
    ));
  }

  Future<void> _onSubmitAnswer(
    SubmitAnswerEvent event,
    Emitter<GameState> emit,
  ) async {
    if (state.correctAnswer == event.answer) {
      // Update player score
      final updatedPlayer = state.currentPlayer?.copyWith(
        score: (state.currentPlayer?.score ?? 0) + 1,
      );

      final updatedPlayers = state.players.map((player) {
        // Compare the IDs of the players to find the one to update
        if (player.id == updatedPlayer?.id) {
          return updatedPlayer!; // Safely unwrap the nullable updatedPlayer
        }
        return player;
      }).toList();

      // Emit the new state with updated values
      emit(state.copyWith(
        currentPlayer: updatedPlayer,
        players: updatedPlayers,
      ));
    }
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
}
