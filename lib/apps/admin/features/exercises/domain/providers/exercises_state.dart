part of 'exercises_provider.dart';

sealed class ExercisesState {
  const ExercisesState();
}

class ExercisesInitial extends ExercisesState {
  const ExercisesInitial();
}

class ExercisesLoading extends ExercisesState {
  const ExercisesLoading();
}

class ExercisesLoaded extends ExercisesState {
  const ExercisesLoaded({required this.exercises});

  final List<Exercise> exercises;
}

class ExercisesError extends ExercisesState {
  const ExercisesError({required this.message});

  final String message;
}
