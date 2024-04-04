import 'package:isar/isar.dart';
import 'genre.dart';

part 'task.g.dart';

@Collection()
class Task {
  Id id = Isar.autoIncrement;
  late String title;
  late String notes;
  DateTime? date;
  DateTime? time;
  late bool star;
  late int genreId;
  late bool isCompleted;
  late DateTime createdAt;
  late DateTime updatedAt;

  Task({
    this.id = Isar
        .autoIncrement, // IsarはautoIncrementなIDを扱うので、デフォルト値は通常必要ありませんが、初期化のために0を設定します
    required this.title,
    required this.notes,
    this.date,
    this.time,
    required this.star,
    required this.genreId,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
  });
}
