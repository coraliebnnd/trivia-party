import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_party/bloc/game.dart';
import 'package:trivia_party/bloc/game_state.dart';
import 'package:trivia_party/categories.dart';

import '../Routes.dart';
import '../widgets/CircularCountdown.dart';

class CategoryPreparation extends StatelessWidget {
  final int countdown;

  const CategoryPreparation({
    Key? key,
    this.countdown = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        final category = state.selectedCategory ?? "Loading...";

        return Scaffold(
          backgroundColor:
              Categories.getColorOfCategory(state.selectedCategory),
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
                      category,
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
                          Navigator.pushNamed(context, Routes.question);
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
