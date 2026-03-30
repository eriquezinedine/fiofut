import 'package:flutter/foundation.dart';

import 'package:fio_fut/apps/admin/features/exercises/domain/models/exercise.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise_schedule_item.dart';

@immutable
class FolderExerciseItem {
  const FolderExerciseItem({
    required this.id,
    required this.exercise,
    required this.sets,
    required this.reps,
    this.weight,
    this.minutes,
    this.seconds,
    this.configSets = const [],
    this.sortOrder = 0,
  });

  final String id; // trainer_folder_exercise.id
  final Exercise exercise;
  final int sets;
  final int reps;
  final double? weight;
  final int? minutes;
  final int? seconds;
  final List<ExerciseSetData> configSets;
  final int sortOrder;

  factory FolderExerciseItem.fromJson(Map<String, dynamic> json) {
    final configSetsJson = json['config_sets'] as List<dynamic>?;
    final configSets = configSetsJson?.map((s) {
      final map = s as Map<String, dynamic>;
      return ExerciseSetData(
        id: map['id'] as String,
        setNumber: (map['set_number'] as num).toInt(),
        sessionDate: DateTime.now(),
        repetitions: (map['reps'] as num?)?.toInt(),
        weight: (map['weight'] as num?)?.toDouble(),
        minutes: (map['minutes'] as num?)?.toInt(),
        seconds: (map['seconds'] as num?)?.toInt(),
      );
    }).toList() ?? [];

    return FolderExerciseItem(
      id: json['id'] as String,
      exercise: Exercise.fromJson(json['exercise'] as Map<String, dynamic>),
      sets: (json['sets'] as num).toInt(),
      reps: (json['reps'] as num).toInt(),
      weight: (json['weight'] as num?)?.toDouble(),
      minutes: (json['minutes'] as num?)?.toInt(),
      seconds: (json['seconds'] as num?)?.toInt(),
      configSets: configSets,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
    );
  }

  FolderExerciseItem copyWith({
    String? id,
    Exercise? exercise,
    int? sets,
    int? reps,
    double? weight,
    int? minutes,
    int? seconds,
    List<ExerciseSetData>? configSets,
    int? sortOrder,
  }) {
    return FolderExerciseItem(
      id: id ?? this.id,
      exercise: exercise ?? this.exercise,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      minutes: minutes ?? this.minutes,
      seconds: seconds ?? this.seconds,
      configSets: configSets ?? this.configSets,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FolderExerciseItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
