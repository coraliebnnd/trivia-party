import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_party/Routes.dart';
import 'package:trivia_party/bloc/game.dart';
import 'package:trivia_party/bloc/game_event.dart';
import 'package:trivia_party/bloc/game_state.dart';
import 'package:trivia_party/widgets/CountdownWithLoadingBar.dart';
import 'package:trivia_party/widgets/RainbowWheel.dart';

class VoteCategory extends StatelessWidget {
  const VoteCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
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
                CountdownWithLoadingBar(
                    countdownSeconds: 10,
                    height: 20,
                    onCountdownComplete: () => Navigator.pushNamed(
                        context, Routes.categoryPreparation)),
                const SizedBox(height: 20),
                // Categories
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2.5,
                    children: [
                      _buildCategoryButton('Art', Colors.pink,
                          votes: state.categoryVotes['Art'] ?? 0,
                          onTap: () => _voteForCategory(context, 'Art')),
                      _buildCategoryButton('Video game', Colors.purple,
                          votes: state.categoryVotes['Video game'] ?? 0,
                          onTap: () => _voteForCategory(context, 'Video game')),
                      _buildCategoryButton('Movies / TV', Colors.blue,
                          votes: state.categoryVotes['Movies / TV'] ?? 0,
                          onTap: () =>
                              _voteForCategory(context, 'Movies / TV')),
                      _buildCategoryButton('Sport', Colors.orange,
                          votes: state.categoryVotes['Sport'] ?? 0,
                          onTap: () => _voteForCategory(context, 'Sport')),
                      _buildCategoryButton('Music', Colors.lightBlue,
                          votes: state.categoryVotes['Music'] ?? 0,
                          onTap: () => _voteForCategory(context, 'Music')),
                      _buildCategoryButton('Books', Colors.green,
                          votes: state.categoryVotes['Books'] ?? 0,
                          onTap: () => _voteForCategory(context, 'Books')),
                      _buildCategoryButton('Random', Colors.grey,
                          onTap: () => _voteForCategory(context, 'Random')),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Players and their pies
                Wrap(
                  spacing: 20,
                  alignment: WrapAlignment.center,
                  children: state.players.map((player) {
                    return _buildPlayerPie(
                      player.name,
                      player
                          .color, // Ensure your Player model has a `color` field
                      isMainPlayer: player.id == state.currentPlayer?.id,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
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
            RainbowWheel(
                progress: const [0.2, 0.4, 0.6, 0.8, 1.0, 0.0],
                size: 70, // Size of the rainbow circle
                borderWidth: 5, // Border width
                borderColor: color),
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

  void _voteForCategory(BuildContext context, String category) {
    BlocProvider.of<GameBloc>(context).add(VoteCategoryEvent(category));
  }
}
