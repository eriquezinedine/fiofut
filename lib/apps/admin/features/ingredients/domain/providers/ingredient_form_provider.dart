import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/ingredients_repository.dart';
import '../models/ingredient.dart';

final ingredientFormProvider =
    NotifierProvider<IngredientFormNotifier, IngredientFormState>(
  IngredientFormNotifier.new,
);

class IngredientFormState {
  const IngredientFormState({
    this.name = '',
    this.calories = 0,
    this.protein = 0,
    this.fat = 0,
    this.carbohydrates = 0,
    this.unit = IngredientUnit.grams,
    this.isLoading = false,
    this.errorMessage,
    this.editingId,
  });

  final String name;
  final double calories;
  final double protein;
  final double fat;
  final double carbohydrates;
  final IngredientUnit unit;
  final bool isLoading;
  final String? errorMessage;
  final String? editingId;

  bool get isValid => name.trim().isNotEmpty;
  bool get isEditing => editingId != null;

  IngredientFormState copyWith({
    String? name,
    double? calories,
    double? protein,
    double? fat,
    double? carbohydrates,
    IngredientUnit? unit,
    bool? isLoading,
    String? errorMessage,
    String? editingId,
  }) {
    return IngredientFormState(
      name: name ?? this.name,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      carbohydrates: carbohydrates ?? this.carbohydrates,
      unit: unit ?? this.unit,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      editingId: editingId ?? this.editingId,
    );
  }
}

class IngredientFormNotifier extends Notifier<IngredientFormState> {
  @override
  IngredientFormState build() {
    return const IngredientFormState();
  }

  void reset() {
    state = const IngredientFormState();
  }

  void loadIngredient(Ingredient ingredient) {
    state = IngredientFormState(
      name: ingredient.name,
      calories: ingredient.calories,
      protein: ingredient.protein,
      fat: ingredient.fat,
      carbohydrates: ingredient.carbohydrates,
      unit: ingredient.unit,
      editingId: ingredient.id,
    );
  }

  void updateName(String value) =>
      state = state.copyWith(name: value);

  void updateCalories(double value) =>
      state = state.copyWith(calories: value);

  void updateProtein(double value) =>
      state = state.copyWith(protein: value);

  void updateFat(double value) =>
      state = state.copyWith(fat: value);

  void updateCarbohydrates(double value) =>
      state = state.copyWith(carbohydrates: value);

  void updateUnit(IngredientUnit value) =>
      state = state.copyWith(unit: value);

  Future<bool> save() async {
    if (state.name.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'El nombre es requerido');
      return false;
    }

    state = state.copyWith(isLoading: true);

    try {
      final repo = ref.read(ingredientsRepositoryProvider);
      final ingredient = Ingredient(
        id: state.editingId ?? '',
        name: state.name.trim(),
        calories: state.calories,
        protein: state.protein,
        fat: state.fat,
        carbohydrates: state.carbohydrates,
        unit: state.unit,
      );

      if (state.isEditing) {
        await repo.updateIngredient(state.editingId!, ingredient);
      } else {
        await repo.createIngredient(ingredient);
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
