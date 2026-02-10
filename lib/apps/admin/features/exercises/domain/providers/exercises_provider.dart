import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/exercises_repository.dart';
import '../models/exercise.dart';

part 'exercises_state.dart';

final exercisesProvider =
    NotifierProvider<ExercisesNotifier, ExercisesState>(
  ExercisesNotifier.new,
);

class ExercisesNotifier extends Notifier<ExercisesState> {
  @override
  ExercisesState build() {
    return const ExercisesInitial();
  }

  Future<void> loadExercises() async {
    state = const ExercisesLoading();

    try {
      final repo = ref.read(exercisesRepositoryProvider);
      final exercises = await repo.getExercises();
      state = ExercisesLoaded(exercises: exercises);
    } catch (e) {
      state = ExercisesError(message: e.toString());
    }
  }

  Future<void> searchExercises(String query) async {
    if (query.isEmpty) {
      await loadExercises();
      return;
    }

    state = const ExercisesLoading();

    try {
      final repo = ref.read(exercisesRepositoryProvider);
      final exercises = await repo.searchExercises(query);
      state = ExercisesLoaded(exercises: exercises);
    } catch (e) {
      state = ExercisesError(message: e.toString());
    }
  }

  Future<bool> deleteExercise(String id) async {
    try {
      final repo = ref.read(exercisesRepositoryProvider);
      await repo.deleteExercise(id);
      await loadExercises();
      return true;
    } catch (e) {
      return false;
    }
  }
}
