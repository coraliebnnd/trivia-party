import 'package:flutter/material.dart';
import 'package:trivia_party/widgets/RainbowWheel.dart';

import '../Routes.dart';

class VoteCategory extends StatelessWidget {
  const VoteCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            // Title
            Center(
              child: Text(
                "Vote for the next\nquestion's category!",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Orange separator line
            Container(
              height: 4,
              width: 150,
              color: Colors.orange,
            ),
            const SizedBox(height: 20),
            // Categories
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2.5,
                children: [
                  _buildCategoryButton('Art', Colors.pink,
                      votes: 0,
                      onTap: () => {
                            Navigator.pushNamed(
                                context, Routes.categoryPreparation)
                          }),
                  _buildCategoryButton('Video game', Colors.purple,
                      votes: 0,
                      onTap: () => {
                            Navigator.pushNamed(
                                context, Routes.categoryPreparation)
                          }),
                  _buildCategoryButton('Movies / TV', Colors.blue,
                      votes: 2,
                      onTap: () => {
                            Navigator.pushNamed(
                                context, Routes.categoryPreparation)
                          }),
                  _buildCategoryButton('Sport', Colors.orange,
                      votes: 0,
                      onTap: () => {
                            Navigator.pushNamed(
                                context, Routes.categoryPreparation)
                          }),
                  _buildCategoryButton('Music', Colors.lightBlue,
                      votes: 2,
                      onTap: () => {
                            Navigator.pushNamed(
                                context, Routes.categoryPreparation)
                          }),
                  _buildCategoryButton('Books', Colors.green,
                      votes: 0,
                      onTap: () => {
                            Navigator.pushNamed(
                                context, Routes.categoryPreparation)
                          }),
                  _buildCategoryButton('Random', Colors.grey,
                      onTap: () => {
                            Navigator.pushNamed(
                                context, Routes.categoryPreparation)
                          }),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Players and their pies
            Wrap(
              spacing: 20,
              alignment: WrapAlignment.center,
              children: [
                _buildPlayerPie('Coralie', Colors.purple),
                _buildPlayerPie('Niklas', Colors.blue),
                _buildPlayerPie('Jane', Colors.orange),
                _buildPlayerPie('Marianne', Colors.pink, isMainPlayer: true),
                _buildPlayerPie('Michel', Colors.yellow),
                _buildPlayerPie('John', Colors.green),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String text, Color color,
      {int votes = 0, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (votes > 0)
            Positioned(
              top: 4,
              right: 4,
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.white,
                child: Text(
                  '$votes',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Widget for player pies
  Widget _buildPlayerPie(String name, Color color,
      {bool isMainPlayer = false}) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            const RainbowWheel(
                size: 50, // Size of the rainbow circle
                borderWidth: 3, // Border width
                borderColor: Color(0xFFE91E63)) // Pink/magenta color),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          name,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isMainPlayer ? Colors.white : Colors.white70,
          ),
        ),
      ],
    );
  }
}
