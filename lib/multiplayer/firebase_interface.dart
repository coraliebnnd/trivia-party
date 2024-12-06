import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_party/bloc/game.dart';
import 'package:trivia_party/bloc/game_event.dart';

import '../bloc/player.dart';

final database = FirebaseDatabase.instance.ref();
StreamSubscription? _playersStream;

String _generateLobbyCode() {
  final random = Random();
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ123456789';
  return String.fromCharCodes(Iterable.generate(6, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
}

Future<String> createLobby(String hostUserID) async {
  String lobbyCode = _generateLobbyCode();
  await database.child('lobbies/$lobbyCode').set({
    "host": hostUserID,
    "players": {
      hostUserID: {"name": "HostPlayer", "score": 0}
    },
    "quizStatus": "waiting"
  });
  return lobbyCode;
}

Future<bool> joinLobby(String lobbyCode, Player player) async {
  final lobbyRef = database.child("lobbies/$lobbyCode");
  final lobbySnapshot = await lobbyRef.get();

  String playerName = player.name;

  if (lobbySnapshot.exists) {
    await lobbyRef.child('players/$playerName').set({"name": playerName, "score": 0, "isHost": player.isHost});

    if (kDebugMode) {
      print("Beigetreten zur Lobby: $lobbyCode");
    }
    return true;
  } else {
    if (kDebugMode) {
      print("Lobby nicht gefunden.");
    }
    return false;
  }
}

Future<List<Player>> getPlayersOfLobby(String lobbyCode) async {
  final playersRef = database.child('lobbies/$lobbyCode/players');
  final playersSnapshot = await playersRef.get();

  if (playersSnapshot.exists && playersSnapshot.value is Map) {
    final playersMap = Map<String, dynamic>.from(playersSnapshot.value as Map);
    return playersMap.entries.map((entry) {
      final playerName = entry.key;
      final playerMap = Map<String, dynamic>.from(entry.value as Map);
      Player player = Player(name: playerName, id: DateTime.now().toString(), isHost: playerMap['isHost']);
      return player;
    }).toList();
  } else {
    return [];
  }
}

void startListeningToLobby(BuildContext context, String lobbyCode) {
  stopListeningToLobby();
  //_playersStream =
  database.child('lobbies/$lobbyCode/players').onChildAdded.listen((event) {
    BlocProvider.of<GameBloc>(context).add(PlayerJoinedGameEvent());
  });
}

void stopListeningToLobby() {
  _playersStream?.cancel();
}