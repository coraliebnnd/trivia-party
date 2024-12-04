import 'package:flutter/material.dart';

const category_colors = {
  "Art": Colors.pink,
  "Video game": Colors.purple,
  "Movies / TV": Colors.blue,
  "Sport": Colors.orange,
  "Music": Colors.yellow,
  "Books": Colors.green,
  "Random": Colors.grey,
};

class Categories {
  static final String art = "Art";
  static final String video_game = "Video game";
  static final String movies_tv = "Movies / TV";
  static final String sport = "Sport";
  static final String music = "Music";
  static final String books = "Books";
  static final String random = "Random";

  static getColorOfCategory(String? category) {
    return category_colors[category];
  }
}
