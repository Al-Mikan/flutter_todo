import 'package:isar/isar.dart';
import '../models/task.dart'; // Genreモデルへのパスを適切に設定

class GenreRepository {
  final Isar _isar;

  GenreRepository(this._isar);

  Future<List<Task>> getAllTasks() async {
    final genres = await _isar.tasks.where().findAll();
    return genres;
  }
}
