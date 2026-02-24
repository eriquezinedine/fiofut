import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/trainer_folder_repository.dart';
import '../models/trainer_folder.dart';

part 'food_folders_state.dart';

final foodFoldersProvider =
    NotifierProvider<FoodFoldersNotifier, FoodFoldersState>(
  FoodFoldersNotifier.new,
);

class FoodFoldersNotifier extends Notifier<FoodFoldersState> {
  @override
  FoodFoldersState build() {
    return const FoodFoldersInitial();
  }

  Future<void> loadFolders() async {
    state = const FoodFoldersLoading();
    try {
      final repo = ref.read(trainerFolderRepositoryProvider);
      final folders = await repo.getFolders('food');
      state = FoodFoldersLoaded(folders: folders);
    } catch (e) {
      state = FoodFoldersError(message: e.toString());
    }
  }

  Future<bool> createFolder({
    required String title,
    String? description,
  }) async {
    try {
      final repo = ref.read(trainerFolderRepositoryProvider);
      await repo.createFolder(
        title: title,
        description: description,
        folderType: 'food',
      );
      await loadFolders();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateFolder({
    required String folderId,
    required String title,
    String? description,
  }) async {
    try {
      final repo = ref.read(trainerFolderRepositoryProvider);
      await repo.updateFolder(
        folderId: folderId,
        title: title,
        description: description,
      );
      await loadFolders();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteFolder(String folderId) async {
    try {
      final repo = ref.read(trainerFolderRepositoryProvider);
      await repo.deleteFolder(folderId);
      await loadFolders();
      return true;
    } catch (e) {
      return false;
    }
  }
}
