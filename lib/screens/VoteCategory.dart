import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_party/Routes.dart';
import 'package:trivia_party/bloc/game.dart';
import 'package:trivia_party/bloc/game_event.dart';
import 'package:trivia_party/bloc/game_state.dart';
import 'package:trivia_party/categories.dart';
import 'package:trivia_party/widgets/CountdownWithLoadingBar.dart';
import 'package:trivia_party/widgets/RainbowWheel.dart';
import 'dart:math';

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
                  onCountdownComplete: () {
                    Navigator.pushNamed(context, Routes.categoryPreparation);
                    _votingForCategoryFinished(context);
                  },
                ),
                const SizedBox(height: 20),
                // Categories
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2.5,
                    children: [
                      _buildCategoryButton(
                        Categories.art,
                        Categories.getColorOfCategory(Categories.art),
                        votes: state.categoryVotes[Categories.art] ?? 0,
                        onTap: () =>
                            _voteForCategory(context, Categories.art, state),
                      ),
                      _buildCategoryButton(
                        Categories.video_game,
                        Categories.getColorOfCategory(Categories.video_game),
                        votes: state.categoryVotes[Categories.video_game] ?? 0,
                        onTap: () => _voteForCategory(
                            context, Categories.video_game, state),
                      ),
                      _buildCategoryButton(
                        Categories.movies_tv,
                        Categories.getColorOfCategory(Categories.movies_tv),
                        votes: state.categoryVotes[Categories.movies_tv] ?? 0,
                        onTap: () => _voteForCategory(
                            context, Categories.movies_tv, state),
                      ),
                      _buildCategoryButton(
                        Categories.sport,
                        Categories.getColorOfCategory(Categories.sport),
                        votes: state.categoryVotes[Categories.sport] ?? 0,
                        onTap: () =>
                            _voteForCategory(context, Categories.sport, state),
                      ),
                      _buildCategoryButton(
                        Categories.music,
                        Categories.getColorOfCategory(Categories.music),
                        votes: state.categoryVotes[Categories.music] ?? 0,
                        onTap: () =>
                            _voteForCategory(context, Categories.music, state),
                      ),
                      _buildCategoryButton(
                        Categories.books,
                        Categories.getColorOfCategory(Categories.books),
                        votes: state.categoryVotes[Categories.books] ?? 0,
                        onTap: () =>
                            _voteForCategory(context, Categories.books, state),
                      ),
                      _buildCategoryButton(
                        Categories.random,
                        Colors.grey,
                        votes: state.categoryVotes[Categories.random] ?? 0,
                        onTap: () =>
                            _voteForCategory(context, Categories.random, state),
                      ),
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
                      player.color,
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

  Widget _buildCategoryButton(
    String text,
    Color color, {
    int votes = 0,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
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
        ),
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
              size: 50, // Size of the rainbow circle
              borderWidth: 3, // Border width
              borderColor: color,
            ),
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

  void _votingForCategoryFinished(BuildContext context) {
    BlocProvider.of<GameBloc>(context).add(VoteCategoryFinishedEvent());
  }

  void _voteForCategory(
      BuildContext context, String category, GameState state) {
    final currentPlayer = state.currentPlayer;
    if (currentPlayer != null) {
      BlocProvider.of<GameBloc>(context)
          .add(VoteCategoryEvent(category, currentPlayer));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to vote: No current player!')),
      );
    }
  }
}
