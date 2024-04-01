import 'package:flutter/material.dart';

class Genre {
  final String title;
  final Color color;
  final IconData icon;
  final bool defaultGenre;

  Genre(
      {required this.title,
      required this.color,
      required this.icon,
      required this.defaultGenre});
}
