import 'package:fio_fut/apps/client/features/exercise_detail/domain/providers/workout_session_provider/workout_session_state.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/domain/providers/workout_timer_session_provider/workout_timer_provider.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise_schedule_item.dart';
import 'package:fio_fut/core/utils/debouncer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/repositories/workout_session_repository.dart';

/// Global workout session state — NOT autoDispose so it persists across pages.
final workoutSessionProvider =
    NotifierProvider<WorkoutSessionNotifier, WorkoutSessionState>(
  WorkoutSessionNotifier.new,
);

class WorkoutSessionNotifier extends Notifier<WorkoutSessionState> {
  final _syncDebouncer = Debouncer(milliseconds: 1000);

  @override
  WorkoutSessionState build() {
    // Listen to timer changes and sync elapsed seconds
    ref.listen(workoutTimerProvider, (previous, next) {
      _onTimerTick(next.elapsedSeconds);
    });
    return const WorkoutSessionState();
  }

  void _onTimerTick(int elapsedSeconds) {
    state = state.copyWith(elapsedSeconds: elapsedSeconds);
    _scheduleSyncDebounce();
  }

  /// Starts the workout session with the given exercises.
  Future<void> startSession(List<ExerciseScheduleItem> exercises) async {
    if (state.isStarted) return;

    final now = DateTime.now();
    state = state.copyWith(
      startedAt: now,
      allExercises: exercises,
    );

    // Start the timer
    ref.read(workoutTimerProvider.notifier).start();

    // Create session in backend
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      final repo = ref.read(workoutSessionRepositoryProvider);
      final sessionId = await repo.upsertSession(
        userId: userId,
        date: now,
        startedAt: now,
        totalExercises: exercises.length,
      );
      state = state.copyWith(sessionId: sessionId);
    }
  }

  /// Debounce: sync elapsed seconds to backend every 5 seconds.
  void _scheduleSyncDebounce() {
    if (state.elapsedSeconds % 5 != 0) return;
    _syncDebouncer.run(_syncElapsed);
  }

  Future<void> _syncElapsed() async {
    final sessionId = state.sessionId;
    if (sessionId == null) return;

    final repo = ref.read(workoutSessionRepositoryProvider);
    await repo.updateElapsedSeconds(
      sessionId: sessionId,
      seconds: state.elapsedSeconds,
    );
  }

  void markExerciseCompleted() {
    state = state.copyWith(
      completedExercises: state.completedExercises + 1,
    );
  }

  void markExerciseUncompleted() {
    if (state.completedExercises <= 0) return;
    state = state.copyWith(
      completedExercises: state.completedExercises - 1,
    );
  }

  Future<void> finishSession() async {
    // Stop the timer
    ref.read(workoutTimerProvider.notifier).pause();
    _syncDebouncer.cancel();

    state = state.copyWith(isFinished: true);

    final sessionId = state.sessionId;
    if (sessionId == null) return;

    final repo = ref.read(workoutSessionRepositoryProvider);
    await repo.finishSession(
      sessionId: sessionId,
      elapsedSeconds: state.elapsedSeconds,
      exercisesCompleted: state.completedExercises,
    );
  }

  Future<void> setPhoto(String url) async {
    state = state.copyWith(photoUrl: url);

    final sessionId = state.sessionId;
    if (sessionId == null) return;

    final repo = ref.read(workoutSessionRepositoryProvider);
    await repo.updatePhoto(sessionId: sessionId, photoUrl: url);
  }

  void reset() {
    ref.read(workoutTimerProvider.notifier).stop();
    _syncDebouncer.cancel();
    state = const WorkoutSessionState();
  }
}
