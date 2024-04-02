import 'package:isar/isar.dart';
import '../models/genre.dart'; // Genreモデルへのパスを適切に設定

class GenreRepository {
  final Isar _isar;

  GenreRepository(this._isar);

  Future<List<Genre>> getAllGenres() async {
    final genres = await _isar.genres.where().findAll();
    return genres;
  }

  Future<void> addGenre(Genre genre) async {
    await _isar.writeTxn(() async {
      await _isar.genres.put(genre);
    });
  }

  Future<void> removeGenre(Genre genre) async {
    await _isar.writeTxn(() async {
      await _isar.genres.delete(genre.id);
    });
  }
}
