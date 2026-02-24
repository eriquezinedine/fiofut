part of 'food_folders_provider.dart';

sealed class FoodFoldersState {
  const FoodFoldersState();
}

class FoodFoldersInitial extends FoodFoldersState {
  const FoodFoldersInitial();
}

class FoodFoldersLoading extends FoodFoldersState {
  const FoodFoldersLoading();
}

class FoodFoldersLoaded extends FoodFoldersState {
  const FoodFoldersLoaded({required this.folders});

  final List<TrainerFolder> folders;
}

class FoodFoldersError extends FoodFoldersState {
  const FoodFoldersError({required this.message});

  final String message;
}
