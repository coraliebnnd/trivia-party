import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_party/bloc/game.dart';
import 'package:trivia_party/bloc/game_state.dart';
import '../widgets/TriviaPartyTitle.dart';
import '../Routes.dart';

class CreateGame extends StatelessWidget {
  const CreateGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TriviaPartyTitle(),
                  const SizedBox(height: 20),
                  // Game Pin
                  Text(
                    'Game Pin',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    state.gamePin ?? 'Loading...',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Players List
                  if (state.players.isNotEmpty)
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 16,
                      runSpacing: 16,
                      children: state.players
                          .map((player) => _buildPlayerCircle(
                                player.name,
                                player.color,
                              ))
                          .toList(),
                    )
                  else
                    Text(
                      'Waiting for players...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  const SizedBox(height: 30),
                  // Number of Questions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Number of questions',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      DropdownButton<int>(
                        dropdownColor: Colors.grey[900],
                        value: state.numberOfQuestions,
                        onChanged: (value) {
                          // Handle dropdown change here
                        },
                        items: List.generate(
                          10,
                          (index) => DropdownMenuItem(
                            value: index + 1,
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Start Game Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      (state.currentPlayer?.isHost ?? false)
                            ? Colors.pink
                            : Colors.grey,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.voteCategory);
                      // Handle Start Game
                    },
                    child: Text(
                      'Start game',
                      style: TextStyle(fontSize: 18, color: Colors.white),
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

  Widget _buildPlayerCircle(String name, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: color,
          child: Text(
            name[0], // First letter of the name
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          name,
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }
}
