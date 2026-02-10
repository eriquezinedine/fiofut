import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/meals_repository.dart';
import '../models/meal.dart';

final mealFormProvider =
    NotifierProvider<MealFormNotifier, MealFormState>(
  MealFormNotifier.new,
);

class MealFormState {
  const MealFormState({
    this.name = '',
    this.description = '',
    this.imageUrl = '',
    this.calories = 0,
    this.mealType = MealType.desayuno,
    this.isLoading = false,
    this.errorMessage,
    this.editingId,
  });

  final String name;
  final String description;
  final String imageUrl;
  final int calories;
  final MealType mealType;
  final bool isLoading;
  final String? errorMessage;
  final String? editingId;

  bool get isValid => name.trim().isNotEmpty && calories >= 0;
  bool get isEditing => editingId != null;

  MealFormState copyWith({
    String? name,
    String? description,
    String? imageUrl,
    int? calories,
    MealType? mealType,
    bool? isLoading,
    String? errorMessage,
    String? editingId,
  }) {
    return MealFormState(
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      calories: calories ?? this.calories,
      mealType: mealType ?? this.mealType,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      editingId: editingId ?? this.editingId,
    );
  }
}

class MealFormNotifier extends Notifier<MealFormState> {
  @override
  MealFormState build() {
    return const MealFormState();
  }

  void reset() {
    state = const MealFormState();
  }

  void loadMeal(Meal meal) {
    state = MealFormState(
      name: meal.name,
      description: meal.description ?? '',
      imageUrl: meal.imageUrl ?? '',
      calories: meal.calories,
      mealType: meal.mealType,
      editingId: meal.id,
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

  void updateCalories(int value) {
    state = state.copyWith(calories: value);
  }

  void updateMealType(MealType value) {
    state = state.copyWith(mealType: value);
  }

  Future<bool> save() async {
    if (!state.isValid) {
      state = state.copyWith(errorMessage: 'El nombre es requerido');
      return false;
    }

    state = state.copyWith(isLoading: true);

    try {
      final repo = ref.read(mealsRepositoryProvider);
      final meal = Meal(
        id: state.editingId ?? '',
        name: state.name.trim(),
        description: state.description.trim().isEmpty
            ? null
            : state.description.trim(),
        imageUrl:
            state.imageUrl.trim().isEmpty ? null : state.imageUrl.trim(),
        calories: state.calories,
        mealType: state.mealType,
      );

      if (state.isEditing) {
        await repo.updateMeal(state.editingId!, meal);
      } else {
        await repo.createMeal(meal);
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
