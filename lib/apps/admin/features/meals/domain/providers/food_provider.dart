import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/food_repository.dart';
import '../models/food.dart';

part 'food_state.dart';

final foodProvider =
    NotifierProvider<FoodNotifier, FoodState>(
  FoodNotifier.new,
);

class FoodNotifier extends Notifier<FoodState> {
  @override
  FoodState build() {
    return const FoodInitial();
  }

  Future<void> loadFoods() async {
    state = const FoodLoading();

    try {
      final repo = ref.read(foodRepositoryProvider);
      final foods = await repo.getFoods();
      state = FoodLoaded(foods: foods);
    } catch (e) {
      state = FoodError(message: e.toString());
    }
  }

  Future<void> searchFoods(String query) async {
    if (query.isEmpty) {
      await loadFoods();
      return;
    }

    state = const FoodLoading();

    try {
      final repo = ref.read(foodRepositoryProvider);
      final foods = await repo.searchFoods(query);
      state = FoodLoaded(foods: foods);
    } catch (e) {
      state = FoodError(message: e.toString());
    }
  }

  Future<bool> deleteFood(String id) async {
    try {
      final repo = ref.read(foodRepositoryProvider);
      await repo.deleteFood(id);
      await loadFoods();
      return true;
    } catch (e) {
      return false;
    }
  }
}
