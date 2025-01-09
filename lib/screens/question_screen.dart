import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_party/bloc/events/question_screen_events.dart';
import 'package:trivia_party/bloc/game.dart';
import 'package:trivia_party/bloc/states/game_state.dart';
import 'package:trivia_party/bloc/states/question_state.dart';
import 'package:trivia_party/widgets/countdown_with_loading_bar_widget.dart';
import 'package:trivia_party/widgets/rainbow_wheel_widget.dart';

class Question extends StatefulWidget {
  const Question({super.key});

  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<Question>
    with SingleTickerProviderStateMixin {
  late AnimationController _colorController;
  late Animation<double> _colorAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize color animation controller
    _colorController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Create a curved animation for smooth color blending
    _colorAnimation = CurvedAnimation(
      parent: _colorController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _colorController.dispose();
    super.dispose();
  }

  void _revealAnswer(BuildContext context) {
    context.read<GameBloc>().add(RevealAnswerEvent());

    // Trigger color animation when answer is revealed
    _colorController.forward();
  }

  Color _blendColors(Color baseColor, Color targetColor, double t) {
    // Enhanced color blending with more natural transition and animation support
    return Color.lerp(baseColor, targetColor, t) ?? baseColor;
  }

  Color _getButtonColor(String answer, QuestionState state) {
    // Advanced color selection logic with animated color transitions
    if (state.isAnswerRevealed) {
      if (answer == state.correctAnswer) {
        if (answer == state.selectedAnswer) {
          // Animate to a green-yellow blend for correct selected answer
          return _blendColors(
              Colors.yellow, Colors.green, _colorAnimation.value);
        }
        // Animate to a green-white blend for correct unselected answer
        return _blendColors(Colors.white, Colors.green, _colorAnimation.value);
      } else if (answer == state.selectedAnswer) {
        // Animate to a red-yellow blend for incorrect selected answer
        return _blendColors(Colors.yellow, Colors.red, _colorAnimation.value);
      }
      // Subtle desaturation for non-selected answers when revealed
      return Colors.grey.withOpacity(0.5 * (1 - _colorAnimation.value));
    } else {
      if (answer == state.selectedAnswer) {
        // Blend between white and yellow for selection
        return _blendColors(Colors.white, Colors.yellow, 0.5);
      }
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      buildWhen: (previousState, currentState) {
        return currentState is QuestionState;
      },
      builder: (context, state) {
        state as QuestionState;
        return Scaffold(
          body: Container(
            color: Colors.black87,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Animated Question Container with Blended Color
                    AnimatedBuilder(
                      animation: _colorAnimation,
                      builder: (context, child) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE91E63),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            state.currentQuestion,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    // Countdown Timer
                    CountdownWithLoadingBar(
                      countdownSeconds: 10,
                      height: 20,
                      onCountdownComplete: () => _revealAnswer(context),
                    ),
                    const SizedBox(height: 20),
                    // Answer Buttons with Advanced Color Blending
                    ...state.currentAnswers.map((answer) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: AnimatedBuilder(
                          animation: _colorAnimation,
                          builder: (context, child) {
                            return ElevatedButton(
                              onPressed: () {
                                if (!state.isAnswerRevealed) {
                                  context
                                      .read<GameBloc>()
                                      .add(SubmitAnswerEvent(answer));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _getButtonColor(answer, state),
                                foregroundColor: Colors.black87,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 24,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: Text(
                                answer,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: state.isAnswerRevealed
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                    const Spacer(),
                    // Animated Rainbow Circle
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      child: RainbowWheel(
                        progress:
                            calculateProgressForPlayer(state.currentPlayer, 10),
                        size: 90,
                        borderWidth: 7,
                        borderColor: state.currentPlayer.color,
                      ),
                    ),
                    const SizedBox(height: 20),
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
