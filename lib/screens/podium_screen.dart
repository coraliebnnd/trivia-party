import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_party/bloc/events/home_screen_events.dart';
import 'package:trivia_party/bloc/game.dart';
import 'package:trivia_party/bloc/models/player.dart';
import 'package:trivia_party/bloc/states/game_state.dart';
import 'package:trivia_party/bloc/states/leaderboard_state.dart';
import 'package:trivia_party/podium_screen_utils.dart';

class PodiumScreen extends StatelessWidget {
  const PodiumScreen({super.key});

  Map<String, int> calculatePlayerRanks(
      List<Player> players, numberOfQuestionsPerCategory) {
    // Create a map to store player ranks
    final Map<String, int> ranks = {};

    // Sort players by total score in descending order
    final sortedPlayers = List<Player>.from(players)
      ..sort((a, b) => b
          .getNumberOfCorrectCategories(numberOfQuestionsPerCategory)
          .compareTo(
              a.getNumberOfCorrectCategories(numberOfQuestionsPerCategory)));

    // Initialize variables for rank calculation
    int currentRank = 1;
    int sameRankCount = 1;
    int lastScore = -1;

    // Iterate through sorted players to assign ranks
    for (var i = 0; i < sortedPlayers.length; i++) {
      final player = sortedPlayers[i];
      final currentScore = player.getTotalScore();

      // If current score is different from last score,
      // update rank and reset same rank counter
      if (currentScore < lastScore) {
        currentRank += sameRankCount;
        sameRankCount = 1;
      } else if (lastScore == currentScore) {
        // If scores are equal, increment same rank counter
        sameRankCount++;
      }

      lastScore = currentScore;

      // Assign rank to player
      ranks[player.id] = currentRank;
    }

    return ranks;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      buildWhen: (previous, current) => current is LeaderboardState,
      builder: (context, state) {
        if (state is! LeaderboardState) {
          return const Center(child: CircularProgressIndicator());
        }

        final players =
            createSortedPlayerListForScoreboard(state.players, state);
        final topPlayers = players.take(3).toList();
        final remainingPlayers =
            players.length > 3 ? players.skip(3).toList() : [];

        Map<String, int> playerRanks = calculatePlayerRanks(
            players, state.lobbySettings.numberOfQuestions);

        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
          ),
          child: Stack(
            children: [
              // Rotating rays using TweenAnimationBuilder
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 2 * pi),
                duration: const Duration(seconds: 100),
                builder: (context, double rotation, child) {
                  return CustomPaint(
                    size: Size.infinite,
                    painter: RaysPainter(
                        rotationAngle: rotation,
                        isTwoPlayers: players.length == 2),
                  );
                },
                onEnd: () {
                  (context as Element).markNeedsBuild();
                },
              ),

              // Podium Bars (Center)
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(
                    topPlayers.length,
                    (index) {
                      final player = topPlayers[index];
                      final heightFactor =
                          1.2 + (2 - playerRanks[player.id]!) * 0.2;
                      final width = 80.0 + (index == 1 ? 20 : 0);

                      return PodiumColumn(
                        rank: (playerRanks[player.id]).toString(),
                        name: player.name,
                        score: player.getTotalScore().toString(),
                        color: player.color,
                        heightFactor: heightFactor,
                        width: width,
                      );
                    },
                  ),
                ),
              ),

              // Rankings List (Foreground)
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Expanded(child: SizedBox()),
                  ...remainingPlayers.asMap().entries.map(
                    (entry) {
                      final player = entry.value;
                      return RankingTile(
                        rank: playerRanks[player.id]!,
                        name: player.name,
                        score: player.getTotalScore(),
                        color: player.color,
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(64.0),
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<GameBloc>().add(SwitchToHomeScreenEvent());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.home, color: Colors.white), // Home icon
                          SizedBox(width: 8), // Space between icon and text
                          Text(
                            "Home",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class RaysPainter extends CustomPainter {
  final double rotationAngle;

  bool isTwoPlayers;

  RaysPainter({required this.rotationAngle, required this.isTwoPlayers});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white10
      ..style = PaintingStyle.fill;

    var xOffsetForTwoPlayers = isTwoPlayers ? size.width / 9 : 0.0;
    final center =
        Offset(size.width / 2 + xOffsetForTwoPlayers, size.height / 4);

    final radius = size.width * 1.5;

    for (double i = 0; i < 360; i += 15) {
      final angle1 = (i + rotationAngle * 180 / pi) * pi / 180;
      final angle2 = (i + 7.5 + rotationAngle * 180 / pi) * pi / 180;

      final outerPoint1 = Offset(
        center.dx + radius * cos(angle1),
        center.dy + radius * sin(angle1),
      );

      final outerPoint2 = Offset(
        center.dx + radius * cos(angle2),
        center.dy + radius * sin(angle2),
      );

      final rayPath = Path()
        ..moveTo(center.dx, center.dy)
        ..lineTo(outerPoint1.dx, outerPoint1.dy)
        ..lineTo(outerPoint2.dx, outerPoint2.dy)
        ..close();

      canvas.drawPath(rayPath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class PodiumColumn extends StatelessWidget {
  final String rank;
  final String name;
  final String score;
  final Color color;
  final double heightFactor;
  final double width;

  const PodiumColumn({
    super.key,
    required this.rank,
    required this.name,
    required this.score,
    required this.color,
    required this.heightFactor,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: width,
          height: 450 * heightFactor,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                rank,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24 * heightFactor,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        Positioned(
          top: -10 - 25 * 2 * heightFactor,
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: color,
                radius: 25 * heightFactor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      score,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RankingTile extends StatelessWidget {
  final int rank;
  final String name;
  final int score;
  final Color color;

  const RankingTile({
    super.key,
    required this.rank,
    required this.name,
    required this.score,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color,
            child: Text(rank.toString(),
                style: const TextStyle(color: Colors.white)),
          ),
          title:
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          trailing: Text(
            score.toString(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
