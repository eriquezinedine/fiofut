import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/meals_repository.dart';
import '../models/meal.dart';

part 'meals_state.dart';

final mealsProvider =
    NotifierProvider<MealsNotifier, MealsState>(
  MealsNotifier.new,
);

class MealsNotifier extends Notifier<MealsState> {
  @override
  MealsState build() {
    return const MealsInitial();
  }

  Future<void> loadMeals() async {
    state = const MealsLoading();

    try {
      final repo = ref.read(mealsRepositoryProvider);
      final meals = await repo.getMeals();
      state = MealsLoaded(meals: meals);
    } catch (e) {
      state = MealsError(message: e.toString());
    }
  }

  Future<void> searchMeals(String query) async {
    if (query.isEmpty) {
      await loadMeals();
      return;
    }

    state = const MealsLoading();

    try {
      final repo = ref.read(mealsRepositoryProvider);
      final meals = await repo.searchMeals(query);
      state = MealsLoaded(meals: meals);
    } catch (e) {
      state = MealsError(message: e.toString());
    }
  }

  Future<bool> deleteMeal(String id) async {
    try {
      final repo = ref.read(mealsRepositoryProvider);
      await repo.deleteMeal(id);
      await loadMeals();
      return true;
    } catch (e) {
      return false;
    }
  }
}
