import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/trainer_folder_repository.dart';
import '../models/trainer_folder.dart';

part 'exercise_folders_state.dart';

final exerciseFoldersProvider =
    NotifierProvider<ExerciseFoldersNotifier, ExerciseFoldersState>(
  ExerciseFoldersNotifier.new,
);

class ExerciseFoldersNotifier extends Notifier<ExerciseFoldersState> {
  @override
  ExerciseFoldersState build() {
    return const ExerciseFoldersInitial();
  }

  Future<void> loadFolders() async {
    state = const ExerciseFoldersLoading();
    try {
      final repo = ref.read(trainerFolderRepositoryProvider);
      final folders = await repo.getFolders('exercise');
      state = ExerciseFoldersLoaded(folders: folders);
    } catch (e) {
      state = ExerciseFoldersError(message: e.toString());
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
        folderType: 'exercise',
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
