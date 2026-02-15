import 'package:isar/isar.dart';

part 'cached_ingredient.g.dart';

@collection
class CachedIngredient {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String ingredientId;

  @Index()
  late String name;

  @Index()
  String? category;
}
