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
    this.primaryMuscleId,
    this.secondaryMuscleIds = const [],
    this.exerciseType = ExerciseType.strength,
    this.videoUrl = '',
    this.location = ExerciseLocation.both,
    this.isLoading = false,
    this.errorMessage,
    this.editingId,
  });

  final String name;
  final String description;
  final String imageUrl;
  final String? primaryMuscleId;
  final List<String> secondaryMuscleIds;
  final ExerciseType exerciseType;
  final String videoUrl;
  final ExerciseLocation location;
  final bool isLoading;
  final String? errorMessage;
  final String? editingId;

  bool get isValid =>
      name.trim().isNotEmpty &&
      description.trim().isNotEmpty &&
      imageUrl.trim().isNotEmpty &&
      videoUrl.trim().isNotEmpty &&
      primaryMuscleId != null;
  bool get isEditing => editingId != null;

  ExerciseFormState copyWith({
    String? name,
    String? description,
    String? imageUrl,
    String? primaryMuscleId,
    List<String>? secondaryMuscleIds,
    ExerciseType? exerciseType,
    String? videoUrl,
    ExerciseLocation? location,
    bool? isLoading,
    String? errorMessage,
    String? editingId,
    bool clearPrimaryMuscle = false,
  }) {
    return ExerciseFormState(
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      primaryMuscleId:
          clearPrimaryMuscle ? null : (primaryMuscleId ?? this.primaryMuscleId),
      secondaryMuscleIds: secondaryMuscleIds ?? this.secondaryMuscleIds,
      exerciseType: exerciseType ?? this.exerciseType,
      videoUrl: videoUrl ?? this.videoUrl,
      location: location ?? this.location,
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
      primaryMuscleId: exercise.primaryMuscleId,
      secondaryMuscleIds: exercise.secondaryMuscleIds,
      exerciseType: exercise.exerciseType,
      videoUrl: exercise.videoUrl ?? '',
      location: exercise.location,
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

  void updatePrimaryMuscle(String? muscleId) {
    // If selecting the same, deselect
    if (state.primaryMuscleId == muscleId) {
      state = state.copyWith(clearPrimaryMuscle: true);
      return;
    }
    // Remove from secondary if it was there
    final updatedSecondary =
        state.secondaryMuscleIds.where((id) => id != muscleId).toList();
    state = state.copyWith(
      primaryMuscleId: muscleId,
      secondaryMuscleIds: updatedSecondary,
    );
  }

  void toggleSecondaryMuscle(String muscleId) {
    // Can't add the primary muscle as secondary
    if (muscleId == state.primaryMuscleId) return;

    final current = List<String>.from(state.secondaryMuscleIds);
    if (current.contains(muscleId)) {
      current.remove(muscleId);
    } else {
      current.add(muscleId);
    }
    state = state.copyWith(secondaryMuscleIds: current);
  }

  void updateVideoUrl(String value) {
    state = state.copyWith(videoUrl: value);
  }

  void updateLocation(ExerciseLocation value) {
    state = state.copyWith(location: value);
  }

  void updateExerciseType(ExerciseType value) {
    state = state.copyWith(exerciseType: value);
  }

  Future<bool> save() async {
    if (!state.isValid) {
      state = state.copyWith(
        errorMessage:
            'Todos los campos requeridos deben estar completos',
      );
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
        primaryMuscleId: state.primaryMuscleId,
        secondaryMuscleIds: state.secondaryMuscleIds,
        exerciseType: state.exerciseType,
        videoUrl:
            state.videoUrl.trim().isEmpty ? null : state.videoUrl.trim(),
        location: state.location,
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
