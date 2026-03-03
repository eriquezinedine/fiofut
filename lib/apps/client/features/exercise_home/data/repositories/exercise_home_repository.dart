import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:model/model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/model/exercise.dart';
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
            id, name, description, url_img_exercise, url_video_exercise, type_exercise, location, id_muscle,
            muscle:id_muscle (id, name, is_main, muscle_group)
          ),
          exercise_set (
            id, set_number, repetitions, weight, minutes, seconds,
            distance, is_completed, completed_at, set_type
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

  /// Marks all sets for a given schedule as completed in one call.
  Future<void> markAllSetsCompleted(String scheduleId) async {
    await _client.from('exercise_set').update({
      'is_completed': true,
      'completed_at': DateTime.now().toIso8601String(),
    }).eq('id_exercise_schedule', scheduleId);
  }

  /// Syncs a set's full state (values + completion + type) to Supabase.
  Future<void> syncSet({
    required String setId,
    int? repetitions,
    double? weight,
    int? minutes,
    int? seconds,
    required bool isCompleted,
    String setType = 'normal',
  }) async {
    await _client.from('exercise_set').update({
      'repetitions': repetitions,
      'weight': weight,
      'minutes': minutes,
      'seconds': seconds,
      'is_completed': isCompleted,
      'completed_at': isCompleted ? DateTime.now().toIso8601String() : null,
      'set_type': setType,
    }).eq('id', setId);
  }

  /// Deletes a single set.
  Future<void> deleteSet(String setId) async {
    await _client.from('exercise_set').delete().eq('id', setId);
  }

  /// Fetches paginated exercises for the catalog with optional search/filter.
  Future<({List<Exercise> exercises, bool hasMore})> fetchExercises({
    String query = '',
    String? muscleGroupFilter,
    int page = 0,
    int pageSize = 25,
  }) async {
    final muscleSelect = muscleGroupFilter != null
        ? '*, muscle:id_muscle!inner(*)'
        : '*, muscle:id_muscle(*)';

    var builder = _client.from('exercise').select(muscleSelect);

    if (query.isNotEmpty) {
      builder = builder.ilike('name', '%$query%');
    }
    if (muscleGroupFilter != null) {
      builder = builder.eq('muscle.muscle_group', muscleGroupFilter);
    }

    final data = await builder
        .order('name')
        .range(page * pageSize, (page + 1) * pageSize - 1);

    return (
      exercises: data.map(_toClientExercise).toList(),
      hasMore: data.length == pageSize,
    );
  }

  /// Schedules selected exercises with 3 default sets each.
  ///
  /// For "today" scheduling: only [date] is used.
  /// For "weekly" scheduling: provide [daysOfWeek], [startDate], [endDate].
  Future<void> scheduleExercises({
    required String userId,
    required List<Exercise> exercises,
    required DateTime date,
    Set<int>? daysOfWeek,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final isWeekly = daysOfWeek != null && daysOfWeek.isNotEmpty;
    final start = (isWeekly ? startDate ?? date : date)
        .toIso8601String()
        .split('T')
        .first;
    final end = (isWeekly ? endDate ?? date : date)
        .toIso8601String()
        .split('T')
        .first;
    final daysStr = isWeekly
        ? (daysOfWeek.toList()..sort()).join(',')
        : null;

    for (final exercise in exercises) {
      final schedule = await _client
          .from('exercise_schedule')
          .insert({
            'id_user_profile': userId,
            'id_exercise': exercise.id,
            'id_created_by': userId,
            'schedule_type': isWeekly ? 'weekly' : 'custom',
            'start_date': start,
            'end_date': end,
            'days_of_week': daysStr,
          })
          .select('id')
          .single();

      final scheduleId = schedule['id'] as String;
      final type = exerciseTypeString(exercise.metricType);

      await _client.from('exercise_set').insert(
        List.generate(
          3,
          (i) => <String, dynamic>{
            'id_exercise_schedule': scheduleId,
            'set_number': i + 1,
            'repetitions': type != 'cardio' ? 10 : null,
            'weight': type == 'strength' ? 0.0 : null,
            'minutes': type == 'cardio' ? 5 : null,
            'seconds': type == 'cardio' ? 0 : null,
            'is_completed': false,
          },
        ),
      );
    }
  }

  static Exercise _toClientExercise(Map<String, dynamic> row) {
    final muscleData = row['muscle'] as Map<String, dynamic>?;
    final muscleMain = muscleData != null
        ? Muscle.fromJson(muscleData)
        : const Muscle(
            id: '',
            name: '',
            isMain: true,
            muscleGroup: MuscleGroup.chest,
          );

    final typeStr = row['type_exercise'] as String? ?? 'strength';
    final metricType = switch (typeStr) {
      'cardio' => MetricType.distance,
      'strength' => MetricType.weight,
      _ => MetricType.reps,
    };

    return Exercise(
      id: row['id'] as String,
      title: row['name'] as String,
      description: row['description'] as String? ?? '',
      imageUrl: row['url_img_exercise'] as String?,
      videoUrl: row['url_video_exercise'] as String?,
      muscleMain: muscleMain,
      muscleSecundaries: const [],
      instruccion: '',
      currentValue: 0,
      targetValue: 0,
      metricType: metricType,
      status: ExerciseStatus.pending,
    );
  }

  static String exerciseTypeString(MetricType type) => switch (type) {
        MetricType.distance || MetricType.time => 'cardio',
        MetricType.weight => 'strength',
        MetricType.reps => 'reps',
      };
}
