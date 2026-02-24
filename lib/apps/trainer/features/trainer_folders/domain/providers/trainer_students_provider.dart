import 'package:authentication/authentication.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/trainer_folder_repository.dart';

final trainerStudentsProvider =
    AsyncNotifierProvider<TrainerStudentsNotifier, List<UserProfile>>(
  TrainerStudentsNotifier.new,
);

class TrainerStudentsNotifier extends AsyncNotifier<List<UserProfile>> {
  @override
  Future<List<UserProfile>> build() async {
    final repo = ref.read(trainerFolderRepositoryProvider);
    return repo.getMyStudents();
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      final repo = ref.read(trainerFolderRepositoryProvider);
      return repo.getMyStudents();
    });
  }
}
