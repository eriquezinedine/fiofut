import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise_schedule_item.dart';

import '../../data/repositories/trainer_folder_repository.dart';
import '../models/folder_exercise_item.dart';

final folderExercisesProvider = AsyncNotifierProvider.family<
    FolderExercisesNotifier, List<FolderExerciseItem>, String>(
  FolderExercisesNotifier.new,
);

class FolderExercisesNotifier
    extends FamilyAsyncNotifier<List<FolderExerciseItem>, String> {
  @override
  Future<List<FolderExerciseItem>> build(String arg) async {
    final repo = ref.read(trainerFolderRepositoryProvider);
    return repo.getFolderExercises(arg);
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      final repo = ref.read(trainerFolderRepositoryProvider);
      return repo.getFolderExercises(arg);
    });
  }

  Future<bool> addExercise({
    required String exerciseId,
    required List<ExerciseSetData> series,
  }) async {
    try {
      final repo = ref.read(trainerFolderRepositoryProvider);
      await repo.addExerciseToFolder(
        folderId: arg,
        exerciseId: exerciseId,
        series: series,
      );
      await reload();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addExercises(
    List<({String exerciseId, List<ExerciseSetData> series})> exercises,
  ) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(trainerFolderRepositoryProvider);
      for (final e in exercises) {
        await repo.addExerciseToFolder(
          folderId: arg,
          exerciseId: e.exerciseId,
          series: e.series,
        );
      }
      state = await AsyncValue.guard(() => repo.getFolderExercises(arg));
      return true;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> removeExercise(String itemId) async {
    try {
      final repo = ref.read(trainerFolderRepositoryProvider);
      await repo.removeExerciseFromFolder(itemId);
      await reload();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateExercise({
    required String itemId,
    required int sets,
    required int reps,
  }) async {
    try {
      final repo = ref.read(trainerFolderRepositoryProvider);
      await repo.updateExerciseInFolder(
        itemId: itemId,
        sets: sets,
        reps: reps,
      );
      await reload();
      return true;
    } catch (e) {
      return false;
    }
  }
}
