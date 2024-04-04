import 'package:clear_tasks/widgets/add_task_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'pages/edit_list_page.dart';
import 'models/genre.dart';
import 'models/task.dart';
import 'pages/task_list_page.dart';
import 'pages/add_task_page.dart';
// import 'dummy_data.dart';

import 'utils/icon_utils.dart';
import 'repositories/genre_repository.dart';
import 'repositories/task_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [GenreSchema, TaskSchema],
    directory: dir.path,
  );

  // GenreRepositoryのインスタンスを作成
  final genreRepository = GenreRepository(isar);
  final taskRepository = TaskRepository(isar);

  runApp(
      MyApp(genreRepository: genreRepository, taskRepository: taskRepository));
}

class MyApp extends StatelessWidget {
  final GenreRepository genreRepository;
  final TaskRepository taskRepository;

  const MyApp(
      {super.key, required this.genreRepository, required this.taskRepository});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: MyHomePage(
          genreRepository: genreRepository, taskRepository: taskRepository),
      theme: const CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: CupertinoColors.systemBlue,
      ),
    );
  }
}

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
        defaultGenre: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()),
    Genre(
        title: 'Scheduled',
        color: CupertinoColors.systemBlue.value,
        icon: CupertinoIcons.paperclip.codePoint,
        defaultGenre: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()),
    Genre(
        title: 'All',
        color: CupertinoColors.black.value,
        icon: CupertinoIcons.tray_fill.codePoint,
        defaultGenre: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()),
    Genre(
        title: 'Star',
        color: CupertinoColors.systemYellow.value,
        icon: CupertinoIcons.star_fill.codePoint,
        defaultGenre: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()),
    Genre(
        title: 'Completed',
        color: CupertinoColors.systemGrey.value,
        icon: CupertinoIcons.check_mark.codePoint,
        defaultGenre: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()),
  ];
  List<Genre> myLists = [];

  Future<void> _loadLists() async {
    final loadedLists = await widget.genreRepository.getAllGenres();
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
            myLists: myLists,
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
                            : const Text("ndjs"),
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
                        additionalInfo: const Text("dsnaj"),
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
