import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fio_fut/apps/admin/features/meals/domain/models/food.dart';

import '../../data/repositories/trainer_folder_repository.dart';

final folderFoodsProvider =
    AsyncNotifierProvider.family<FolderFoodsNotifier, List<Food>, String>(
  FolderFoodsNotifier.new,
);

class FolderFoodsNotifier extends FamilyAsyncNotifier<List<Food>, String> {
  @override
  Future<List<Food>> build(String arg) async {
    final repo = ref.read(trainerFolderRepositoryProvider);
    return repo.getFolderFoods(arg);
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      final repo = ref.read(trainerFolderRepositoryProvider);
      return repo.getFolderFoods(arg);
    });
  }

  Future<bool> addFoods(List<String> foodIds) async {
    try {
      final repo = ref.read(trainerFolderRepositoryProvider);
      await repo.addFoodsToFolder(arg, foodIds);
      await reload();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeFood(String foodId) async {
    try {
      final repo = ref.read(trainerFolderRepositoryProvider);
      await repo.removeFoodFromFolder(arg, foodId);
      await reload();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> moveFoodTo({
    required String toFolderId,
    required String foodId,
  }) async {
    try {
      final repo = ref.read(trainerFolderRepositoryProvider);
      await repo.moveFoodToFolder(
        fromFolderId: arg,
        toFolderId: toFolderId,
        foodId: foodId,
      );
      await reload();
      return true;
    } catch (e) {
      return false;
    }
  }
}
