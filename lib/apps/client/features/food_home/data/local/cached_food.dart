import 'package:isar/isar.dart';

part 'cached_food.g.dart';

@collection
class CachedFood {
  Id isarId = Isar.autoIncrement;

  @Index()
  late String dateKey; // "2026-02-14"

  late String foodId;
  late String scheduleId;
  late String name;
  late String description;
  late int calories;
  late int protein;
  late int carbs;
  late int fat;
  late String imageUrl;
  late bool isCompleted;
  late String typeFood;
  String? time;
}
