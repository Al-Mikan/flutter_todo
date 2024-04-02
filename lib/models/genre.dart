import 'package:isar/isar.dart';

part 'genre.g.dart';

@Collection()
class Genre {
  Id id = Isar.autoIncrement;
  late String title;
  late int color;
  late int icon;
  late bool defaultGenre;
  late DateTime createdAt;
  late DateTime updatedAt;

  Genre({
    this.id = 0, // IsarはautoIncrementなIDを扱うので、デフォルト値は通常必要ありませんが、初期化のために0を設定します
    required this.title,
    required this.color,
    required this.icon,
    required this.defaultGenre,
    required this.createdAt,
    required this.updatedAt,
  });
}
