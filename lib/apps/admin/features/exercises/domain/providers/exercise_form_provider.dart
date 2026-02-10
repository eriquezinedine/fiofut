import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/exercises_repository.dart';
import '../models/exercise.dart';

final exerciseFormProvider =
    NotifierProvider<ExerciseFormNotifier, ExerciseFormState>(
  ExerciseFormNotifier.new,
);

class ExerciseFormState {
  const ExerciseFormState({
    this.name = '',
    this.description = '',
    this.imageUrl = '',
    this.muscleGroup = MuscleGroup.pecho,
    this.exerciseType = ExerciseType.fuerza,
    this.isLoading = false,
    this.errorMessage,
    this.editingId,
  });

  final String name;
  final String description;
  final String imageUrl;
  final MuscleGroup muscleGroup;
  final ExerciseType exerciseType;
  final bool isLoading;
  final String? errorMessage;
  final String? editingId;

  bool get isValid => name.trim().isNotEmpty;
  bool get isEditing => editingId != null;

  ExerciseFormState copyWith({
    String? name,
    String? description,
    String? imageUrl,
    MuscleGroup? muscleGroup,
    ExerciseType? exerciseType,
    bool? isLoading,
    String? errorMessage,
    String? editingId,
  }) {
    return ExerciseFormState(
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      muscleGroup: muscleGroup ?? this.muscleGroup,
      exerciseType: exerciseType ?? this.exerciseType,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      editingId: editingId ?? this.editingId,
    );
  }
}

class ExerciseFormNotifier extends Notifier<ExerciseFormState> {
  @override
  ExerciseFormState build() {
    return const ExerciseFormState();
  }

  void reset() {
    state = const ExerciseFormState();
  }

  void loadExercise(Exercise exercise) {
    state = ExerciseFormState(
      name: exercise.name,
      description: exercise.description ?? '',
      imageUrl: exercise.imageUrl ?? '',
      muscleGroup: exercise.muscleGroup,
      exerciseType: exercise.exerciseType,
      editingId: exercise.id,
    );
  }

  void updateName(String value) {
    state = state.copyWith(name: value);
  }

  void updateDescription(String value) {
    state = state.copyWith(description: value);
  }

  void updateImageUrl(String value) {
    state = state.copyWith(imageUrl: value);
  }

  void updateMuscleGroup(MuscleGroup value) {
    state = state.copyWith(muscleGroup: value);
  }

  void updateExerciseType(ExerciseType value) {
    state = state.copyWith(exerciseType: value);
  }

  Future<bool> save() async {
    if (!state.isValid) {
      state = state.copyWith(errorMessage: 'El nombre es requerido');
      return false;
    }

    state = state.copyWith(isLoading: true);

    try {
      final repo = ref.read(exercisesRepositoryProvider);
      final exercise = Exercise(
        id: state.editingId ?? '',
        name: state.name.trim(),
        description: state.description.trim().isEmpty
            ? null
            : state.description.trim(),
        imageUrl:
            state.imageUrl.trim().isEmpty ? null : state.imageUrl.trim(),
        muscleGroup: state.muscleGroup,
        exerciseType: state.exerciseType,
      );

      if (state.isEditing) {
        await repo.updateExercise(state.editingId!, exercise);
      } else {
        await repo.createExercise(exercise);
      }

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }
}
