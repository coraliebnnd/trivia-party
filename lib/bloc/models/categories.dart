import 'package:flutter/material.dart';
import 'package:trivia_party/multiplayer/firebase_interface.dart';

const UNDEFINED_CATEGORY = -1;
final Map<int, Category> categories = {
  1: Category(1, [25], "Art", const Color.fromARGB(255, 214, 0, 132)),
  2: Category(2, [15], "Video Games", const Color.fromARGB(255, 136, 39, 175)),
  3: Category(3, [11, 14], "Movies & TV", Colors.blue),
  4: Category(4, [21], "Sport", const Color.fromARGB(255, 239, 124, 0)),
  5: Category(5, [12], "Music", const Color.fromARGB(255, 255, 204, 0)),
  6: Category(6, [10], "Books", const Color.fromARGB(255, 69, 152, 54)),
};

void resetCategoryVotes(String pin) {
  for (var entry in categories.entries) {
    entry.value.playerVotes = [];
  }
  resetVotingInFirebase(pin);
}

class Category {
  final int id;
  final List<int> apiIds;
  final String displayName;
  final Color color;
  List<String> playerVotes = [];

  Category(this.id, this.apiIds, this.displayName, this.color);
}
