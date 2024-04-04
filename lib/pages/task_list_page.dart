import 'package:clear_tasks/models/genre.dart';
import 'package:clear_tasks/models/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';

import 'edit_list_page.dart';
import 'edit_task_page.dart';
import '../repositories/genre_repository.dart';
import '../repositories/task_repository.dart';
import '../widgets/add_task_button.dart';
import './add_task_page.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({
    super.key,
    required this.genre,
    required this.myLists,
    required this.genreRepository,
    required this.taskRepository,
  });

  final Genre genre;
  final List<Genre> myLists;
  final GenreRepository genreRepository;
  final TaskRepository taskRepository;

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  List<Task> tasks = [
    Task(
        title: "",
        notes: "",
        star: true,
        genreId: 0,
        isCompleted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now())
  ];
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
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final loadedTasks = await widget.taskRepository
        .getIncompleteTasksByGenreId(_selectedGenre.id);
    setState(() {
      tasks = loadedTasks;
    });
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
      child: SafeArea(
        child: Stack(
          children: [
            ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Container(
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black12)),
                  ),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      _navigateToEditTask(context, task);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CupertinoButton(
                            onPressed: () {
                              setState(() {
                                task.isCompleted = !task.isCompleted;
                              });
                            },
                            padding: EdgeInsets.zero,
                            child: Container(
                              width: 30,
                              height: 30,
                              child: task.isCompleted
                                  ? const Icon(
                                      CupertinoIcons.circle_fill,
                                      color: CupertinoColors.activeBlue,
                                    )
                                  : const Icon(CupertinoIcons.circle,
                                      color: CupertinoColors.systemGrey4),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  task.title,
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: task.isCompleted
                                          ? CupertinoColors.systemGrey
                                          : Colors.black),
                                ),
                                // if (task.notes.isNotEmpty)
                                //   const SizedBox(height: 5.0),
                                if (task.notes.isNotEmpty)
                                  Text(
                                    task.notes,
                                    style: const TextStyle(
                                        color: CupertinoColors.systemGrey),
                                  ),
                                Row(
                                  children: [
                                    if (task.date != null)
                                      Text(
                                        "${task.date?.year}/${task.date?.month}/${task.date?.day}",
                                        style: const TextStyle(
                                            color: CupertinoColors.systemGrey),
                                      ),
                                    const SizedBox(width: 5.0),
                                    if (task.time != null)
                                      Text(
                                        "${task.time?.hour}:${task.time?.minute}",
                                        style: const TextStyle(
                                            color: CupertinoColors.systemGrey),
                                      ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Icon(
                              task.star ? CupertinoIcons.star_fill : null,
                              color: CupertinoColors.systemYellow,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
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

  void _navigateToTaskAddPage(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => AddTaskPage(
            selectedMyList: _selectedGenre,
            genreRepository: widget.genreRepository,
            taskRepository: widget.taskRepository),
      ),
    ).then((value) => _loadTasks());
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

  void _navigateToEditTask(BuildContext context, Task task) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => EditTaskPage(
          task: task,
          genreRepository: widget.genreRepository,
          taskRepository: widget.taskRepository,
        ),
      ),
    ).then((value) => _loadTasks());
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
