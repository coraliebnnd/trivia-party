import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_party/bloc/events/game_lobby_screen_events.dart';
import 'package:trivia_party/bloc/game.dart';
import 'package:trivia_party/bloc/states/game_lobby_state.dart';
import 'package:trivia_party/bloc/states/game_state.dart';
import '../widgets/trivia_party_title_widget.dart';

class CreateGame extends StatelessWidget {
  const CreateGame({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      buildWhen: (previousState, currentState) {
        return currentState is GameLobbyState;
      },
      builder: (context, state) {
        state as GameLobbyState;
        return Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const TriviaPartyTitle(),
                  const SizedBox(height: 20),
                  // Game Pin
                  const Text(
                    'Game Pin',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    state.lobbySettings.pin,
                    style: const TextStyle(
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
                    const Text(
                      'Waiting for players...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  const SizedBox(height: 30),
                  // Number of Questions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Number of questions',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      DropdownButton<int>(
                        dropdownColor: Colors.grey[900],
                        value: state.lobbySettings.numberOfQuestions,
                        onChanged: state.currentPlayer.isHost
                            ? (value) {
                                context.read<GameBloc>().add(
                                    SettingsChangedGameEvent(
                                        numberOfQuestions: value ?? 0));
                              }
                            : null,
                        items: List.generate(
                          10,
                          (index) => DropdownMenuItem(
                            value: index + 1,
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(color: Colors.white),
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
                      splashFactory: state.currentPlayer.isHost
                          ? InkRipple.splashFactory // Default Ripple Effect
                          : NoSplash.splashFactory, // Remove Ripple Effect
                      backgroundColor: (state.currentPlayer.isHost)
                          ? Colors.pink
                          : Colors.grey,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      context.read<GameBloc>().add(StartGameEvent());
                    },
                    child: const Text(
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
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          name,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }
}
