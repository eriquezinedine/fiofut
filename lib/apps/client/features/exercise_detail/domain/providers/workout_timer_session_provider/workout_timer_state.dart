import 'package:flutter/foundation.dart';

@immutable
class WorkoutTimerState {
  const WorkoutTimerState({
    this.elapsedSeconds = 0,
    this.isRunning = false,
  });

  final int elapsedSeconds;
  final bool isRunning;

  String get formattedTime {
    final mins = elapsedSeconds ~/ 60;
    final secs = elapsedSeconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  WorkoutTimerState copyWith({
    int? elapsedSeconds,
    bool? isRunning,
  }) {
    return WorkoutTimerState(
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}
