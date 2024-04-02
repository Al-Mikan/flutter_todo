import 'package:clear_tasks/models/genre.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_down_button/pull_down_button.dart';

import 'edit_list_page.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage(
      {super.key, required this.genre, required this.removeGenre});

  final Genre genre;
  final void Function(Genre) removeGenre;

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.genre.title), // 選択されたジャンル名を表示
        trailing: widget.genre.defaultGenre
            ? null
            : PullDownButton(
                itemBuilder: (context) => [
                  PullDownMenuItem(
                    title: 'Show List Info',
                    icon: CupertinoIcons.info,
                    onTap: () => _navigateToEditList(context, widget.genre),
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
        ),
      ),
    );
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
                onPressed: () => Navigator.pop(context),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () {
                  widget.removeGenre(widget.genre);
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
                child: const Text('Delete'),
              ),
            ],
          );
        });
  }
}
