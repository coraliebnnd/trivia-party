import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
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
import 'package:trivia_party/bloc/states/game_lobby_state.dart';
import 'package:trivia_party/bloc/states/game_state.dart';
import 'package:trivia_party/bloc/states/home_screen_state.dart';
import 'events/game_event.dart';
import 'models/player.dart';

class GameBloc extends Bloc<GameEvent, GameState> {

  StreamSubscription? _playerJoinedSubscription;

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
    on<ShowJoinScreenEvent>(homeScreenHandler.onSwitchToJoinGame);

    on<StartGameEvent>(gameLobbyHandler.onStartGame);
    on<PlayerJoinedEvent>(gameLobbyHandler.onPlayerJoined);

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

  void startFirebaseListener() {
    cancelFirebaseListener();

    if (state is GameLobbyState) {
      cancelFirebaseListener();

      final currentState = state as GameLobbyState;
      final database = FirebaseDatabase.instance.ref();

      final pin = currentState.lobbySettings.pin;
      _playerJoinedSubscription = database.child('lobbies/$pin/players').onChildAdded.listen((event) {
        final playerData = Map<String, dynamic>.from(event.snapshot.value as Map);
        final player = Player.withColor(
            name: playerData['name'],
            id: playerData['id'],
            isHost: playerData['isHost'],
            completedCategories: playerData['completedCategories'] ?? [],
            score: playerData['score'],
            color: Color(playerData['color'])
        );

        add(PlayerJoinedEvent(player: player));
      });
    }
  }

  void cancelFirebaseListener() {
    _playerJoinedSubscription?.cancel();
  }
}
