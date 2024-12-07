import '../models/player.dart';
import 'game_state.dart';

class GameJoinState extends GameState {
  final Player player;

  const GameJoinState({
    required this.player
  });

  @override
  List<Object?> get props => [player];
}