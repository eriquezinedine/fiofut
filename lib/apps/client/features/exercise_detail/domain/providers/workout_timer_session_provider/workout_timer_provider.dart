import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'workout_timer_state.dart';

/// Provider for workout timer - manages elapsed time independently.
final workoutTimerProvider =
    NotifierProvider<WorkoutTimerNotifier, WorkoutTimerState>(
  WorkoutTimerNotifier.new,
);

class WorkoutTimerNotifier extends Notifier<WorkoutTimerState> {
  Timer? _timer;

  @override
  WorkoutTimerState build() => const WorkoutTimerState();

  /// Starts the timer.
  void start() {
    if (state.isRunning) return;

    state = state.copyWith(isRunning: true);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(elapsedSeconds: state.elapsedSeconds + 1);
    });
  }

  /// Pauses the timer without resetting.
  void pause() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  /// Stops and resets the timer.
  void stop() {
    _timer?.cancel();
    state = const WorkoutTimerState();
  }

  /// Resets elapsed time to zero but keeps running state.
  void reset() {
    state = state.copyWith(elapsedSeconds: 0);
  }

  /// Returns current elapsed seconds (for sync purposes).
  int get currentSeconds => state.elapsedSeconds;
}
