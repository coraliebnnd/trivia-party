import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_party/bloc/events/category_vote_events.dart';
import 'package:trivia_party/bloc/game.dart';
import 'package:trivia_party/bloc/models/player.dart';
import 'package:trivia_party/bloc/states/category_voting_state.dart';
import 'package:trivia_party/bloc/states/game_state.dart';
import 'package:trivia_party/categories.dart';
import 'package:trivia_party/widgets/countdown_with_loading_bar_widget.dart';
import 'package:trivia_party/widgets/rainbow_wheel_widget.dart';

class VoteCategory extends StatelessWidget {
  const VoteCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      buildWhen: (previousState, currentState) {
        return currentState is CategoryVotingState;
      },
      builder: (context, state) {
        state as CategoryVotingState;
        return Scaffold(
          backgroundColor: Colors.black,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // Title
                const Center(
                  child: Text(
                    "Vote for the next\nquestion's category!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
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
                    _votingForCategoryFinished(context, state);
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
                        Categories.videoGame,
                        Categories.getColorOfCategory(Categories.videoGame),
                        votes: state.categoryVotes[Categories.videoGame] ?? 0,
                        onTap: () => _voteForCategory(
                            context, Categories.videoGame, state),
                      ),
                      _buildCategoryButton(
                        Categories.moviesTV,
                        Categories.getColorOfCategory(Categories.moviesTV),
                        votes: state.categoryVotes[Categories.moviesTV] ?? 0,
                        onTap: () => _voteForCategory(
                            context, Categories.moviesTV, state),
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
                    return _buildPlayerPie(player, player.color,
                        isMainPlayer: player.id == state.currentPlayer.id,
                        numberOfQuestions:
                            state.lobbySettings.numberOfQuestions);
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
  Widget _buildPlayerPie(Player player, Color color,
      {bool isMainPlayer = false, int numberOfQuestions = 10}) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            RainbowWheel(
                progress: calculateProgressForPlayer(player, numberOfQuestions),
                size: 70, // Size of the rainbow circle
                borderWidth: 5, // Border width
                borderColor: color),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          player.name,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isMainPlayer ? Colors.white : Colors.white70,
          ),
        ),
      ],
    );
  }

  void _votingForCategoryFinished(
      BuildContext context, CategoryVotingState state) {
    BlocProvider.of<GameBloc>(context).add(FinishedCategoryVoteEvent(
        state.categoryVotes,
        currentPlayer: state.currentPlayer,
        players: state.players));
  }

  void _voteForCategory(
      BuildContext context, String category, CategoryVotingState state) {
    final currentPlayer = state.currentPlayer;
    BlocProvider.of<GameBloc>(context)
        .add(VoteCategoryEvent(category, currentPlayer));
  }
}
