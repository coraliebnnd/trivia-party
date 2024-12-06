import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_party/bloc/events/game_lobby_screen_events.dart';
import 'package:trivia_party/bloc/game.dart';
import 'package:trivia_party/bloc/states/game_state.dart';
import 'package:trivia_party/widgets/trivia_party_title_widget.dart';

import '../routes.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _playerNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.black,
                  Color(0xFF313131),
                ],
              ),
            ),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const TriviaPartyTitle(),
                        const SizedBox(height: 60),
                        _buildNameInput(),
                        const SizedBox(height: 40),
                        _buildButtons(context, state),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNameInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'Your Name',
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _playerNameController,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'Enter your name',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context, GameState state) {
    return Column(
      children: [
        _buildButton(
          'Create Game',
          LinearGradient(
            colors: [Colors.pink, Colors.pinkAccent.shade700],
          ),
          () {
            final playerName = _playerNameController.text;
            if (playerName.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter your name')),
              );
              return;
            }

            context.read<GameBloc>().add(CreateGameEvent(
                  playerName: playerName,
                  numberOfQuestions: 10,
                ));
          },
        ),
        const SizedBox(height: 16),
        _buildButton(
          'Join Game',
          const LinearGradient(
            colors: [Colors.purple, Colors.deepPurple],
          ),
          () {
            Navigator.pushNamed(context, Routes.joinGame);
          },
        ),
        const SizedBox(height: 16),
        _buildButton(
          'How to Play',
          LinearGradient(
            colors: [Colors.blue, Colors.blueAccent.shade700],
          ),
          () => Navigator.pushNamed(context, Routes.howToPlay),
        ),
      ],
    );
  }

  Widget _buildButton(
    String text,
    LinearGradient gradient,
    VoidCallback onPressed,
  ) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
