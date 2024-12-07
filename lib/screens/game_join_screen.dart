import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_party/bloc/events/game_lobby_screen_events.dart';
import 'package:trivia_party/bloc/game.dart';
import 'package:trivia_party/bloc/states/game_join_state.dart';
import 'package:trivia_party/widgets/trivia_party_title_widget.dart';

import '../bloc/states/game_state.dart';

class GameJoinScreen extends StatelessWidget {
  const GameJoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController gamePinController = TextEditingController();

    return BlocBuilder<GameBloc, GameState>(
      buildWhen: (previousState, currentState) {
        return currentState is GameJoinState;
      },
      builder: (context, state) {
        state as GameJoinState;
        return Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const TriviaPartyTitle(),
                  Text(state.player.name),
                  const SizedBox(height: 50),
                  const Text(
                    'Game Pin',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: gamePinController,
                    style: const TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      final gamePin = gamePinController.text;
                      if (gamePin.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter a PIN')),
                        );
                        return;
                      }

                      context.read<GameBloc>().add(JoinGameEvent(gamePin: gamePin, player: state.player));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Join game',
                      style: TextStyle(fontSize: 18),
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
}
