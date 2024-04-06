import 'package:clear_tasks/models/genre.dart';
import 'package:isar/isar.dart';
import '../models/task.dart'; // Genreモデルへのパスを適切に設定

class TaskRepository {
  final Isar _isar;

  TaskRepository(this._isar);

  Future<List<Task>> getAllTasks() async {
    final tasks = await _isar.tasks.where().findAll();
    return tasks;
  }

  Future<List<Task>> getIncompleteTasks() async {
    final tasks =
        await _isar.tasks.filter().isCompletedEqualTo(false).findAll();
    return tasks;
  }

  Future<List<Task>> getIncompleteTasksByGenreId(int genreId) async {
    final tasks = await _isar.tasks
        .filter()
        .genreIdEqualTo(genreId)
        .isCompletedEqualTo(false)
        .findAll();
    return tasks;
  }

  Future<List<Task>> getDefaultListTasks(Genre genre) async {
    if (genre.title == "Today") {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);

      // 明日の日付の開始時間を取得（今日の日付 + 1日）
      final tomorrow = startOfDay.add(const Duration(days: 1));

      final tasks = await _isar.tasks
          .filter()
          .isCompletedEqualTo(false)
          .dateBetween(startOfDay, tomorrow) // 今日の開始から明日の開始までの間
          .findAll();

      return tasks;
    } else if (genre.title == "Scheduled") {
      final tasks = await _isar.tasks
          .filter()
          .dateIsNotNull()
          .isCompletedEqualTo(false)
          .findAll();
      return tasks;
    } else if (genre.title == "Star") {
      final tasks = await _isar.tasks
          .filter()
          .starEqualTo(true)
          .isCompletedEqualTo(false)
          .findAll();
      return tasks;
    } else if (genre.title == "Completed") {
      final tasks =
          await _isar.tasks.filter().isCompletedEqualTo(true).findAll();
      return tasks;
    } else {
      final tasks =
          await _isar.tasks.filter().isCompletedEqualTo(false).findAll();
      return tasks;
    }
  }

  Future<void> addTask(Task task) async {
    await _isar.writeTxn(() async {
      await _isar.tasks.put(task);
    });
  }

  Future<void> removeTask(Task task) async {
    await _isar.writeTxn(() async {
      await _isar.tasks.delete(task.id);
    });
  }
}
