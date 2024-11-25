import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_party/bloc/game.dart';
import 'package:trivia_party/bloc/game_state.dart';

import '../Routes.dart';
import '../widgets/CircularCountdown.dart';

class CategoryPreparation extends StatelessWidget {
  final String category;
  final Color categoryColor;
  final int countdown;

  const CategoryPreparation({
    Key? key,
    required this.category,
    required this.categoryColor,
    this.countdown = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: categoryColor,
        body: SafeArea(
          child: Center(
            // Added Center widget
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0), // Added horizontal padding
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
                    textAlign: TextAlign.center, // Added text alignment
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
                        duration: 5,
                        onCountdownComplete: () {
                          Navigator.pushNamed(context, Routes.question);
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
