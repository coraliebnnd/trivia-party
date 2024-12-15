import 'package:flutter/material.dart';

final Map<int, Category> categories = {
  1: Category(1, [25], "Art", Colors.pink),
  2: Category(2, [15], "Video Games", Colors.purple),
  3: Category(3, [11, 14], "Movies & TV", Colors.blue),
  4: Category(4, [21], "Sport", Colors.orange),
  5: Category(5, [12], "Music", Colors.yellow),
  6: Category(6, [10], "Books", Colors.green),
};

class Category {
  final int id;
  final List<int> apiIds;
  final String displayName;
  final MaterialColor color;
  List<String> playerVotes = [];

  Category(this.id, this.apiIds, this.displayName, this.color);
}