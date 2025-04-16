import 'package:flutter/material.dart';
import 'package:trivia_party/multiplayer/firebase_interface.dart';

const undefinedCategory = -1;
int randomId = 7;
final Map<int, Category> categories = {
  1: Category(1, [25], "Art", Colors.pink),
  2: Category(2, [15], "Video Games", Colors.purple),
  3: Category(3, [11, 14], "Movies & TV", Colors.blue),
  4: Category(4, [21], "Sport", Colors.orange[600]!),
  5: Category(5, [12], "Music", Colors.yellow[700]!),
  6: Category(6, [10], "Books", Colors.green[600]!),
  randomId: Category(randomId, [-1], "Random", Colors.grey[600]!)
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
