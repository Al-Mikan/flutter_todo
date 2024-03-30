import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './edit_list_page.dart';
import './genre.dart';
import './task_list_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      home: MyHomePage(),
      theme: CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: CupertinoColors.systemBlue,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Genre> genres = [
    Genre(
      title: 'Today',
      tasksCount: 3,
      color: CupertinoColors.systemRed,
      icon: CupertinoIcons.calendar_today, // アイコンのサイズを24に変更
    ),
    Genre(
        title: 'Star',
        tasksCount: 0,
        color: CupertinoColors.systemYellow,
        icon: CupertinoIcons.star_fill),
    Genre(
      title: 'Completed',
      tasksCount: 0,
      color: CupertinoColors.systemGrey,
      icon: CupertinoIcons.check_mark,
    ),
  ];
  void _navigateToTaskList(BuildContext context, String genre) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => TaskListPage(
          genre: genre,
          removeGenre: _removeGenre,
        ),
      ),
    );
  }

  void _navigateToEditList(BuildContext context, String genre) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => EditListPage(
          genre: genre,
        ),
      ),
    );
  }

  void _removeGenre(String title) {
    setState(() {
      // タイトルが一致する最初のアイテムのインデックスを見つける
      int index = genres.indexWhere((genre) => genre.title == title);
      // 該当するアイテムが見つかった場合、そのインデックスを使用して削除
      if (index != -1) {
        genres.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      child: SafeArea(
        child: ListView(
          children: [
            CupertinoListSection.insetGrouped(
                backgroundColor: CupertinoColors.extraLightBackgroundGray,
                header: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('My Tasks'), // セクションのヘッダー
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => _navigateToEditList(context, ''),
                      child: const Text("Add Lists"),
                    )
                  ],
                ),
                children: genres.map((genre) {
                  return CupertinoListTile(
                    backgroundColor: CupertinoColors.white,
                    title: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(genre.title),
                    ),
                    additionalInfo: Text(genre.tasksCount.toString()),
                    leading: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: genre.color, // Containerの背景色
                        borderRadius: BorderRadius.circular(6), // 角丸の半径を指定
                      ),
                      child: Center(
                          child: Center(
                        child: Icon(genre.icon, color: CupertinoColors.white),
                      )),
                    ),
                    onTap: () => _navigateToTaskList(context, genre.title),
                    trailing: const CupertinoListTileChevron(),
                  );
                }).toList()),
          ],
        ),
      ),
    );
  }
}
