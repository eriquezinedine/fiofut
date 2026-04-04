import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise_schedule_item.dart';
import 'package:fio_fut/apps/client/features/training_exercise/domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedExerciseProvider = NotifierProvider.autoDispose<
    SelectedExerciseNotifier, ExerciseScheduleItem?>(
  SelectedExerciseNotifier.new,
);

class SelectedExerciseNotifier extends AutoDisposeNotifier<ExerciseScheduleItem?> {
  @override
  ExerciseScheduleItem? build() => null;

  /// Selecciona el primer ejercicio pendiente de la lista.
  void selectFirstPending(List<ExerciseScheduleItem> exercises) {
    state = exercises.cast<ExerciseScheduleItem?>().firstWhere(
          (e) => !e!.isCompleted,
          orElse: () => null,
        );
    ref.read(trainingSessionProvider.notifier).updateTraining(exercises);
  }

  void select(ExerciseScheduleItem exercise) => state = exercise;

  void clear() => state = null;
}
