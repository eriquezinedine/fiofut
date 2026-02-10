import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/meal.dart';

final mealsRepositoryProvider = Provider<MealsRepository>((ref) {
  return MealsRepository();
});

class MealsRepository {
  MealsRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<Meal>> getMeals() async {
    final data = await _client
        .from('meals')
        .select()
        .order('created_at', ascending: false);

    return data.map((json) => Meal.fromJson(json)).toList();
  }

  Future<Meal> getMealById(String id) async {
    final data = await _client.from('meals').select().eq('id', id).single();

    return Meal.fromJson(data);
  }

  Future<Meal> createMeal(Meal meal) async {
    final userId = _client.auth.currentUser!.id;
    final data = await _client
        .from('meals')
        .insert({
          ...meal.toJson(),
          'created_by': userId,
        })
        .select()
        .single();

    return Meal.fromJson(data);
  }

  Future<Meal> updateMeal(String id, Meal meal) async {
    final data = await _client
        .from('meals')
        .update(meal.toJson())
        .eq('id', id)
        .select()
        .single();

    return Meal.fromJson(data);
  }

  Future<void> deleteMeal(String id) async {
    await _client.from('meals').delete().eq('id', id);
  }

  Future<List<Meal>> searchMeals(String query) async {
    final data = await _client
        .from('meals')
        .select()
        .ilike('name', '%$query%')
        .order('created_at', ascending: false);

    return data.map((json) => Meal.fromJson(json)).toList();
  }
}
