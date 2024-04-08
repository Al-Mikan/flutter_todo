import 'package:clear_tasks/utils/icon_utils.dart';
import 'package:flutter/cupertino.dart';

import '../models/genre.dart';
import '../repositories/genre_repository.dart';
import '../repositories/task_repository.dart';
import '../widgets/add_task_button.dart';
import 'add_task_page.dart';
import 'edit_list_page.dart';
import 'task_default_list_page.dart';
import 'task_list_page.dart';

class MyHomePage extends StatefulWidget {
  final GenreRepository genreRepository;
  final TaskRepository taskRepository;

  const MyHomePage(
      {super.key, required this.genreRepository, required this.taskRepository});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _loadLists();
  }

  List<Genre> genres = [
    Genre(
        title: 'Today',
        color: CupertinoColors.systemRed.value,
        icon: CupertinoIcons.calendar_today.codePoint,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()),
    Genre(
        title: 'Scheduled',
        color: CupertinoColors.systemBlue.value,
        icon: CupertinoIcons.paperclip.codePoint,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()),
    Genre(
        title: 'All',
        color: CupertinoColors.black.value,
        icon: CupertinoIcons.tray_fill.codePoint,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()),
    Genre(
        title: 'Star',
        color: CupertinoColors.systemYellow.value,
        icon: CupertinoIcons.star_fill.codePoint,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()),
    Genre(
        title: 'Completed',
        color: CupertinoColors.systemGrey.value,
        icon: CupertinoIcons.check_mark.codePoint,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()),
  ];
  List<Genre> myLists = [];
  Map taskCount = {};
  Map defaulTaskCount = {};

  Future<void> _loadLists() async {
    final loadedLists = await widget.genreRepository.getAllGenres();
    for (var genre in loadedLists) {
      final tasks =
          await widget.taskRepository.getIncompleteTasksByGenreId(genre.id);
      setState(() {
        taskCount[genre.id] = tasks.length;
      });
    }
    for (var genre in genres) {
      final tasks = await widget.taskRepository.getDefaultListTasks(genre);
      setState(() {
        defaulTaskCount[genre] = tasks.length;
      });
    }
    setState(() {
      myLists = loadedLists;
    });
  }

  void _navigateToTaskList(BuildContext context, Genre genre) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => TaskListPage(
          genre: genre,
          isDefaultGenre: false,
          myLists: myLists,
          genreRepository: widget.genreRepository,
          taskRepository: widget.taskRepository,
        ),
      ),
    ).then((value) {
      _loadLists();
    });
  }

  void _navigateToDefalutTaskList(BuildContext context, Genre genre) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => TaskDefaultListPage(
          selectedGenre: genre,
          myLists: myLists,
          genreRepository: widget.genreRepository,
          taskRepository: widget.taskRepository,
        ),
      ),
    ).then((value) {
      _loadLists();
    });
  }

  void _navigateToEditList(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => EditListPage(
          genre: null,
          genreRepository: widget.genreRepository,
        ),
      ),
    ).then((value) {
      _loadLists();
    });
  }

  void _navigateToTaskAddPage(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => AddTaskPage(
            selectedMyList: myLists[0],
            genreRepository: widget.genreRepository,
            taskRepository: widget.taskRepository),
      ),
    ).then((value) {
      _loadLists();
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
                    header: const Text('Genre'),
                    children: genres.map((genre) {
                      return CupertinoListTile(
                        backgroundColor: CupertinoColors.white,
                        title: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Text(genre.title),
                        ),
                        additionalInfo: genre.title == "Completed"
                            ? null
                            : Text(defaulTaskCount[genre.title]?.toString() ??
                                '0'),
                        leading: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: Color(genre.color),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Icon(
                              IconUtils.getIconFromCodePoint(genre.icon),
                              color: CupertinoColors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        onTap: () => _navigateToDefalutTaskList(context, genre),
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
                        additionalInfo: Text('${taskCount[genre.id] ?? 0}'),
                        leading: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: Color(genre.color),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Icon(
                              IconUtils.getIconFromCodePoint(genre.icon),
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
