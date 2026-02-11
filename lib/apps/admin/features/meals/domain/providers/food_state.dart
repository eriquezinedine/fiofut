part of 'food_provider.dart';

sealed class FoodState {
  const FoodState();
}

class FoodInitial extends FoodState {
  const FoodInitial();
}

class FoodLoading extends FoodState {
  const FoodLoading();
}

class FoodLoaded extends FoodState {
  const FoodLoaded({required this.foods});

  final List<Food> foods;
}

class FoodError extends FoodState {
  const FoodError({required this.message});

  final String message;
}
