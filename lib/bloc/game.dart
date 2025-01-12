import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:flutter_bloc/flutter_bloc.dart";
import 'package:trivia_party/bloc/event_handlers/category_vote_handler.dart';
import 'package:trivia_party/bloc/event_handlers/game_lobby_handler.dart';
import 'package:trivia_party/bloc/event_handlers/home_screen_handler.dart';
import 'package:trivia_party/bloc/event_handlers/leaderboard_handler.dart';
import 'package:trivia_party/bloc/event_handlers/question_handler.dart';
import 'package:trivia_party/bloc/event_handlers/question_preparation_handler.dart';
import 'package:trivia_party/bloc/events/category_vote_events.dart';
import 'package:trivia_party/bloc/events/game_lobby_screen_events.dart';
import 'package:trivia_party/bloc/events/leaderboard_events.dart';
import 'package:trivia_party/bloc/events/question_preparation_events.dart';
import 'package:trivia_party/bloc/events/question_screen_events.dart';
import 'package:trivia_party/bloc/models/categories.dart' as category_model;
import 'package:trivia_party/bloc/models/lobby_settings.dart';
import 'package:trivia_party/bloc/states/category_voting_state.dart';
import 'package:trivia_party/bloc/states/game_lobby_state.dart';
import 'package:trivia_party/bloc/states/game_state.dart';
import 'package:trivia_party/bloc/states/home_screen_state.dart';
import 'package:trivia_party/bloc/states/question_preparation_state.dart';
import 'package:trivia_party/bloc/states/question_state.dart';
import 'package:trivia_party/multiplayer/firebase_interface.dart';
import 'events/game_event.dart';
import 'models/categories.dart';
import 'models/player.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  StreamSubscription? _playerJoinedSubscription;
  StreamSubscription? _settingsChangedSubscription;
  StreamSubscription? _gameStateSubscription;
  StreamSubscription? _questionSubscription;
  StreamSubscription? _scoreSubscription;

  StreamSubscription? _voteRemovedSubscription;
  StreamSubscription? _voteAddedSubscription;
  StreamSubscription? _voteChangeSubscription;
  StreamSubscription? _categorySetSubscription;

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
    LeaderBoardHandler leaderBoardHandler = LeaderBoardHandler(gameBloc: this);

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
    on<CategorySetFirebase>(categoryVoteHandler.onCategorySet);

    on<QuestionPeparationEvent>(
        questionPreparationHandler.onQuestionPreparationStarted);
    on<QuestionPreparationFinishedEvent>(
        questionPreparationHandler.onQuestionPreparationFinished);
    on<QuestionLoadedByFirebaseEvent>(
        questionPreparationHandler.onQuestionLoadedByFirebase);

    on<SubmitAnswerEvent>(questionHandler.onSubmitAnswer);
    on<RevealAnswerEvent>(questionHandler.onRevealAnswer);

    on<ShowLeaderBoardEvent>(leaderBoardHandler.onShowLeaderBoard);
  }

  Player getPlayerForKey(String name, List<Player> players) {
    for (var player in players) {
      if (player.name == name) {
        return player;
      }
    }
    throw (Exception("Player not found"));
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
        if (state is! GameLobbyState) {
          return;
        }

        var currentState = state as GameLobbyState;
        if (playerData["id"] == currentState.currentPlayer.id) {
          return; // preventing the player controlled by the user from being added twice
        }

        final player = Player.withColor(
            name: playerData['name'],
            id: playerData['id'],
            isHost: playerData['isHost'],
            completedCategories: playerData['completedCategories'] ?? [],
            score: generateScoreMap(),
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
      _questionSubscription = database
          .child('lobbies/$pin/gameState/state/question')
          .onValue
          .listen((event) {
        var currentState = state;
        if (currentState is! QuestionPreparationState) {
          if (kDebugMode) {
            print(
                "The Question listener was wrongly activated in state $currentState");
          }
          return;
        }
        final questionData =
            Map<String, dynamic>.from(event.snapshot.value as Map);
        add(QuestionLoadedByFirebaseEvent(
            currentState.category,
            questionData["question"],
            List<String>.from(questionData["answers"]),
            questionData["correctAnswer"],
            currentState.player,
            currentState.players));
      });

      _voteAddedSubscription = database
          .child('lobbies/$pin/gameState/state/votes')
          .onChildAdded
          .listen((event) {
        final List<String> playerVotes =
            List.from(event.snapshot.value as List);

        category_model.Category? category =
            category_model.categories[int.parse(event.snapshot.key!)];

        category?.playerVotes = playerVotes;

        add(VotesUpdatedFirebase(category_model.categories));
      });

      _voteChangeSubscription = database
          .child('lobbies/$pin/gameState/state/votes')
          .onChildChanged
          .listen((event) {
        final List<String> playerVotes =
            List.from(event.snapshot.value as List);

        category_model.Category? category =
            category_model.categories[int.parse(event.snapshot.key!)];

        category?.playerVotes = playerVotes;

        add(VotesUpdatedFirebase(category_model.categories));
      });

      _voteRemovedSubscription = database
          .child('lobbies/$pin/gameState/state/votes')
          .onChildRemoved
          .listen((event) {
        category_model.Category? category =
            category_model.categories[int.parse(event.snapshot.key!)];

        // The category was deleted completely from firebase
        // (No player is currently voting for it anymore)
        // So we just clear it to reflect it on our screen
        category?.playerVotes.clear();

        add(VotesUpdatedFirebase(category_model.categories));
      });

      _categorySetSubscription = database
          .child('lobbies/$pin/gameState/state/category')
          .onChildChanged
          .listen((event) {
        var currentState = state;
        if (currentState is CategoryVotingState) {
          if (event.snapshot.exists) {
            final categoryIDData = event.snapshot.value;
            bool categoryWasReset = categoryIDData == UNDEFINED_CATEGORY;
            if (categoryWasReset) {
              return; // CATEGORY was reset. Ignore
            }
            category_model.Category category = categories[categoryIDData]!;
            add(CategorySetFirebase(category: category));
          }
        }
      });

      _scoreSubscription = database
          .child('lobbies/$pin/players/')
          .onChildChanged
          .listen((event) {
        var currentState = state;
        if (currentState is! QuestionState) {
          if (kDebugMode) {
            print(
                "The Score listener was wrongly activated in state $currentState");
          }
          return;
        }

        // Access the changed key and value
        var updatedPlayer = event.snapshot.key;
        var updatedScore = (event.snapshot.value as Map)["score"];
        var playerToUpdate =
            getPlayerForKey(updatedPlayer.toString(), currentState.players);
        // Log or process the changes
        if (kDebugMode) {
          print("Child changed: $updatedPlayer, New value: $updatedScore");
        }

        // Ensure updatedScore is a Map and not null
        if (updatedScore == null) {
          if (kDebugMode) {
            print("Invalid updatedScore format: $updatedScore");
          }
          return;
        }

        // Update the player's score
        (updatedScore).forEach((key, value) {
          if (value is int) {
            playerToUpdate.score[key] = value;
          } else {
            if (kDebugMode) {
              print("Invalid score value for $key: $value");
            }
          }
        });
      });
    }
  }

  void cancelFirebaseListener() {
    _playerJoinedSubscription?.cancel();
    _settingsChangedSubscription?.cancel();
    _gameStateSubscription?.cancel();
    _voteAddedSubscription?.cancel();
    _voteChangeSubscription?.cancel();
    _voteRemovedSubscription?.cancel();
    _questionSubscription?.cancel();
    _scoreSubscription?.cancel();
    _categorySetSubscription?.cancel();
  }

  @override
  Future<void> close() {
    cancelFirebaseListener(); // Ensure listeners are cleaned up when the bloc is closed.
    return super.close();
  }
}
