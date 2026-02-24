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
        .from('exercise')
        .select('*, exercise_secondary_muscle(muscle_id)')
        .order('created_at', ascending: false);

    return data.map((json) => _parseWithSecondary(json)).toList();
  }

  Future<Exercise> getExerciseById(String id) async {
    final data = await _client
        .from('exercise')
        .select('*, exercise_secondary_muscle(muscle_id)')
        .eq('id', id)
        .single();

    return _parseWithSecondary(data);
  }

  Future<Exercise> createExercise(Exercise exercise) async {
    final data = await _client
        .from('exercise')
        .insert(exercise.toJson())
        .select()
        .single();

    final exerciseId = data['id'] as String;

    // Insert secondary muscles
    if (exercise.secondaryMuscleIds.isNotEmpty) {
      await _syncSecondaryMuscles(exerciseId, exercise.secondaryMuscleIds);
    }

    return Exercise.fromJson({...data, '_secondary_muscle_ids': exercise.secondaryMuscleIds});
  }

  Future<Exercise> updateExercise(String id, Exercise exercise) async {
    final data = await _client
        .from('exercise')
        .update(exercise.toJson())
        .eq('id', id)
        .select()
        .single();

    // Sync secondary muscles
    await _syncSecondaryMuscles(id, exercise.secondaryMuscleIds);

    return Exercise.fromJson({...data, '_secondary_muscle_ids': exercise.secondaryMuscleIds});
  }

  Future<void> deleteExercise(String id) async {
    await _client.from('exercise').delete().eq('id', id);
  }

  Future<List<Exercise>> searchExercises(String query) async {
    final data = await _client
        .from('exercise')
        .select('*, exercise_secondary_muscle(muscle_id)')
        .ilike('name', '%$query%')
        .order('created_at', ascending: false);

    return data.map((json) => _parseWithSecondary(json)).toList();
  }

  // ── Helpers ──

  Exercise _parseWithSecondary(Map<String, dynamic> json) {
    final secondaryRows =
        json['exercise_secondary_muscle'] as List<dynamic>? ?? [];
    final secondaryIds = secondaryRows
        .map((e) => (e as Map<String, dynamic>)['muscle_id'] as String)
        .toList();
    return Exercise.fromJson({...json, '_secondary_muscle_ids': secondaryIds});
  }

  Future<void> _syncSecondaryMuscles(
      String exerciseId, List<String> muscleIds) async {
    // Delete existing
    await _client
        .from('exercise_secondary_muscle')
        .delete()
        .eq('exercise_id', exerciseId);

    // Insert new
    if (muscleIds.isNotEmpty) {
      final rows = muscleIds
          .map((mid) => {
                'exercise_id': exerciseId,
                'muscle_id': mid,
              })
          .toList();
      await _client.from('exercise_secondary_muscle').insert(rows);
    }
  }
}
