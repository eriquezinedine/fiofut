
import 'package:flutter/material.dart';
@immutable
class WorkoutSessionState {
  const WorkoutSessionState({
    this.sessionId,
    this.startedAt,
    this.elapsedSeconds = 0,
    this.completedExercises = 0,
    this.totalExercises = 0,
    this.isFinished = false,
    this.photoUrl,
  });

  final String? sessionId;
  final DateTime? startedAt;
  final int elapsedSeconds;
  final int completedExercises;
  final int totalExercises;
  final bool isFinished;
  final String? photoUrl;

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
    int? totalExercises,
    bool? isFinished,
    String? photoUrl,
  }) {
    return WorkoutSessionState(
      sessionId: sessionId ?? this.sessionId,
      startedAt: startedAt ?? this.startedAt,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      completedExercises: completedExercises ?? this.completedExercises,
      totalExercises: totalExercises ?? this.totalExercises,
      isFinished: isFinished ?? this.isFinished,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
