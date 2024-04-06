import 'package:flutter/cupertino.dart';
import 'models/genre.dart';

List<Genre> myLists = [
  Genre(
      title: 'Sample',
      color: CupertinoColors.systemRed.value,
      icon: CupertinoIcons.calendar_today.codePoint,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now()),
  Genre(
      title: 'Sample2',
      color: CupertinoColors.systemBlue.value,
      icon: CupertinoIcons.paperclip.codePoint,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now()),
  Genre(
      title: 'Sample3',
      color: CupertinoColors.systemBlue.value,
      icon: CupertinoIcons.paperclip.codePoint,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now())
];
