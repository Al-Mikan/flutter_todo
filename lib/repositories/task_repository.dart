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
