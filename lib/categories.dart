import 'package:flutter/material.dart';

const categoryColors = {
  "Art": Colors.pink,
  "Video game": Colors.purple,
  "Movies / TV": Colors.blue,
  "Sport": Colors.orange,
  "Music": Colors.yellow,
  "Books": Colors.green,
  "Random": Colors.grey,
};

class Categories {
  static const String art = "Art";
  static const String videoGame = "Video game";
  static const String moviesTV = "Movies / TV";
  static const String sport = "Sport";
  static const String music = "Music";
  static const String books = "Books";
  static const String random = "Random";

  static getColorOfCategory(String? category) {
    return categoryColors[category];
  }
}
