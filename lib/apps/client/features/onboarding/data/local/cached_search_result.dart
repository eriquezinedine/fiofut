import 'package:isar/isar.dart';

part 'cached_search_result.g.dart';

@collection
class CachedSearchResult {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, composite: [CompositeIndex('category')])
  late String query;

  late String category;

  late List<String> ingredientNames;

  late List<String> ingredientIds;

  late DateTime cachedAt;
}
