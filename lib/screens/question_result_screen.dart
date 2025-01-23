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
          body: Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 100, 30),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  const SizedBox(height: 30),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.players.length,
                      itemBuilder: (context, index) {
                        final player = state.players[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child:  _buildPlayerRow(
                            player,
                            player.color,
                            state.currentCategory,
                            numberOfQuestions:
                            state.lobbySettings.numberOfQuestions,
                          ),
                        );
                      },
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget for player row
  Widget _buildPlayerRow(Player player, Color color, Category currentCategory,
      {int numberOfQuestions = 10}) {
    final int? score = player.score[currentCategory.displayName] ;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Center(
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                Text(
                      player.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color:  Colors.white,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                      '$score / $numberOfQuestions',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color:  Colors.white,
                      ),
                  ),
                ]
              ),
            ),
            const SizedBox(width: 20),
            Center(
              child: RainbowWheel(
                progress: calculateProgressForPlayer(player, numberOfQuestions),
                size: 80, // Size of the rainbow circle
                borderWidth: 5, // Border width
                borderColor: color
              ),
            ),
            /*const SizedBox(width: 20),
            const Center(
              child: Text(
                "+1",
                style: TextStyle(
                  color: Colors.pink,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),*/
          ],
    );
  }
}
