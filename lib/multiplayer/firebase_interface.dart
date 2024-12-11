import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'dart:math';

import 'package:trivia_party/bloc/models/lobby_settings.dart';

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
  final settings = LobbySettings(pin: lobbyCode, numberOfQuestions: 10);

  await database.child('lobbies/$lobbyCode/settings').set(
      {"pin": settings.pin, "numberOfQuestions": settings.numberOfQuestions});

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

Future<LobbySettings> getLobbySettings(String pin) async {
  final lobbyRef = database.child('lobbies/$pin');
  final snapshot = await lobbyRef.get();

  final lobby = Map<String, dynamic>.from(snapshot.value as Map);

  return LobbySettings(
      pin: lobby['settings']['pin'],
      numberOfQuestions: lobby['settings']['numberOfQuestions']);
}

Future<void> pushNumberOfQuestions(String pin, int numberOfQuestions) async {
  database.child('lobbies/$pin/settings').update({
    'numberOfQuestions': numberOfQuestions,
  });
}
