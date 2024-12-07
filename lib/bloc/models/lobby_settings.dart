import 'package:equatable/equatable.dart';

class LobbySettings extends Equatable {

  final String pin;
  final int numberOfQuestions;

  const LobbySettings({
    required this.pin,
    required this.numberOfQuestions
  });

  @override
  List<Object?> get props => [this.pin, this.numberOfQuestions];

}