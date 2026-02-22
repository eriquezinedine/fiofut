part of 'all_muscles_repose_provider.dart';

class AllMusclesReposeState {
  const AllMusclesReposeState({required this.muscles});

  factory AllMusclesReposeState.fromList(List<MuscleRepose> list) {
    final map = <MuscleGroup, MuscleRepose>{};
    for (final mr in list) {
      map[mr.muscle.muscleGroup] = mr;
    }
    return AllMusclesReposeState(muscles: map);
  }

  final Map<MuscleGroup, MuscleRepose> muscles;

  /// Returns percentage for a [group], or `null` if not tracked.
  int? percentageFor(MuscleGroup group) => muscles[group]?.percentage;

  /// All tracked muscles as a list.
  List<MuscleRepose> get asList => muscles.values.toList();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AllMusclesReposeState) return false;
    if (muscles.length != other.muscles.length) return false;
    for (final entry in muscles.entries) {
      if (other.muscles[entry.key] != entry.value) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(muscles.entries);
}
