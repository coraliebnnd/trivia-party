import 'package:trivia_party/bloc/events/game_event.dart';
import 'package:trivia_party/bloc/states/game_state.dart';

class DebugEvent extends GameEvent {
  final GameState newState;

  DebugEvent(this.newState);
}
