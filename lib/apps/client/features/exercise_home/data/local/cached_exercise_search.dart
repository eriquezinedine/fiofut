import 'package:isar/isar.dart';

part 'cached_exercise_search.g.dart';

@collection
class CachedExerciseSearch {
  Id isarId = Isar.autoIncrement;

  /// Composite unique index: (searchQuery, muscleFilter) → O(1) lookup.
  @Index(unique: true, replace: true, composite: [CompositeIndex('muscleFilter')])
  late String searchQuery;

  /// Muscle group filter key ('all' = no filter).
  late String muscleFilter;

  /// Ordered exercise IDs for this search result.
  late List<String> exerciseIds;

  /// Total count in backend (for pagination).
  late int totalCount;

  late DateTime cachedAt;
}
