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
    this.typeExercise,
    required this.sets,
    this.daysOfWeek,
    this.startDate,
    this.endDate,
    this.createdById,
    this.notes,
    this.muscleId,
    this.muscleName,
    this.muscleGroup,
  });

  final String scheduleId;
  final String exerciseId;
  final String exerciseName;
  final String? exerciseDescription;
  final String? exerciseImageUrl;
  final String? exerciseVideoUrl;
  final MetricType? typeExercise;
  final List<ExerciseSetData> sets;
  final String? daysOfWeek;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? createdById;
  final String? notes;
  final String? muscleId;
  final String? muscleName;
  final String? muscleGroup;

  int get totalSets => sets.length;
  int get completedSets => sets.where((s) => s.isCompleted).length;
  bool get isCompleted => sets.isNotEmpty && completedSets == totalSets;
  int get repsPerSet => sets.isNotEmpty ? (sets.first.repetitions ?? 0) : 0;

  MetricType get metricType => typeExercise ?? MetricType.strength;

  static MetricType? _parseMetricType(String? type) => switch (type) {
    'cardio' => MetricType.cardio,
    'strength' => MetricType.strength,
    'reps' => MetricType.reps,
    _ => null,
  };

  /// Parses a muscle_group string to [MuscleGroup] enum.
  static MuscleGroup _parseMuscleGroup(String? group) {
    if (group == null) return MuscleGroup.chest;
    return MuscleGroup.fromJson(group);
  }

  /// Converts this schedule item to a client [Exercise] for navigation.
  Exercise toExercise() {
    return Exercise(
      id: exerciseId,
      title: exerciseName,
      description: exerciseDescription ?? '',
      imageUrl: exerciseImageUrl,
      videoUrl: exerciseVideoUrl,
      muscleMain: Muscle(
        id: muscleId ?? '',
        name: muscleName ?? '',
        isMain: true,
        muscleGroup: _parseMuscleGroup(muscleGroup),
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

  ExerciseScheduleItem copyWith({
    String? scheduleId,
    String? exerciseId,
    String? exerciseName,
    String? exerciseDescription,
    String? exerciseImageUrl,
    String? exerciseVideoUrl,
    MetricType? typeExercise,
    List<ExerciseSetData>? sets,
    String? daysOfWeek,
    DateTime? startDate,
    DateTime? endDate,
    String? createdById,
    String? notes,
    String? muscleId,
    String? muscleName,
    String? muscleGroup,
  }) {
    return ExerciseScheduleItem(
      scheduleId: scheduleId ?? this.scheduleId,
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      exerciseDescription: exerciseDescription ?? this.exerciseDescription,
      exerciseImageUrl: exerciseImageUrl ?? this.exerciseImageUrl,
      exerciseVideoUrl: exerciseVideoUrl ?? this.exerciseVideoUrl,
      typeExercise: typeExercise ?? this.typeExercise,
      sets: sets ?? this.sets,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdById: createdById ?? this.createdById,
      notes: notes ?? this.notes,
      muscleId: muscleId ?? this.muscleId,
      muscleName: muscleName ?? this.muscleName,
      muscleGroup: muscleGroup ?? this.muscleGroup,
    );
  }

  factory ExerciseScheduleItem.fromJson(Map<String, dynamic> json) {
    final exercise = json['exercise'] as Map<String, dynamic>?;
    final setsData = json['exercise_set'] as List<dynamic>? ?? [];
    final muscle = exercise?['muscle'] as Map<String, dynamic>?;

    return ExerciseScheduleItem(
      scheduleId: json['id'] as String,
      exerciseId: json['id_exercise'] as String,
      exerciseName: exercise?['name'] as String? ?? 'Ejercicio',
      exerciseDescription: exercise?['description'] as String?,
      exerciseImageUrl: exercise?['url_img_exercise'] as String?,
      exerciseVideoUrl: exercise?['url_video_exercise'] as String?,
      typeExercise: _parseMetricType(exercise?['type_exercise'] as String?),
      sets:
          setsData
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
      muscleId: muscle?['id'] as String?,
      muscleName: muscle?['name'] as String?,
      muscleGroup: muscle?['muscle_group'] as String?,
    );
  }
}

enum SerieStatus { pending, completed }

enum SetType {
  normal,
  warmup,
  dropset;

  static SetType fromString(String? value) => switch (value) {
    'warmup' => SetType.warmup,
    'dropset' => SetType.dropset,
    _ => SetType.normal,
  };
}

@immutable
class ExerciseSetData {
  const ExerciseSetData({
    required this.id,
    required this.setNumber,
    required this.sessionDate,
    this.repetitions,
    this.weight,
    this.minutes,
    this.seconds,
    this.distance,
    this.status = SerieStatus.pending,
    this.completedAt,
    this.setType = SetType.normal,
  });

  final String id;
  final int setNumber;
  final DateTime sessionDate;
  final int? repetitions;
  final double? weight;
  final int? minutes;
  final int? seconds;
  final double? distance;
  final SerieStatus status;
  final DateTime? completedAt;
  final SetType setType;

  bool get isCompleted => status == SerieStatus.completed;

  bool canComplete(MetricType type) {
    return switch (type) {
      MetricType.strength =>
        (repetitions != null && repetitions! > 0) && weight != null,
      MetricType.cardio =>
        (minutes != null || seconds != null) &&
            ((minutes ?? 0) > 0 || (seconds ?? 0) > 0) &&
            weight != null,
      MetricType.reps => repetitions != null && repetitions! > 0,
    };
  }

  ExerciseSetData copyWith({
    String? id,
    int? setNumber,
    DateTime? sessionDate,
    int? repetitions,
    double? weight,
    int? minutes,
    int? seconds,
    double? distance,
    SerieStatus? status,
    DateTime? completedAt,
    SetType? setType,
  }) {
    return ExerciseSetData(
      id: id ?? this.id,
      setNumber: setNumber ?? this.setNumber,
      sessionDate: sessionDate ?? this.sessionDate,
      repetitions: repetitions ?? this.repetitions,
      weight: weight ?? this.weight,
      minutes: minutes ?? this.minutes,
      seconds: seconds ?? this.seconds,
      distance: distance ?? this.distance,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
      setType: setType ?? this.setType,
    );
  }

  factory ExerciseSetData.fromJson(Map<String, dynamic> json) {
    return ExerciseSetData(
      id: json['id'] as String,
      setNumber: (json['set_number'] as num).toInt(),
      sessionDate: json['session_date'] != null
          ? DateTime.parse(json['session_date'] as String)
          : DateTime.now(),
      repetitions: (json['repetitions'] as num?)?.toInt(),
      weight: (json['weight'] as num?)?.toDouble(),
      minutes: (json['minutes'] as num?)?.toInt(),
      seconds: (json['seconds'] as num?)?.toInt(),
      distance: (json['distance'] as num?)?.toDouble(),
      status: (json['is_completed'] as bool? ?? false)
          ? SerieStatus.completed
          : SerieStatus.pending,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      setType: SetType.fromString(json['set_type'] as String?),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseSetData &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          setNumber == other.setNumber &&
          repetitions == other.repetitions &&
          weight == other.weight &&
          minutes == other.minutes &&
          seconds == other.seconds &&
          status == other.status &&
          setType == other.setType;

  @override
  int get hashCode => Object.hash(
    id,
    setNumber,
    repetitions,
    weight,
    minutes,
    seconds,
    status,
    setType,
  );

  @override
  String toString() =>
      'ExerciseSetData(id: $id, #$setNumber, reps: $repetitions, weight: $weight, mins: $minutes, secs: $seconds, status: $status, setType: $setType)';
}
