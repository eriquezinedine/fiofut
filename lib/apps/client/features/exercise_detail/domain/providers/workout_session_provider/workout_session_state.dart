import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise_schedule_item.dart';
import 'package:flutter/material.dart';

@immutable
class WorkoutSessionState {
  const WorkoutSessionState({
    this.sessionId,
    this.startedAt,
    this.elapsedSeconds = 0,
    this.completedExercises = 0,
    this.isFinished = false,
    this.photoUrl,
    this.allExercises = const [],
  });

  final String? sessionId;
  final DateTime? startedAt;
  final int elapsedSeconds;
  final int completedExercises;
  final bool isFinished;
  final String? photoUrl;
  final List<ExerciseScheduleItem> allExercises;

  int get totalExercises => allExercises.length;

  bool get isStarted => startedAt != null;
  bool get allCompleted =>
      totalExercises > 0 && completedExercises >= totalExercises;

  String get formattedTime {
    final mins = elapsedSeconds ~/ 60;
    final secs = elapsedSeconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  double get progress =>
      totalExercises > 0 ? completedExercises / totalExercises : 0.0;

  WorkoutSessionState copyWith({
    String? sessionId,
    DateTime? startedAt,
    int? elapsedSeconds,
    int? completedExercises,
    bool? isFinished,
    String? photoUrl,
    List<ExerciseScheduleItem>? allExercises,
  }) {
    return WorkoutSessionState(
      sessionId: sessionId ?? this.sessionId,
      startedAt: startedAt ?? this.startedAt,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      completedExercises: completedExercises ?? this.completedExercises,
      isFinished: isFinished ?? this.isFinished,
      photoUrl: photoUrl ?? this.photoUrl,
      allExercises: allExercises ?? this.allExercises,
    );
  }
}
