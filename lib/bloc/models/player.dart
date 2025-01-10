// lib/blocs/game/game_state.dart
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum GameStatus {
  initial,
  creating,
  created,
  joining,
  inProgress,
  voting,
  questioning,
  finished
}

class Player extends Equatable {
  final String name;
  final String id;
  final bool isHost;
  final List<String> completedCategories;
  final Map<String, int> score;
  final Color color;

  static final List<Color> _availableColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.cyan,
    Colors.pink,
    Colors.teal,
  ];

  static final Random _random = Random();

  Player({
    required this.name,
    required this.id,
    required this.isHost,
    this.completedCategories = const [],
    required this.score,
  }) : color = _availableColors[_random.nextInt(_availableColors.length)];

  const Player.withColor({
    required this.name,
    required this.id,
    required this.isHost,
    required this.color,
    this.completedCategories = const [],
    required this.score,
  });

  @override
  List<Object?> get props => [name, id, completedCategories, score, color];
}
