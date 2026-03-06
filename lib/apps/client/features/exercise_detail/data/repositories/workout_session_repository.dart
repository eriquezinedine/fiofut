import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final workoutSessionRepositoryProvider =
    Provider<WorkoutSessionRepository>((ref) {
  return WorkoutSessionRepository();
});

class WorkoutSessionRepository {
  WorkoutSessionRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  /// Upserts a session for the given user and date.
  /// Returns the session id.
  Future<String> upsertSession({
    required String userId,
    required DateTime date,
    DateTime? startedAt,
    int? elapsedSeconds,
    int? exercisesCompleted,
    int? totalExercises,
  }) async {
    final dateStr = date.toIso8601String().split('T').first;

    final data = await _client
        .from('workout_session')
        .upsert(
          {
            'id_user_profile': userId,
            'session_date': dateStr,
            if (startedAt != null)
              'started_at': startedAt.toIso8601String(),
            if (elapsedSeconds != null) 'elapsed_seconds': elapsedSeconds,
            if (exercisesCompleted != null)
              'exercises_completed': exercisesCompleted,
            if (totalExercises != null) 'total_exercises': totalExercises,
          },
          onConflict: 'id_user_profile,session_date',
        )
        .select('id')
        .single();

    return data['id'] as String;
  }

  /// Gets the session for a given date (null if none).
  Future<Map<String, dynamic>?> getSessionForDate({
    required String userId,
    required DateTime date,
  }) async {
    final dateStr = date.toIso8601String().split('T').first;

    final rows = await _client
        .from('workout_session')
        .select()
        .eq('id_user_profile', userId)
        .eq('session_date', dateStr)
        .limit(1);

    return rows.isEmpty ? null : rows.first;
  }

  /// Updates only the elapsed seconds for a session.
  Future<void> updateElapsedSeconds({
    required String sessionId,
    required int seconds,
  }) async {
    await _client.from('workout_session').update({
      'elapsed_seconds': seconds,
    }).eq('id', sessionId);
  }

  /// Finishes the session.
  Future<void> finishSession({
    required String sessionId,
    required int elapsedSeconds,
    required int exercisesCompleted,
  }) async {
    await _client.from('workout_session').update({
      'finished_at': DateTime.now().toIso8601String(),
      'elapsed_seconds': elapsedSeconds,
      'exercises_completed': exercisesCompleted,
    }).eq('id', sessionId);
  }

  /// Updates the photo URL for a session.
  Future<void> updatePhoto({
    required String sessionId,
    required String photoUrl,
  }) async {
    await _client.from('workout_session').update({
      'photo_url': photoUrl,
    }).eq('id', sessionId);
  }
}
