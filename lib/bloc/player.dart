// lib/blocs/game/game_state.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum GameStatus {
  initial,
  creating,
  joining,
  inProgress,
  voting,
  questioning,
  finished
}

class Player extends Equatable {
  final String name;
  final String id;
  final List<String> completedCategories;
  final int score;
  final Color color;

  const Player(
      {required this.name,
      required this.id,
      this.completedCategories = const [],
      this.score = 0,
      this.color = Colors.blue});

  @override
  List<Object?> get props => [name, id, completedCategories, score];

  Player copyWith({
    String? name,
    String? id,
    List<String>? completedCategories,
    int? score,
  }) {
    return Player(
      name: name ?? this.name,
      id: id ?? this.id,
      completedCategories: completedCategories ?? this.completedCategories,
      score: score ?? this.score,
    );
  }
}
