// lib/screens/question_screen.dart
import 'package:flutter/material.dart';
import 'package:trivia_party/widgets/RainbowWheel.dart';

class Question extends StatefulWidget {
  const Question({Key? key}) : super(key: key);

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  final List<String> answers = [
    'Michaelangelo',
    'Botticelli',
    'Leonardo da Vinci',
    'Donatello',
  ];

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
                // Top status bar style content
                const SizedBox(height: 20),
                // Question container
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFE91E63), // Pink/magenta color
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Who painted\nthe Mona Lisa?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Answer buttons
                ...answers
                    .map((answer) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle answer selection
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 24,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              minimumSize: Size(double.infinity, 50),
                            ),
                            child: Text(
                              answer,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
                const Spacer(),
                // Bottom rainbow circle
                const RainbowWheel(
                  size: 50, // Size of the rainbow circle
                  borderWidth: 3, // Border width
                  borderColor: Color(0xFFE91E63), // Pink/magenta color
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
