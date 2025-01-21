import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_party/bloc/models/player.dart';
import 'package:trivia_party/bloc/states/question_result_state.dart';

import '../bloc/game.dart';
import '../bloc/states/game_state.dart';
import '../widgets/rainbow_wheel_widget.dart';

class QuestionResult extends StatelessWidget {
  const QuestionResult({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      buildWhen: (previousState, currentState) {
        return currentState is QuestionResultState;
      },
      builder: (context, state) {
        state as QuestionResultState;

        return Scaffold(
          backgroundColor: Colors.black,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Question Results",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.players.length,
                    itemBuilder: (context, index) {
                      final player = state.players[index];
                      final isMainPlayer = player.id == state.currentPlayer.id;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: _buildPlayerPie(
                          player,
                          player.color,
                          isMainPlayer: isMainPlayer,
                          numberOfQuestions:
                          state.lobbySettings.numberOfQuestions,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget for player pies
  Widget _buildPlayerPie(Player player, Color color,
      {bool isMainPlayer = false, int numberOfQuestions = 10}) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            RainbowWheel(
                progress: calculateProgressForPlayer(player, numberOfQuestions),
                size: 70, // Size of the rainbow circle
                borderWidth: 5, // Border width
                borderColor: color),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          player.name,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isMainPlayer ? Colors.white : Colors.white70,
          ),
        ),
      ],
    );
  }
}
