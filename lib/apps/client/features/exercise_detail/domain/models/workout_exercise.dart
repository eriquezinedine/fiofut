import 'package:fio_fut/apps/client/features/exercise_home/domain/model/model.dart';

class WorkoutExercise {
  const WorkoutExercise({
    required this.id,
    required this.exercise,
    required this.repiteType,
    required this.scheduledDate,
    this.series = const [],
    this.scheduleId,
  });

  final String id;
  final Exercise exercise;
  final MetricType repiteType;
  final DateTime scheduledDate;
  final List<ExerciseSetData> series;

  /// ID referencing the schedule in Supabase
  final String? scheduleId;

  /// All series must be completed for the exercise to be completed
  bool get allSeriesCompleted =>
      series.isNotEmpty && series.every((s) => s.isCompleted);

  int get completedSeriesCount =>
      series.where((s) => s.isCompleted).length;

  double get progress =>
      series.isEmpty ? 0.0 : completedSeriesCount / series.length;

  WorkoutExercise copyWith({
    String? id,
    Exercise? exercise,
    MetricType? repiteType,
    DateTime? scheduledDate,
    List<ExerciseSetData>? series,
    String? scheduleId,
  }) {
    return WorkoutExercise(
      id: id ?? this.id,
      exercise: exercise ?? this.exercise,
      repiteType: repiteType ?? this.repiteType,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      series: series ?? this.series,
      scheduleId: scheduleId ?? this.scheduleId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutExercise &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          scheduledDate == other.scheduledDate;

  @override
  int get hashCode => Object.hash(id, scheduledDate);

  @override
  String toString() =>
      'WorkoutExercise(id: $id, exercise: ${exercise.title}, date: $scheduledDate, series: ${series.length})';
}
