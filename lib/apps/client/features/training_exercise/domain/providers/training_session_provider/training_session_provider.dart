import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise_schedule_item.dart';
import 'package:fio_fut/apps/client/features/training_exercise/domain/providers/training_timer_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'training_session_state.dart';

/// Estado de la sesión de entrenamiento (autoDispose).
final trainingSessionProvider = NotifierProvider.autoDispose<
    TrainingSessionNotifier, TrainingSessionState>(
  TrainingSessionNotifier.new,
);

class TrainingSessionNotifier extends AutoDisposeNotifier<TrainingSessionState> {
  @override
  TrainingSessionState build() => const TrainingSessionState();

  void startTraining() {
    state = state.copyWith(isStarted: true);
    ref.read(trainingTimerProvider.notifier).start();
  }

  void updateTraining(List<ExerciseScheduleItem> exercises) {
    state = state.copyWith(exercises: exercises);
  }

  void updateExerciseSeries({
    required String scheduleId,
    required List<ExerciseSetData> updatedSeries,
  }) {
    final exercises = state.exercises.map((e) {
      if (e.scheduleId != scheduleId) return e;
      return e.copyWith(sets: updatedSeries);
    }).toList();
    state = state.copyWith(exercises: exercises);
  }

  void finishTraining() {
    ref.read(trainingTimerProvider.notifier).pause();
    state = state.copyWith(isFinished: true);
  }

  void cancelTraining() {
    ref.read(trainingTimerProvider.notifier).reset();
    state = const TrainingSessionState();
  }
}
