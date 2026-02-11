import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/ingredients_repository.dart';
import '../models/ingredient.dart';

part 'ingredients_state.dart';

final ingredientsProvider =
    NotifierProvider<IngredientsNotifier, IngredientsState>(
  IngredientsNotifier.new,
);

class IngredientsNotifier extends Notifier<IngredientsState> {
  @override
  IngredientsState build() {
    return const IngredientsInitial();
  }

  Future<void> loadIngredients() async {
    state = const IngredientsLoading();

    try {
      final repo = ref.read(ingredientsRepositoryProvider);
      final ingredients = await repo.getIngredients();
      state = IngredientsLoaded(ingredients: ingredients);
    } catch (e) {
      state = IngredientsError(message: e.toString());
    }
  }

  Future<void> searchIngredients(String query) async {
    if (query.isEmpty) {
      await loadIngredients();
      return;
    }

    state = const IngredientsLoading();

    try {
      final repo = ref.read(ingredientsRepositoryProvider);
      final ingredients = await repo.searchIngredients(query);
      state = IngredientsLoaded(ingredients: ingredients);
    } catch (e) {
      state = IngredientsError(message: e.toString());
    }
  }

  Future<bool> deleteIngredient(String id) async {
    try {
      final repo = ref.read(ingredientsRepositoryProvider);
      await repo.deleteIngredient(id);
      await loadIngredients();
      return true;
    } catch (e) {
      return false;
    }
  }
}
