import 'package:flutter/material.dart';

class HowToPlay extends StatelessWidget {
  const HowToPlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Center(
              child: Text(
                'TRIVIA\nPARTY',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Objective Section
            _buildSection(
              title: 'Objective of the Game :',
              content:
              'Each player must fill their pie with 6 wedges, each representing a question category. The first player to complete their pie wins the game.',
            ),
            const SizedBox(height: 20),
            // Earning Wedges Section
            _buildSection(
              title: 'Earning Wedges :',
              content:
              'To earn a wedge, a player must answer a set number of questions correctly, as defined at the beginning of the game (for example, five correct answers). Once this number is reached, the player wins the wedge for that category.',
            ),
            const SizedBox(height: 20),
            // Choosing the Category Section
            _buildSection(
              title: 'Choosing the Category :',
              content:
              'Before each question, all players vote to choose the category of the next question. Players have 30 seconds to vote.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}
