import 'package:flutter/material.dart';

class Genre {
  final String title;
  final int tasksCount;
  final Color color;
  final IconData icon;

  Genre(
      {required this.title,
      required this.tasksCount,
      required this.color,
      required this.icon});
}
