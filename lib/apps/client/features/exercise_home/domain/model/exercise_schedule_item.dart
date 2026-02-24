import 'package:flutter/foundation.dart';
import 'package:model/model.dart';

import 'exercise.dart';

@immutable
class ExerciseScheduleItem {
  const ExerciseScheduleItem({
    required this.scheduleId,
    required this.exerciseId,
    required this.exerciseName,
    this.exerciseDescription,
    this.exerciseImageUrl,
    this.exerciseVideoUrl,
    this.exerciseType,
    required this.sets,
    this.daysOfWeek,
    this.startDate,
    this.endDate,
    this.createdById,
    this.notes,
  });

  final String scheduleId;
  final String exerciseId;
  final String exerciseName;
  final String? exerciseDescription;
  final String? exerciseImageUrl;
  final String? exerciseVideoUrl;
  final String? exerciseType;
  final List<ExerciseSetData> sets;
  final String? daysOfWeek;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? createdById;
  final String? notes;

  int get totalSets => sets.length;
  int get completedSets => sets.where((s) => s.isCompleted).length;
  bool get isCompleted => sets.isNotEmpty && completedSets == totalSets;
  int get repsPerSet => sets.isNotEmpty ? (sets.first.repetitions ?? 0) : 0;

  /// Converts DB exercise type (cardio/strength/reps) to client MetricType.
  MetricType get metricType => switch (exerciseType) {
        'cardio' => MetricType.distance,
        'strength' => MetricType.weight,
        'reps' => MetricType.reps,
        _ => MetricType.weight,
      };

  /// Converts this schedule item to a client [Exercise] for navigation.
  Exercise toExercise() {
    return Exercise(
      id: exerciseId,
      title: exerciseName,
      description: exerciseDescription ?? '',
      imageUrl: exerciseImageUrl,
      videoUrl: exerciseVideoUrl,
      muscleMain: const Muscle(
        id: '',
        name: '',
        isMain: true,
        muscleGroup: MuscleGroup.chest,
      ),
      muscleSecundaries: const [],
      instruccion: '',
      currentValue: completedSets.toDouble(),
      targetValue: totalSets.toDouble(),
      metricType: metricType,
      status: isCompleted
          ? ExerciseStatus.completed
          : completedSets > 0
              ? ExerciseStatus.inProgress
              : ExerciseStatus.pending,
    );
  }

  factory ExerciseScheduleItem.fromJson(Map<String, dynamic> json) {
    final exercise = json['exercise'] as Map<String, dynamic>?;
    final setsData = json['exercise_set'] as List<dynamic>? ?? [];

    return ExerciseScheduleItem(
      scheduleId: json['id'] as String,
      exerciseId: json['id_exercise'] as String,
      exerciseName: exercise?['name'] as String? ?? 'Ejercicio',
      exerciseDescription: exercise?['description'] as String?,
      exerciseImageUrl: exercise?['url_img_exercise'] as String?,
      exerciseVideoUrl: exercise?['url_video_exercise'] as String?,
      exerciseType: exercise?['type_exercise'] as String?,
      sets: setsData
          .map((s) => ExerciseSetData.fromJson(s as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => a.setNumber.compareTo(b.setNumber)),
      daysOfWeek: json['days_of_week'] as String?,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'] as String)
          : null,
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'] as String)
          : null,
      createdById: json['id_created_by'] as String?,
      notes: json['notes'] as String?,
    );
  }
}

@immutable
class ExerciseSetData {
  const ExerciseSetData({
    required this.id,
    required this.setNumber,
    this.repetitions,
    this.weight,
    this.minutes,
    this.seconds,
    this.distance,
    required this.isCompleted,
    this.completedAt,
  });

  final String id;
  final int setNumber;
  final int? repetitions;
  final double? weight;
  final int? minutes;
  final int? seconds;
  final double? distance;
  final bool isCompleted;
  final DateTime? completedAt;

  factory ExerciseSetData.fromJson(Map<String, dynamic> json) {
    return ExerciseSetData(
      id: json['id'] as String,
      setNumber: (json['set_number'] as num).toInt(),
      repetitions: (json['repetitions'] as num?)?.toInt(),
      weight: (json['weight'] as num?)?.toDouble(),
      minutes: (json['minutes'] as num?)?.toInt(),
      seconds: (json['seconds'] as num?)?.toInt(),
      distance: (json['distance'] as num?)?.toDouble(),
      isCompleted: json['is_completed'] as bool? ?? false,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
    );
  }
}
