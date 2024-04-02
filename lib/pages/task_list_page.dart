import 'package:clear_tasks/models/genre.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_down_button/pull_down_button.dart';

import 'edit_list_page.dart';
import '../repositories/genre_repository.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage(
      {super.key, required this.genre, required this.genreRepository});

  final Genre genre;
  final GenreRepository genreRepository;

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  Genre _selectedGenre = Genre(
      title: "",
      color: 0,
      icon: 0,
      defaultGenre: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now());

  @override
  void initState() {
    super.initState();
    _selectedGenre = widget.genre;
    // 初期化時に何か処理をする場合はここに記述
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      navigationBar: CupertinoNavigationBar(
        middle: Text(_selectedGenre.title),
        trailing: _selectedGenre.defaultGenre
            ? null
            : PullDownButton(
                itemBuilder: (context) => [
                  PullDownMenuItem(
                    title: 'Show List Info',
                    icon: CupertinoIcons.info,
                    onTap: () => _navigateToEditList(context, _selectedGenre),
                  ),
                  PullDownMenuItem(
                    title: 'Delete List',
                    isDestructive: true,
                    icon: CupertinoIcons.delete,
                    onTap: () {
                      _showDialog();
                    },
                  ),
                ],
                buttonBuilder: (context, showMenu) => CupertinoButton(
                  onPressed: showMenu,
                  padding: EdgeInsets.zero,
                  child: const Icon(CupertinoIcons.ellipsis_circle),
                ),
              ),
        border: null,
        backgroundColor: CupertinoColors.white,
      ),
      child: const Center(
        child: Text('Task List'),
      ),
    );
  }

  void _navigateToEditList(BuildContext context, Genre genre) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => EditListPage(
          genre: genre,
          genreRepository: widget.genreRepository,
        ),
      ),
    ).then((value) => setState(() {
          _selectedGenre = value;
        }));
  }

  void _showDialog() {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('Delete List ”${widget.genre.title}”?'),
            content: const Text('This will delete all tasks in this lists.'),
            actions: [
              CupertinoDialogAction(
                child: const Text('Cancel'),
                onPressed: () => {Navigator.pop(context)},
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () async {
                  await widget.genreRepository.removeGenre(widget.genre);
                  if (!mounted) return;
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
                child: const Text('Delete'),
              ),
            ],
          );
        });
  }
}
