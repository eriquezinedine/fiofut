import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/ingredient.dart';

final ingredientsRepositoryProvider = Provider<IngredientsRepository>((ref) {
  return IngredientsRepository();
});

class IngredientsRepository {
  IngredientsRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<Ingredient>> getIngredients() async {
    final data = await _client
        .from('ingredient')
        .select()
        .order('name', ascending: true);

    return data.map((json) => Ingredient.fromJson(json)).toList();
  }

  Future<Ingredient> getIngredientById(String id) async {
    final data =
        await _client.from('ingredient').select().eq('id', id).single();

    return Ingredient.fromJson(data);
  }

  Future<Ingredient> createIngredient(Ingredient ingredient) async {
    final data = await _client
        .from('ingredient')
        .insert(ingredient.toJson())
        .select()
        .single();

    return Ingredient.fromJson(data);
  }

  Future<Ingredient> updateIngredient(String id, Ingredient ingredient) async {
    final data = await _client
        .from('ingredient')
        .update(ingredient.toJson())
        .eq('id', id)
        .select()
        .single();

    return Ingredient.fromJson(data);
  }

  Future<void> deleteIngredient(String id) async {
    await _client.from('ingredient').delete().eq('id', id);
  }

  Future<List<Ingredient>> searchIngredients(String query) async {
    final data = await _client
        .from('ingredient')
        .select()
        .ilike('name', '%$query%')
        .order('name', ascending: true);

    return data.map((json) => Ingredient.fromJson(json)).toList();
  }
}
