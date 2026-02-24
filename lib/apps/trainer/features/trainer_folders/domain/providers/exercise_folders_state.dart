part of 'exercise_folders_provider.dart';

sealed class ExerciseFoldersState {
  const ExerciseFoldersState();
}

class ExerciseFoldersInitial extends ExerciseFoldersState {
  const ExerciseFoldersInitial();
}

class ExerciseFoldersLoading extends ExerciseFoldersState {
  const ExerciseFoldersLoading();
}

class ExerciseFoldersLoaded extends ExerciseFoldersState {
  const ExerciseFoldersLoaded({required this.folders});

  final List<TrainerFolder> folders;
}

class ExerciseFoldersError extends ExerciseFoldersState {
  const ExerciseFoldersError({required this.message});

  final String message;
}
