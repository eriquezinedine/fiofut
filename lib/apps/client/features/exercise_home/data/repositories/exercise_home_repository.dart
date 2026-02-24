import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/model/exercise_schedule_item.dart';

final exerciseHomeRepositoryProvider =
    Provider<ExerciseHomeRepository>((ref) {
  return ExerciseHomeRepository();
});

class ExerciseHomeRepository {
  ExerciseHomeRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  Future<List<ExerciseScheduleItem>> fetchExercisesForDate({
    required String userId,
    required DateTime date,
  }) async {
    final dateStr = date.toIso8601String().split('T').first;
    final dayOfWeek = date.weekday - 1; // 0=Mon to 6=Sun

    final rows = await _client
        .from('exercise_schedule')
        .select('''
          id, id_exercise, id_user_profile, id_created_by,
          schedule_type, start_date, end_date, days_of_week, notes, created_at,
          exercise:id_exercise (
            id, name, description, url_img_exercise, url_video_exercise, type_exercise, location, id_muscle
          ),
          exercise_set (
            id, set_number, repetitions, weight, minutes, seconds,
            distance, is_completed, completed_at
          )
        ''')
        .eq('id_user_profile', userId)
        .lte('start_date', dateStr)
        .order('created_at', ascending: false);

    // Filter: date within range AND day of week matches
    final items = <ExerciseScheduleItem>[];
    for (final row in rows) {
      final endDateStr = row['end_date'] as String?;
      if (endDateStr != null) {
        final endDate = DateTime.parse(endDateStr);
        if (date.isAfter(endDate.add(const Duration(days: 1)))) continue;
      }

      final daysOfWeek = row['days_of_week'] as String?;
      if (daysOfWeek != null && daysOfWeek.isNotEmpty) {
        final days = daysOfWeek.split(',').map(int.parse).toSet();
        if (!days.contains(dayOfWeek)) continue;
      }

      items.add(ExerciseScheduleItem.fromJson(row));
    }

    return items;
  }

  Future<void> deleteExerciseSchedule(String scheduleId) async {
    await _client.from('exercise_schedule').delete().eq('id', scheduleId);
  }

  Future<void> updateScheduleDates({
    required String scheduleId,
    required DateTime startDate,
    required DateTime endDate,
    required Set<int> daysOfWeek,
  }) async {
    final daysString = (daysOfWeek.toList()..sort()).join(',');
    await _client.from('exercise_schedule').update({
      'start_date': startDate.toIso8601String().split('T').first,
      'end_date': endDate.toIso8601String().split('T').first,
      'days_of_week': daysString,
    }).eq('id', scheduleId);
  }

  Future<ExerciseSetData> addSet({
    required String scheduleId,
    required int setNumber,
    int? repetitions,
    double? weight,
    int? minutes,
    int? seconds,
  }) async {
    final data = await _client
        .from('exercise_set')
        .insert({
          'id_exercise_schedule': scheduleId,
          'set_number': setNumber,
          'repetitions': repetitions,
          'weight': weight,
          'minutes': minutes,
          'seconds': seconds,
          'is_completed': false,
        })
        .select()
        .single();

    return ExerciseSetData.fromJson(data);
  }

  Future<void> toggleSetCompleted({
    required String setId,
    required bool isCompleted,
  }) async {
    await _client.from('exercise_set').update({
      'is_completed': isCompleted,
      'completed_at': isCompleted ? DateTime.now().toIso8601String() : null,
    }).eq('id', setId);
  }
}
