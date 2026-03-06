import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/workout_session_repository.dart';

/// Global workout session state — NOT autoDispose so it persists across pages.
final workoutSessionProvider =
    NotifierProvider<WorkoutSessionNotifier, WorkoutSessionState>(
  WorkoutSessionNotifier.new,
);

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
    return '$mins min';
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

class WorkoutSessionNotifier extends Notifier<WorkoutSessionState> {
  Timer? _timer;
  Timer? _syncDebounce;

  @override
  WorkoutSessionState build() => const WorkoutSessionState();

  /// Starts the workout session with the given total exercises.
  Future<void> startSession(int totalExercises) async {
    if (state.isStarted) return;

    final now = DateTime.now();
    state = state.copyWith(
      startedAt: now,
      totalExercises: totalExercises,
    );

    _startTimer();

    // Create session in backend
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      final repo = ref.read(workoutSessionRepositoryProvider);
      final sessionId = await repo.upsertSession(
        userId: userId,
        date: now,
        startedAt: now,
        totalExercises: totalExercises,
      );
      state = state.copyWith(sessionId: sessionId);
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(elapsedSeconds: state.elapsedSeconds + 1);
      _scheduleSyncDebounce();
    });
  }

  /// Debounce: sync elapsed seconds to backend every 5 seconds.
  void _scheduleSyncDebounce() {
    if (state.elapsedSeconds % 5 != 0) return;
    _syncDebounce?.cancel();
    _syncDebounce = Timer(const Duration(seconds: 1), () {
      _syncElapsed();
    });
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
    _timer?.cancel();
    _syncDebounce?.cancel();

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
    _timer?.cancel();
    _syncDebounce?.cancel();
    state = const WorkoutSessionState();
  }
}
