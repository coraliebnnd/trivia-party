import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_party/bloc/models/categories.dart';
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
          backgroundColor: const Color(0xFF191919),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.players.length,
                    itemBuilder: (context, index) {
                      final player = state.players[index];
                      return _buildPlayerRow(
                        player,
                        state.currentCategory,
                        numberOfQuestions: state.lobbySettings.numberOfQuestions,
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

 Widget _buildPlayerRow(Player player, Category currentCategory,
      {int numberOfQuestions = 10}) {
    final int? score = player.score[currentCategory.displayName];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  player.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$score / $numberOfQuestions',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 4,
            child: Align(
              alignment: Alignment.centerLeft,
              child: RainbowWheel(
                progress: calculateProgressForPlayer(player, numberOfQuestions),
                size: 60,
                borderWidth: 4,
                borderColor: player.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
