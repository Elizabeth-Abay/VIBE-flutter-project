// lib/core/constants/app_categories.dart
import 'package:flutter/material.dart';

class CategoryModel {
  final String name;
  final IconData icon; // Changed to IconData
  const CategoryModel({required this.name, required this.icon});
}


const List<CategoryModel> kAppCategories = [
  CategoryModel(name: 'Food', icon: Icons.fastfood_outlined),
  CategoryModel(name: 'Travel', icon: Icons.explore_outlined),
  CategoryModel(name: 'Music', icon: Icons.music_note_outlined),
  CategoryModel(name: 'Books', icon: Icons.menu_book_outlined),
  CategoryModel(name: 'Hackathon', icon: Icons.terminal_outlined),
  CategoryModel(name: 'Contests', icon: Icons.emoji_events_outlined),
  CategoryModel(name: 'FootBall', icon: Icons.sports_soccer_outlined),
  CategoryModel(name: 'BasketBall', icon: Icons.sports_basketball_outlined),
  CategoryModel(name: 'Games', icon: Icons.videogame_asset_outlined),
];