import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:trivia_party/bloc/models/categories.dart';
import 'dart:math';

import 'package:trivia_party/bloc/models/lobby_settings.dart';
import 'package:trivia_party/networking/question_loader.dart';

import '../bloc/models/player.dart';

final database = FirebaseDatabase.instance.ref();

String _generateLobbyCode() {
  final random = Random();
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ123456789';
  return String.fromCharCodes(Iterable.generate(
      6, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
}

Future<LobbySettings> createLobby(Player player) async {
  String lobbyCode = _generateLobbyCode();
  final settings = LobbySettings(
      pin: lobbyCode, numberOfQuestions: 10, difficulty: "medium");

  await database.child('lobbies/$lobbyCode/settings').set({
    "pin": settings.pin,
    "numberOfQuestions": settings.numberOfQuestions,
    "difficulty": settings.difficulty
  });

  await database
      .child('lobbies/$lobbyCode/gameState')
      .set({"kind": 'waitingRoom', "state": {}});

  return joinLobby(lobbyCode, player);
}

Future<LobbySettings> joinLobby(String pin, Player player) async {
  final playerName = player.name;
  await database.child('lobbies/$pin/players/$playerName').set({
    "id": player.id,
    "name": player.name,
    "isHost": player.isHost,
    "score": player.score,
    "color": player.color.value,
    "completedCategories": player.completedCategories
  });

  return getLobbySettings(pin);
}

String convertToFirebasePath(String path) {
  // '/' is an invalid character in firebase
  String pathToReturn = path.replaceAll(".", "_").replaceAll("/", "|");
  return pathToReturn;
}

Map<String, int> generateScoreMap() {
  return {
    convertToFirebasePath(categories[1]!.displayName): 0,
    categories[2]!.displayName: 0,
    categories[3]!.displayName: 0,
    categories[4]!.displayName: 0,
    categories[5]!.displayName: 0,
    categories[6]!.displayName: 0
  };
}

Future<LobbySettings> getLobbySettings(String pin) async {
  final lobbyRef = database.child('lobbies/$pin');
  final snapshot = await lobbyRef.get();

  final lobby = Map<String, dynamic>.from(snapshot.value as Map);

  return LobbySettings(
      pin: lobby['settings']['pin'],
      numberOfQuestions: lobby['settings']['numberOfQuestions'],
      difficulty: lobby['settings']['difficulty']);
}

Future<void> pushNumberOfQuestions(String pin, int numberOfQuestions) async {
  database.child('lobbies/$pin/settings').update({
    'numberOfQuestions': numberOfQuestions,
  });
}

Future<void> pushQuestion(String pin, QuestionAnswerPair question) async {
  List<String> answers = [];
  String correctAnswer = "";
  for (var answer in question.answers) {
    answers.add(answer.text);
    if (answer.isTrue) {
      correctAnswer = answer.text;
    }
  }
  database.child('lobbies/$pin/gameState/state/question').set({
    'question': question.question,
    'answers': answers,
    'correctAnswer': correctAnswer
  });
}

Future<void> pushDifficulty(String pin, String difficulty) async {
  database.child('lobbies/$pin/settings').update({
    'difficulty': difficulty,
  });
}

Future<void> startGame(String pin) async {
  await switchToVoting(pin);
  await initCategory(pin);
}

Future<void> initCategory(String pin) async {
  database.child('lobbies/$pin/gameState/state/category/category_id').set(-1);
}

Future<void> switchToVoting(String pin) async {
  Map<int, List> categoryVotingMap = {};
  for (var key in categories.keys) {
    categoryVotingMap[key] = [];
  }

  await database.child('lobbies/$pin/gameState').set({
    "kind": "voting",
    "state": {"votes": categoryVotingMap}
  });
}

Future<void> resetVotingInFirebase(String pin) async {
  await database.child('lobbies/$pin/gameState/state/votes').set({});
  await database.child('lobbies/$pin/gameState/state/category/category_id').set(
      undefinedCategory); // We need a value in category_id to get an update
}

Future<void> voteForCategory(
    String pin, Category newCategory, Player player) async {
  categories.forEach((id, category) {
    if (category.playerVotes.contains(player.id)) {
      removePlayerVoteFromCategory(pin, category, player);
    }
  });

  var currentVotes = List.from(newCategory.playerVotes);
  currentVotes.add(player.id);

  await database
      .child('lobbies/$pin/gameState/state/votes')
      .update({newCategory.id.toString(): currentVotes});
}

Future<void> removePlayerVoteFromCategory(
    String pin, Category category, Player player) async {
  final catId = category.id;

  category.playerVotes.remove(player.id);

  await database
      .child('lobbies/$pin/gameState/state/votes/$catId')
      .set(category.playerVotes);
}

Future<void> increaseScoreForCategory(
    String pin, String category, Player player) async {
  var firebaseIdPath = convertToFirebasePath(player.name);
  var firebaseCategory = convertToFirebasePath(category);
  int increasedScore = player.score[firebaseCategory]! + 1;
  await database
      .child('lobbies/$pin/players/$firebaseIdPath/score/$firebaseCategory')
      .set(increasedScore);
}

Future<void> setCategory(String pin, int id) async {
  await database
      .child('lobbies/$pin/gameState/state/category/category_id')
      .set(id);
}
