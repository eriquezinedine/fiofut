import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/exercise.dart';

final exercisesRepositoryProvider = Provider<ExercisesRepository>((ref) {
  return ExercisesRepository();
});

class ExercisesRepository {
  ExercisesRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<Exercise>> getExercises() async {
    final data = await _client
        .from('exercises')
        .select()
        .order('created_at', ascending: false);

    return data.map((json) => Exercise.fromJson(json)).toList();
  }

  Future<Exercise> getExerciseById(String id) async {
    final data =
        await _client.from('exercises').select().eq('id', id).single();

    return Exercise.fromJson(data);
  }

  Future<Exercise> createExercise(Exercise exercise) async {
    final userId = _client.auth.currentUser!.id;
    final data = await _client
        .from('exercises')
        .insert({
          ...exercise.toJson(),
          'created_by': userId,
        })
        .select()
        .single();

    return Exercise.fromJson(data);
  }

  Future<Exercise> updateExercise(String id, Exercise exercise) async {
    final data = await _client
        .from('exercises')
        .update(exercise.toJson())
        .eq('id', id)
        .select()
        .single();

    return Exercise.fromJson(data);
  }

  Future<void> deleteExercise(String id) async {
    await _client.from('exercises').delete().eq('id', id);
  }

  Future<List<Exercise>> searchExercises(String query) async {
    final data = await _client
        .from('exercises')
        .select()
        .ilike('name', '%$query%')
        .order('created_at', ascending: false);

    return data.map((json) => Exercise.fromJson(json)).toList();
  }
}
