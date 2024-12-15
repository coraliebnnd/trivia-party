import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:flutter_bloc/flutter_bloc.dart";
import 'package:trivia_party/bloc/event_handlers/category_vote_handler.dart';
import 'package:trivia_party/bloc/event_handlers/game_lobby_handler.dart';
import 'package:trivia_party/bloc/event_handlers/home_screen_handler.dart';
import 'package:trivia_party/bloc/event_handlers/question_handler.dart';
import 'package:trivia_party/bloc/event_handlers/question_preparation_handler.dart';
import 'package:trivia_party/bloc/events/category_vote_events.dart';
import 'package:trivia_party/bloc/events/game_lobby_screen_events.dart';
import 'package:trivia_party/bloc/events/question_preparation_events.dart';
import 'package:trivia_party/bloc/events/question_screen_events.dart';
import 'package:trivia_party/bloc/models/categories.dart' as category_model;
import 'package:trivia_party/bloc/models/lobby_settings.dart';
import 'package:trivia_party/bloc/states/game_lobby_state.dart';
import 'package:trivia_party/bloc/states/game_state.dart';
import 'package:trivia_party/bloc/states/home_screen_state.dart';
import 'events/game_event.dart';
import 'models/player.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  StreamSubscription? _playerJoinedSubscription;
  StreamSubscription? _settingsChangedSubscription;
  StreamSubscription? _gameStateSubscription;
  StreamSubscription? _voteAddedSubscription;
  StreamSubscription? _voteChangeSubscription;

  LobbySettings? lobbySettings;

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
    on<SettingsChangedFirebaseEvent>(
        gameLobbyHandler.onSettingsChangedFirebase);
    on<SettingsChangedGameEvent>(gameLobbyHandler.onSettingsChangedGame);

    on<StartGameEvent>(gameLobbyHandler.onStartGame);
    on<PlayerJoinedEvent>(gameLobbyHandler.onPlayerJoined);

    on<StartCategoryVoteEvent>(categoryVoteHandler.onStartCategoryVoting);
    on<FinishedCategoryVoteEvent>(categoryVoteHandler.onVoteCategoryFinished);
    on<VoteCategoryEvent>(categoryVoteHandler.onVoteCategory);
    on<VotesUpdatedFirebase>(categoryVoteHandler.onVotesUpdated);

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
      _playerJoinedSubscription =
          database.child('lobbies/$pin/players').onChildAdded.listen((event) {
        final playerData =
            Map<String, dynamic>.from(event.snapshot.value as Map);
        final player = Player.withColor(
            name: playerData['name'],
            id: playerData['id'],
            isHost: playerData['isHost'],
            completedCategories: playerData['completedCategories'] ?? [],
            score: playerData['score'],
            color: Color(playerData['color']));

        add(PlayerJoinedEvent(player: player));
      });

      _settingsChangedSubscription =
          database.child('lobbies/$pin/settings').onValue.listen((event) {
        if (event.snapshot.exists) {
          final settingsData =
              Map<String, dynamic>.from(event.snapshot.value as Map);
          add(SettingsChangedFirebaseEvent(
              numberOfQuestions: settingsData["numberOfQuestions"]));
        } else {
          if (kDebugMode) {
            print('Child was removed or no longer exists');
          }
        }
      });

      _gameStateSubscription =
          database.child('lobbies/$pin/gameState').onValue.listen((event) {
        final gameStateData =
            Map<String, dynamic>.from(event.snapshot.value as Map);
        final kind = gameStateData['kind'];

        switch (kind) {
          case 'waitingRoom':
            break;
          case 'voting':
            add(StartCategoryVoteEvent());
            break;
        }
      });
      
      _voteAddedSubscription = database.child('lobbies/$pin/gameState/state/votes').onChildAdded.listen((event) {
        final List<String> playerVotes = List.from(event.snapshot.value as List);

        category_model.Category? category = category_model.categories[int.parse(event.snapshot.key!)];

        category?.playerVotes = playerVotes;

        add(VotesUpdatedFirebase());
      });

      _voteChangeSubscription = database.child('lobbies/$pin/gameState/state/votes').onChildChanged.listen((event) {
        final List<String> playerVotes = List.from(event.snapshot.value as List);

        category_model.Category? category = category_model.categories[int.parse(event.snapshot.key!)];

        category?.playerVotes = playerVotes;

        add(VotesUpdatedFirebase());
      });
    }
  }

  void cancelFirebaseListener() {
    _playerJoinedSubscription?.cancel();
    _settingsChangedSubscription?.cancel();
    _gameStateSubscription?.cancel();
    _voteAddedSubscription?.cancel();
    _voteChangeSubscription?.cancel();
  }

  @override
  Future<void> close() {
    cancelFirebaseListener(); // Ensure listeners are cleaned up when the bloc is closed.
    return super.close();
  }
}
