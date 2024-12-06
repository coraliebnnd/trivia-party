import 'package:flutter/material.dart';
import "package:flutter_bloc/flutter_bloc.dart";
import 'package:trivia_party/bloc/event_handlers/category_vote_handler.dart';
import 'package:trivia_party/bloc/event_handlers/game_lobby_handler.dart';
import 'package:trivia_party/bloc/event_handlers/home_screen_handler.dart';
import 'package:trivia_party/bloc/event_handlers/question_handler.dart';
import 'package:trivia_party/bloc/event_handlers/question_preparation_handler.dart';
import 'package:trivia_party/bloc/events/category_vote_events.dart';
import 'package:trivia_party/bloc/events/game_lobby_screen_events.dart';
import 'package:trivia_party/bloc/events/home_screen_events.dart';
import 'package:trivia_party/bloc/events/question_preparation_events.dart';
import 'package:trivia_party/bloc/events/question_screen_events.dart';
import 'package:trivia_party/bloc/states/game_state.dart';
import 'package:trivia_party/bloc/states/home_screen_state.dart';
import 'events/game_event.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc(GlobalKey<NavigatorState> navigatorKey)
      : super(const HomeScreenState()) {
    CategoryVoteScreenHandler categoryVoteHandler =
        CategoryVoteScreenHandler(gameBloc: this);
    QuestionPreparationScreenHandler questionPreparationHandler =
        QuestionPreparationScreenHandler(gameBloc: this);
    QuestionScreenHandler questionHandler =
        QuestionScreenHandler(gameBloc: this);
    GameLobbyScreenHandler gameLobbyHandler =
        GameLobbyScreenHandler(gameBloc: this);
    HomeScreenHandler homeScreenHandler = HomeScreenHandler(gameBloc: this);

    on<CreateGameEvent>(homeScreenHandler.onCreateGame);
    on<JoinGameEvent>(homeScreenHandler.onJoinGame);

    on<StartGameEvent>(gameLobbyHandler.onStartGame);

    on<StartCategoryVoteEvent>(categoryVoteHandler.onStartCategoryVoting);
    on<FinishedCategoryVoteEvent>(categoryVoteHandler.onVoteCategoryFinished);
    on<VoteCategoryEvent>(categoryVoteHandler.onVoteCategory);

    on<QuestionPeparationEvent>(
        questionPreparationHandler.onQuestionPreparationStarted);
    on<QuestionPreparationFinishedEvent>(
        questionPreparationHandler.onQuestionPreparationFinished);

    on<SubmitAnswerEvent>(questionHandler.onSubmitAnswer);
    on<RevealAnswerEvent>(questionHandler.onRevealAnswer);
  }
}
