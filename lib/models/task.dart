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
  final list = IsarLink<Genre>();
  late bool star;
  late bool isCompleted;
  late DateTime createdAt;
  late DateTime updatedAt;
}
