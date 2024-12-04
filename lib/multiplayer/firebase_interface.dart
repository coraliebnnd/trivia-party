import 'package:firebase_database/firebase_database.dart';
import 'dart:math';

final database = FirebaseDatabase.instance.ref();

String _generateLobbyCode() {
  final random = Random();
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
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