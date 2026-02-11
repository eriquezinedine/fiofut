part of 'ingredients_provider.dart';

sealed class IngredientsState {
  const IngredientsState();
}

class IngredientsInitial extends IngredientsState {
  const IngredientsInitial();
}

class IngredientsLoading extends IngredientsState {
  const IngredientsLoading();
}

class IngredientsLoaded extends IngredientsState {
  const IngredientsLoaded({required this.ingredients});

  final List<Ingredient> ingredients;
}

class IngredientsError extends IngredientsState {
  const IngredientsError({required this.message});

  final String message;
}
