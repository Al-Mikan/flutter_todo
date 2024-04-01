import 'package:clear_tasks/widgets/add_task_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'pages/edit_list_page.dart';
import 'genre.dart';
import 'pages/task_list_page.dart';
import 'pages/add_task_page.dart';
import 'dummy_data.dart';

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
      tasksCount: 0,
      color: CupertinoColors.systemRed,
      icon: CupertinoIcons.calendar_today,
    ),
    Genre(
        title: 'Scheduled',
        tasksCount: 0,
        color: CupertinoColors.systemBlue,
        icon: CupertinoIcons.paperclip),
    Genre(
        title: 'All',
        tasksCount: 0,
        color: CupertinoColors.black,
        icon: CupertinoIcons.tray_fill),
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

  void _navigateToTaskList(BuildContext context, Genre genre) {
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

  void _navigateToEditList(BuildContext context, Genre genre) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => EditListPage(
          genre: genre,
        ),
      ),
    );
  }

  void _navigateToTaskAddPage(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const AddTaskPage(),
      ),
    );
  }

  void _removeGenre(Genre genre) {
    setState(() {
      final index = genres.indexWhere((element) => element == genre);
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
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: ListView(
                children: [
                  CupertinoListSection.insetGrouped(
                    backgroundColor: CupertinoColors.extraLightBackgroundGray,
                    header: Text('Genre'),
                    children: genres.map((genre) {
                      return CupertinoListTile(
                        backgroundColor: CupertinoColors.white,
                        title: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Text(genre.title),
                        ),
                        additionalInfo: genre.title == "Completed"
                            ? null
                            : Text(genre.tasksCount.toString()),
                        leading: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: genre.color,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Icon(
                              genre.icon,
                              color: CupertinoColors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        onTap: () => _navigateToTaskList(context, genre),
                        trailing: const CupertinoListTileChevron(),
                      );
                    }).toList(),
                  ),
                  CupertinoListSection.insetGrouped(
                    backgroundColor: CupertinoColors.extraLightBackgroundGray,
                    header: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('My Lists'),
                        SizedBox(
                          height: 30,
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () => _navigateToEditList(
                              context,
                              Genre(
                                title: '',
                                tasksCount: 0,
                                color: CupertinoColors.systemRed,
                                icon: CupertinoIcons.list_bullet,
                              ),
                            ),
                            child: const Text("Add List"),
                          ),
                        )
                      ],
                    ),
                    children: myLists.map((genre) {
                      return CupertinoListTile(
                        backgroundColor: CupertinoColors.white,
                        title: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Text(genre.title),
                        ),
                        additionalInfo: Text(genre.tasksCount.toString()),
                        leading: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: genre.color,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Icon(
                              genre.icon,
                              color: CupertinoColors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        onTap: () => _navigateToTaskList(context, genre),
                        trailing: const CupertinoListTileChevron(),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AddTaskButton(
                  onPressed: () => _navigateToTaskAddPage(context)),
            ),
          ],
        ),
      ),
    );
  }
}
