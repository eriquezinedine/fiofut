import 'package:isar/isar.dart';

part 'cached_exercise.g.dart';

@collection
class CachedExercise {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String exerciseId;

  @Index()
  late String name;

  String? description;
  String? imageUrl;
  String? videoUrl;
  String? primaryMuscleId;

  /// Muscle group string for local filtering (e.g. 'chest', 'biceps').
  late String muscleGroup;

  /// Exercise type: 'cardio', 'strength', 'reps'.
  late String exerciseType;

  late DateTime cachedAt;
}
