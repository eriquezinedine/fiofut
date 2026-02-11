import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../ingredients/data/repositories/ingredients_repository.dart';
import '../../../ingredients/domain/models/ingredient.dart';
import '../../data/repositories/food_repository.dart';
import '../models/food.dart';

final foodFormProvider =
    NotifierProvider<FoodFormNotifier, FoodFormState>(
  FoodFormNotifier.new,
);

class FoodFormState {
  const FoodFormState({
    this.title = '',
    this.description = '',
    this.typeFood = FoodType.breakfast,
    this.selectedIngredients = const [],
    this.isLoading = false,
    this.errorMessage,
    this.editingId,
  });

  final String title;
  final String description;
  final FoodType typeFood;
  final List<SelectedIngredient> selectedIngredients;
  final bool isLoading;
  final String? errorMessage;
  final String? editingId;

  bool get isValid =>
      title.trim().isNotEmpty && selectedIngredients.isNotEmpty;
  bool get isEditing => editingId != null;

  double get totalCalories =>
      selectedIngredients.fold(0, (sum, i) => sum + i.calories);
  double get totalProtein =>
      selectedIngredients.fold(0, (sum, i) => sum + i.protein);
  double get totalCarbohydrates =>
      selectedIngredients.fold(0, (sum, i) => sum + i.carbohydrates);
  double get totalFat =>
      selectedIngredients.fold(0, (sum, i) => sum + i.fat);

  FoodFormState copyWith({
    String? title,
    String? description,
    FoodType? typeFood,
    List<SelectedIngredient>? selectedIngredients,
    bool? isLoading,
    String? errorMessage,
    String? editingId,
  }) {
    return FoodFormState(
      title: title ?? this.title,
      description: description ?? this.description,
      typeFood: typeFood ?? this.typeFood,
      selectedIngredients: selectedIngredients ?? this.selectedIngredients,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      editingId: editingId ?? this.editingId,
    );
  }
}

class FoodFormNotifier extends Notifier<FoodFormState> {
  @override
  FoodFormState build() {
    return const FoodFormState();
  }

  void reset() {
    state = const FoodFormState();
  }

  void loadFood(Food food) {
    state = FoodFormState(
      title: food.title,
      description: food.description ?? '',
      typeFood: food.typeFood,
      selectedIngredients: food.ingredients,
      editingId: food.id,
    );
  }

  void updateTitle(String value) =>
      state = state.copyWith(title: value);

  void updateDescription(String value) =>
      state = state.copyWith(description: value);

  void updateFoodType(FoodType value) =>
      state = state.copyWith(typeFood: value);

  void addIngredient(Ingredient ingredient, double quantity) {
    final exists = state.selectedIngredients
        .any((si) => si.ingredient.id == ingredient.id);

    if (exists) {
      updateIngredientQuantity(ingredient.id, quantity);
      return;
    }

    final updated = [
      ...state.selectedIngredients,
      SelectedIngredient(ingredient: ingredient, quantity: quantity),
    ];
    state = state.copyWith(selectedIngredients: updated);
  }

  void removeIngredient(String ingredientId) {
    final updated = state.selectedIngredients
        .where((si) => si.ingredient.id != ingredientId)
        .toList();
    state = state.copyWith(selectedIngredients: updated);
  }

  void updateIngredientQuantity(String ingredientId, double quantity) {
    final updated = state.selectedIngredients.map((si) {
      if (si.ingredient.id == ingredientId) {
        return si.copyWith(quantity: quantity);
      }
      return si;
    }).toList();
    state = state.copyWith(selectedIngredients: updated);
  }

  Future<Ingredient?> createIngredientInline({
    required String name,
    required double calories,
    required double protein,
    required double fat,
    required double carbohydrates,
    IngredientUnit unit = IngredientUnit.grams,
  }) async {
    try {
      final repo = ref.read(ingredientsRepositoryProvider);
      final ingredient = await repo.createIngredient(
        Ingredient(
          id: '',
          name: name,
          calories: calories,
          protein: protein,
          fat: fat,
          carbohydrates: carbohydrates,
          unit: unit,
        ),
      );
      return ingredient;
    } catch (_) {
      return null;
    }
  }

  Future<bool> save() async {
    if (state.title.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'El titulo es requerido');
      return false;
    }

    if (state.selectedIngredients.isEmpty) {
      state = state.copyWith(
          errorMessage: 'Agrega al menos un ingrediente');
      return false;
    }

    state = state.copyWith(isLoading: true);

    try {
      final repo = ref.read(foodRepositoryProvider);
      final food = Food(
        id: state.editingId ?? '',
        title: state.title.trim(),
        typeFood: state.typeFood,
        description: state.description.trim().isEmpty
            ? null
            : state.description.trim(),
      );

      if (state.isEditing) {
        await repo.updateFood(
            state.editingId!, food, state.selectedIngredients);
      } else {
        await repo.createFood(food, state.selectedIngredients);
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
