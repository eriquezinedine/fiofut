part of 'meals_provider.dart';

sealed class MealsState {
  const MealsState();
}

class MealsInitial extends MealsState {
  const MealsInitial();
}

class MealsLoading extends MealsState {
  const MealsLoading();
}

class MealsLoaded extends MealsState {
  const MealsLoaded({required this.meals});

  final List<Meal> meals;
}

class MealsError extends MealsState {
  const MealsError({required this.message});

  final String message;
}
