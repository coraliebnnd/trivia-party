import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_party/Routes.dart';
import 'package:trivia_party/bloc/game.dart';
import 'package:trivia_party/bloc/game_event.dart';
import 'package:trivia_party/bloc/game_state.dart';
import 'package:trivia_party/widgets/CountdownWithLoadingBar.dart';
import 'package:trivia_party/widgets/RainbowWheel.dart';

// For API
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';

class Question extends StatefulWidget {
  const Question({Key? key}) : super(key: key);

  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<Question>
    with SingleTickerProviderStateMixin {
  late AnimationController _colorController;
  late Animation<double> _colorAnimation;

  String? _currentQuestion;
  List<String>? _answers;
  String? _correctAnswer;
  String? _selectedAnswer;
  bool _isAnswerRevealed = false;

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

    _fetchQuestion();
  }

  @override
  void dispose() {
    _colorController.dispose();
    super.dispose();
  }

  String decodeHtml(String html) {
    final unescape = HtmlUnescape();
    return unescape.convert(html);
  }

  Future<void> _fetchQuestion() async {
    setState(() {
      _currentQuestion = null;
      _answers = null;
      _selectedAnswer = null;
      _isAnswerRevealed = false;
    });

    const url = 'https://opentdb.com/api.php?amount=1&category=10&type=multiple';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Parse the question and answers
        if (data['results'] != null && data['results'].isNotEmpty) {
          final questionData = data['results'][0];
          
          setState(() {
            _currentQuestion = decodeHtml(questionData['question']);
            _correctAnswer = questionData['correct_answer'];
            _answers = (questionData['incorrect_answers'] as List<dynamic>)
                .cast<String>()
              ..add(_correctAnswer!)
              ..shuffle(); // Shuffle the answers
          });
        }
      } else {
        throw Exception('Failed to load question');
      }
    } catch (e) {
      print('Error fetching question: $e');
    }
  }

  void _revealAnswer(BuildContext context) {
    context.read<GameBloc>().add(RevealAnswerEvent());

    setState(() {
      _isAnswerRevealed = true;  // Révéler la réponse après un certain délai
    });

    // Trigger color animation when answer is revealed
    _colorController.forward();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushNamed(Routes.voteCategory);
    });
  }

  Color _getButtonColor(String answer) {
    if (_isAnswerRevealed == true) {
      if (answer == _correctAnswer) {
        return Colors.green; // Correct answer
      } 
      else if (answer == _selectedAnswer) {
        return Colors.red; // Wrong selected answer
      } 
      else {
        return Colors.white; // Other answers
      }
    } 
    else if (answer == _selectedAnswer) {
      return Colors.grey;
    }
    return Colors.white;
  }

  void _onAnswerSelected(String answer) {
    setState(() {
      _selectedAnswer = answer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black87,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Question Container
                Container(
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
                    _currentQuestion ?? 'Loading question...',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Countdown Timer
                CountdownWithLoadingBar(
                  countdownSeconds: 10,
                  height: 20,
                  onCountdownComplete: () => _revealAnswer(context),
                ),
                const SizedBox(height: 20),
                if (_answers != null)
                  ..._answers!.map((answer) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AnimatedBuilder(
                        animation: _colorAnimation,
                        builder: (context, child) {
                          return ElevatedButton(
                            onPressed: (!_isAnswerRevealed && _selectedAnswer == null)
                                ? () {
                                    _onAnswerSelected(answer); // Call the answer selection logic
                                    context.read<GameBloc>().add(SubmitAnswerEvent(answer)); // Dispatch the event
                                  }
                                : null, // Disable buttons if answer is revealed or already selected
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _getButtonColor(answer),
                              foregroundColor: Colors.black87,
                              disabledBackgroundColor: _getButtonColor(answer),
                              disabledForegroundColor: Colors.black87,
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
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                const Spacer(),
                // Animated Rainbow Circle
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  child: const RainbowWheel(
                    size: 50,
                    borderWidth: 3,
                    borderColor: Color(0xFFE91E63),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
