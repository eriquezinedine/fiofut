import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:model/model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final reposeRepositoryProvider = Provider<ReposeRepository>((ref) {
  return ReposeRepository();
});

class ReposeRepository {
  ReposeRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  /// Carga todos los porcentajes de recuperacion del usuario.
  Future<List<({MuscleGroup group, int percentage, DateTime? updatedAt})>> fetchAll(
      String userId) async {
    final data = await _client
        .from('muscle_repose')
        .select('muscle_group, percentage, updated_at')
        .eq('user_id', userId);

    return (data as List).map((row) {
      return (
        group: MuscleGroup.fromJson(row['muscle_group'] as String),
        percentage: (row['percentage'] as num).toInt(),
        updatedAt: row['updated_at'] != null
            ? DateTime.parse(row['updated_at'] as String)
            : null,
      );
    }).toList();
  }

  /// Upsert: actualiza o crea el porcentaje de un musculo.
  Future<void> upsertMuscleProgress({
    required String userId,
    required MuscleGroup group,
    required int percentage,
  }) async {
    await _client.from('muscle_repose').upsert(
      {
        'user_id': userId,
        'muscle_group': group.toJson(),
        'percentage': percentage.clamp(0, 100),
        'updated_at': DateTime.now().toIso8601String(),
      },
      onConflict: 'user_id,muscle_group',
    );
  }

  /// Batch upsert: reiniciar todos los musculos a 100%.
  Future<void> resetAll(String userId) async {
    final rows = MuscleGroup.values
        .map((g) => {
              'user_id': userId,
              'muscle_group': g.toJson(),
              'percentage': 100,
              'updated_at': DateTime.now().toIso8601String(),
            })
        .toList();

    await _client.from('muscle_repose').upsert(
      rows,
      onConflict: 'user_id,muscle_group',
    );
  }
}
