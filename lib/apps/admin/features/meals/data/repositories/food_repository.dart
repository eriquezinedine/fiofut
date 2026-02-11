import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../ingredients/domain/models/ingredient.dart';
import '../../domain/models/food.dart';

final foodRepositoryProvider = Provider<FoodRepository>((ref) {
  return FoodRepository();
});

class FoodRepository {
  FoodRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<Food>> getFoods() async {
    final data = await _client
        .from('food')
        .select()
        .order('created_at', ascending: false);

    final foods = <Food>[];
    for (final json in data) {
      final ingredients = await _getIngredientsForFood(json['id'] as String);
      foods.add(Food.fromJson(json, ingredients: ingredients));
    }
    return foods;
  }

  Future<Food> getFoodById(String id) async {
    final data = await _client.from('food').select().eq('id', id).single();
    final ingredients = await _getIngredientsForFood(id);
    return Food.fromJson(data, ingredients: ingredients);
  }

  Future<Food> createFood(
    Food food,
    List<SelectedIngredient> ingredients,
  ) async {
    final data = await _client
        .from('food')
        .insert(food.toJson())
        .select()
        .single();

    final foodId = data['id'] as String;

    if (ingredients.isNotEmpty) {
      await _client.from('detail_food_ingredient').insert(
            ingredients
                .map((si) => {
                      'id_food': foodId,
                      'id_ingredient': si.ingredient.id,
                      'quantity': si.quantity,
                    })
                .toList(),
          );
    }

    return getFoodById(foodId);
  }

  Future<Food> updateFood(
    String id,
    Food food,
    List<SelectedIngredient> ingredients,
  ) async {
    await _client.from('food').update(food.toJson()).eq('id', id);

    // Replace ingredients: delete existing, insert new
    await _client.from('detail_food_ingredient').delete().eq('id_food', id);

    if (ingredients.isNotEmpty) {
      await _client.from('detail_food_ingredient').insert(
            ingredients
                .map((si) => {
                      'id_food': id,
                      'id_ingredient': si.ingredient.id,
                      'quantity': si.quantity,
                    })
                .toList(),
          );
    }

    return getFoodById(id);
  }

  Future<void> deleteFood(String id) async {
    await _client.from('detail_food_ingredient').delete().eq('id_food', id);
    await _client.from('food').delete().eq('id', id);
  }

  Future<List<Food>> searchFoods(String query) async {
    final data = await _client
        .from('food')
        .select()
        .ilike('title', '%$query%')
        .order('created_at', ascending: false);

    final foods = <Food>[];
    for (final json in data) {
      final ingredients = await _getIngredientsForFood(json['id'] as String);
      foods.add(Food.fromJson(json, ingredients: ingredients));
    }
    return foods;
  }

  Future<List<SelectedIngredient>> _getIngredientsForFood(
      String foodId) async {
    final data = await _client
        .from('detail_food_ingredient')
        .select('quantity, ingredient(*)')
        .eq('id_food', foodId);

    return data.map((json) {
      final ingredientJson = json['ingredient'] as Map<String, dynamic>;
      return SelectedIngredient(
        ingredient: Ingredient.fromJson(ingredientJson),
        quantity: (json['quantity'] as num).toDouble(),
      );
    }).toList();
  }
}
