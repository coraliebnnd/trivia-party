import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_party/bloc/events/question_preparation_events.dart';
import 'package:trivia_party/bloc/game.dart';
import 'package:trivia_party/bloc/states/question_preparation_state.dart';
import 'package:trivia_party/bloc/states/game_state.dart';

import '../widgets/circular_countdown_widget.dart';

class CategoryPreparation extends StatelessWidget {
  final int countdown;

  const CategoryPreparation({
    super.key,
    this.countdown = 3,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      buildWhen: (previousState, currentState) {
        return currentState is QuestionPreparationState;
      },
      builder: (context, state) {
        state as QuestionPreparationState;
        final category = state.category;

        return Scaffold(
          backgroundColor: category.color,
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Next Question's Category Text
                    const Text(
                      "Next question's\ncategory :",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Category Name
                    Text(
                      category.displayName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Countdown Timer
                    Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: CircularCountdown(
                        duration: countdown,
                        onCountdownComplete: () {
                          context
                              .read<GameBloc>()
                              .add(QuestionPreparationFinishedEvent());
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
