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
          backgroundColor: Colors.black,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.players.length,
                      itemBuilder: (context, index) {
                        final player = state.players[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30.0),
                          child:  _buildPlayerPie(
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget for player pies
  Widget _buildPlayerPie(Player player, Color color, Category currentCategory,
      {int numberOfQuestions = 10}) {
    final int? score = player.score[currentCategory.displayName] ;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                player.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:  Colors.white,
                ),
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
            const SizedBox(width: 20),
            Center(
              child: Text(
                '$score / $numberOfQuestions',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:  Colors.white,
                ),
              ),
            ),
          ],
    );
  }
}
