import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'models/genre.dart';
import 'models/task.dart';

import 'pages/sign_in_page.dart';
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
      home: SignInPage(
          genreRepository: genreRepository, taskRepository: taskRepository),
      theme: const CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: CupertinoColors.systemBlue,
      ),
    );
  }
}
