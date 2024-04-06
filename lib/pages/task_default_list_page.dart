import 'package:clear_tasks/models/genre.dart';
import 'package:clear_tasks/models/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'edit_task_page.dart';
import '../repositories/genre_repository.dart';
import '../repositories/task_repository.dart';

class TaskDefaultListPage extends StatefulWidget {
  const TaskDefaultListPage({
    super.key,
    required this.selectedGenre,
    required this.myLists,
    required this.genreRepository,
    required this.taskRepository,
  });

  final Genre selectedGenre;
  final List<Genre> myLists;
  final GenreRepository genreRepository;
  final TaskRepository taskRepository;

  @override
  State<TaskDefaultListPage> createState() => _TaskDefaultListPageState();
}

class _TaskDefaultListPageState extends State<TaskDefaultListPage> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final loadedTasks =
        await widget.taskRepository.getDefaultListTasks(widget.selectedGenre);
    setState(() {
      tasks = loadedTasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.selectedGenre.title),
        border: null,
        backgroundColor: CupertinoColors.white,
        trailing: widget.selectedGenre.title == "Completed"
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Text("Clear"),
                onPressed: () {
                  print("clear task");
                },
              )
            : null,
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
                            onPressed: () async {
                              setState(() {
                                task.isCompleted = !task.isCompleted;
                              });
                              await widget.taskRepository.addTask(task);
                            },
                            padding: EdgeInsets.zero,
                            child: SizedBox(
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
                                if (task.notes.isNotEmpty)
                                  Text(
                                    task.notes,
                                    style: const TextStyle(
                                        color: CupertinoColors.systemGrey),
                                  ),
                                Row(
                                  children: [
                                    if (task.date != null)
                                      _buildDateTimeText(task.date, task.time),
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
          ],
        ),
      ),
    );
  }

  DateTime _getTaskDateTime(DateTime date, DateTime? time) {
    final year = date.year;
    final month = date.month;
    final day = date.day;
    final hour = time?.hour ?? 23;
    final minute = time?.minute ?? 59;

    return DateTime(year, month, day, hour, minute);
  }

  bool _isPast(DateTime taskDateTime) {
    return taskDateTime.isBefore(DateTime.now());
  }

  Widget _buildDateTimeText(DateTime? date, DateTime? time) {
    if (date == null) {
      return const SizedBox.shrink();
    }
    final taskDateTime = _getTaskDateTime(date, time);
    final isPast = _isPast(taskDateTime);
    final textStyle = TextStyle(
      color: isPast ? CupertinoColors.systemRed : CupertinoColors.systemGrey,
    );

    return Row(
      children: [
        Text(
          DateFormat('yyyy/MM/dd').format(taskDateTime),
          style: textStyle,
        ),
        if (time != null) const SizedBox(width: 5.0),
        if (time != null)
          Text(
            DateFormat('HH:mm').format(taskDateTime),
            style: textStyle,
          ),
      ],
    );
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
}
