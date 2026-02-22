part of 'muscle_group_provider.dart';

@immutable
class MuscleGroupState {
  const MuscleGroupState({
    this.selectedMuscles = const {},
    this.muscleColors = const {},
  });

  final Set<MuscleGroup> selectedMuscles;
  final Map<MuscleGroup, Color> muscleColors;

  Color colorFor(MuscleGroup muscle) {
    return muscleColors[muscle] ?? muscle.defaultColor;
  }

  bool isSelected(MuscleGroup muscle) {
    return selectedMuscles.contains(muscle);
  }

  MuscleGroupState copyWith({
    Set<MuscleGroup>? selectedMuscles,
    Map<MuscleGroup, Color>? muscleColors,
  }) {
    return MuscleGroupState(
      selectedMuscles: selectedMuscles ?? this.selectedMuscles,
      muscleColors: muscleColors ?? this.muscleColors,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MuscleGroupState) return false;
    return _setEquals(selectedMuscles, other.selectedMuscles) &&
        _mapEquals(muscleColors, other.muscleColors);
  }

  @override
  int get hashCode => Object.hash(
        Object.hashAllUnordered(selectedMuscles),
        Object.hashAllUnordered(muscleColors.entries),
      );

  static bool _setEquals<T>(Set<T> a, Set<T> b) {
    if (a.length != b.length) return false;
    return a.containsAll(b);
  }

  static bool _mapEquals<K, V>(Map<K, V> a, Map<K, V> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (a[key] != b[key]) return false;
    }
    return true;
  }
}
