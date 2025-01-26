import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_party/bloc/events/question_screen_events.dart';
import 'package:trivia_party/bloc/game.dart';
import 'package:trivia_party/bloc/states/game_state.dart';
import 'package:trivia_party/bloc/states/question_state.dart';
import 'package:trivia_party/widgets/countdown_with_loading_bar_widget.dart';
import 'package:trivia_party/widgets/rainbow_wheel_widget.dart';
import 'package:audioplayers/audioplayers.dart';

class Question extends StatefulWidget {
  const Question({super.key});

  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<Question>
    with SingleTickerProviderStateMixin {
  late AnimationController _colorController;
  late Animation<double> _colorAnimation;
  bool _soundPlayed = false;
  final AudioPlayer audioPlayer = AudioPlayer();

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

      // Correct answer
      if (answer == state.correctAnswer) {
        if (answer == state.selectedAnswer) {
          if (!_soundPlayed) {
            audioPlayer.play(AssetSource('sounds/correct_answer_sound_effect.mp3'));
            _soundPlayed = true;
          }
          return _blendColors(
              state.currentPlayer.color, Colors.green, _colorAnimation.value);
        }
        return _blendColors(Colors.white, Colors.green, _colorAnimation.value);
      } 
      
      // Wrong answer
      else if (answer == state.selectedAnswer) {
        if (!_soundPlayed) {
          audioPlayer.play(AssetSource('sounds/wrong_answer_sound_effect.mp3'));
          _soundPlayed = true;
        }
        return _blendColors(
            state.currentPlayer.color, Colors.red, _colorAnimation.value);
      }
      return _blendColors(Colors.white, Colors.black54, _colorAnimation.value);
    } 
    // Answer selected
    else { 
      if (answer == state.selectedAnswer) {
        return _blendColors(Colors.white, state.currentPlayer.color, 0.5);
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
            color: const Color(0xFF191919),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final countdownHeight = constraints.maxHeight * 0.03;
                    final answersHeight = constraints.maxHeight * 0.5;
                    final rainbowWheelHeight = constraints.maxHeight * 0.2;

                    return Column(
                      children: [
                        // Question Section
                        SizedBox(
                          child: AnimatedBuilder(
                            animation: _colorAnimation,
                            builder: (context, child) {
                              return Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 20,
                                ),
                                decoration: BoxDecoration(
                                  color: state.category.color,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    state.currentQuestion,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: countdownHeight*0.5,
                        ),
                        // Countdown Section
                        SizedBox(
                          height: countdownHeight,
                          child: CountdownWithLoadingBar(
                            countdownSeconds: 10,
                            height: 20,
                            onCountdownComplete: () => _revealAnswer(context),
                          ),
                        ),
                        // Answer Buttons Section
                        SizedBox(
                          height: answersHeight,
                          child: LayoutBuilder(
                            builder: (context, answerConstraints) {
                              const double padding = 15;
                              final numberOfAnswers = state.currentAnswers.length;
                              final availableHeight = answerConstraints.maxHeight - padding*numberOfAnswers;
                              final buttonHeight = (availableHeight - (numberOfAnswers - 1) * 12) /
                                  numberOfAnswers;

                              return ListView.builder(
                                itemCount: state.currentAnswers.length,
                                itemBuilder: (context, index) {
                                  final answer = state.currentAnswers[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(top: padding),
                                    child: AnimatedBuilder(
                                      animation: _colorAnimation,
                                      builder: (context, child) {
                                        return SizedBox(
                                          height: buttonHeight.clamp(50, double.infinity),
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              if (!state.isAnswerRevealed) {
                                                context.read<GameBloc>().add(SubmitAnswerEvent(answer));
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: _getButtonColor(answer, state),
                                              foregroundColor: Colors.black87,
                                              padding: const EdgeInsets.symmetric(horizontal: 24),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: Text(
                                              answer,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: state.isAnswerRevealed
                                                    ? Colors.white
                                                    : Colors.black87,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        // Rainbow Wheel Section
                        SizedBox(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            child: RainbowWheel(
                              progress: calculateProgressForPlayer(
                                state.currentPlayer,
                                state.lobbySettings.numberOfQuestions,
                              ),
                              size: rainbowWheelHeight / 1.5,
                              borderWidth: rainbowWheelHeight / 25,
                              borderColor: state.currentPlayer.color,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
