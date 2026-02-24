import 'package:fio_fut/apps/client/features/home/domain/models/meal_item.dart';
import 'package:fio_fut/apps/client/features/register_food/domain/providers/food_provider_detail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../local/cached_food.dart';
import '../../domain/models/food_home_item.dart';

final foodHomeRepositoryProvider = Provider<FoodHomeRepository>((ref) {
  return FoodHomeRepository();
});

class FoodHomeRepository {
  /// Fetches foods for an entire week (Mon-Sun) in a single query.
  /// Returns a Map keyed by date string with lists of loaded items.
  Future<Map<String, List<FoodHomeLoaded>>> fetchFoodsByWeek(
    String startDateStr,
    String endDateStr,
  ) async {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return {};

    final rows = await supabase
        .from('food_schedule')
        .select('''
          id, is_completed, created_at, start_date,
          food:id_food (
            id, title, description, type_food, image_url,
            detail_food_ingredient (
              id, quantity,
              ingredient:id_ingredient (
                id, name, slug, calories, protein, fat, carbohydrates,
                base_quantity, unit, category
              )
            )
          )
        ''')
        .eq('id_user_profile', userId)
        .gte('start_date', startDateStr)
        .lte('start_date', endDateStr)
        .order('created_at', ascending: false);

    final result = <String, List<FoodHomeLoaded>>{};

    for (final row in rows) {
      final dateKey = row['start_date'] as String? ?? startDateStr;
      final loaded = _parseRow(row);
      if (loaded != null) {
        result.putIfAbsent(dateKey, () => []).add(loaded);
      }
    }

    return result;
  }

  FoodHomeLoaded? _parseRow(Map<String, dynamic> row) {
    final food = row['food'] as Map<String, dynamic>?;
    if (food == null) return null;

    final details = food['detail_food_ingredient'] as List<dynamic>? ?? [];

    // Build RecognizedIngredient list + compute totals in one pass.
    final ingredients = <RecognizedIngredient>[];
    var totalCal = 0.0;
    var totalProtein = 0.0;
    var totalCarbs = 0.0;
    var totalFat = 0.0;

    for (final detail in details) {
      final d = detail as Map<String, dynamic>;
      final qty = (d['quantity'] as num?)?.toDouble() ?? 0;
      final ing = d['ingredient'] as Map<String, dynamic>?;
      if (ing == null) continue;

      final baseQty = (ing['base_quantity'] as num?)?.toDouble() ?? 100;
      final cal = (ing['calories'] as num?)?.toDouble() ?? 0;
      final pro = (ing['protein'] as num?)?.toDouble() ?? 0;
      final fat = (ing['fat'] as num?)?.toDouble() ?? 0;
      final carb = (ing['carbohydrates'] as num?)?.toDouble() ?? 0;

      if (baseQty > 0) {
        totalCal += (cal * qty) / baseQty;
        totalProtein += (pro * qty) / baseQty;
        totalCarbs += (carb * qty) / baseQty;
        totalFat += (fat * qty) / baseQty;
      }

      ingredients.add(RecognizedIngredient(
        id: ing['id'] as String? ?? '',
        idDetailFoodIngredient: d['id'] as String? ?? '',
        name: ing['name'] as String? ?? '',
        slug: ing['slug'] as String? ?? '',
        calories: cal,
        fat: fat,
        carbohydrates: carb,
        protein: pro,
        unit: ing['unit'] as String? ?? 'grams',
        baseQuantity: baseQty,
        quantity: qty,
        category: ing['category'] as String?,
      ));
    }

    final createdAt = DateTime.tryParse(row['created_at'] as String? ?? '');
    final timeStr = createdAt != null
        ? '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}'
        : null;

    final scheduleId = row['id'] as String;
    final foodId = food['id'] as String;
    final title = food['title'] as String? ?? '';
    final description = food['description'] as String? ?? '';
    final imageUrl = food['image_url'] as String? ?? '';
    final typeFood = food['type_food'] as String? ?? 'snack';

    final mealItem = MealItem(
      id: foodId,
      name: title,
      description: description,
      calories: totalCal.round(),
      imageUrl: imageUrl,
      type: MealItemType.meal,
      protein: totalProtein.round(),
      carbs: totalCarbs.round(),
      fat: totalFat.round(),
      isCompleted: row['is_completed'] as bool? ?? false,
      time: timeStr,
    );

    final detail = FoodRecognitionResult(
      id: foodId,
      title: title,
      description: description,
      typeFood: typeFood,
      imageUrl: imageUrl,
      ingredients: ingredients,
    );

    return FoodHomeLoaded(
      mealItem: mealItem,
      foodId: foodId,
      scheduleId: scheduleId,
      detail: detail,
    );
  }

  Future<void> deleteFoodSchedule(String scheduleId) async {
    final supabase = Supabase.instance.client;
    await supabase.from('food_schedule').delete().eq('id', scheduleId);
  }

  /// Converts FoodHomeLoaded items to CachedFood for Isar storage.
  List<CachedFood> toCachedFoods(String dateKey, List<FoodHomeLoaded> items) {
    return items.map((item) {
      return CachedFood()
        ..dateKey = dateKey
        ..foodId = item.foodId
        ..scheduleId = item.scheduleId ?? ''
        ..name = item.mealItem.name
        ..description = item.mealItem.description
        ..calories = item.mealItem.calories
        ..protein = item.mealItem.protein
        ..carbs = item.mealItem.carbs
        ..fat = item.mealItem.fat
        ..imageUrl = item.mealItem.imageUrl
        ..isCompleted = item.mealItem.isCompleted
        ..typeFood = 'meal'
        ..time = item.mealItem.time;
    }).toList();
  }

  /// Converts CachedFood items back to FoodHomeLoaded.
  List<FoodHomeLoaded> fromCachedFoods(List<CachedFood> cached) {
    return cached.map((c) {
      final mealItem = MealItem(
        id: c.foodId,
        name: c.name,
        description: c.description,
        calories: c.calories,
        imageUrl: c.imageUrl,
        type: MealItemType.meal,
        protein: c.protein,
        carbs: c.carbs,
        fat: c.fat,
        isCompleted: c.isCompleted,
        time: c.time,
      );
      return FoodHomeLoaded(
        mealItem: mealItem,
        foodId: c.foodId,
        scheduleId: c.scheduleId.isNotEmpty ? c.scheduleId : null,
      );
    }).toList();
  }
}
