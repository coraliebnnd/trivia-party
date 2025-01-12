import 'package:equatable/equatable.dart';

class LobbySettings extends Equatable {
  final String pin;
  final int numberOfQuestions;
  final String difficulty;

  const LobbySettings({
    required this.pin,
    required this.numberOfQuestions,
    required this.difficulty,
  });

  @override
  List<Object?> get props => [pin, numberOfQuestions, difficulty];

  LobbySettings copyWith({
    String? pin,
    int? numberOfQuestions,
    String? difficulty,
  }) {
    return LobbySettings(
      pin: pin ?? this.pin,
      numberOfQuestions: numberOfQuestions ?? this.numberOfQuestions,
      difficulty: difficulty ?? this.difficulty,
    );
  }
}
