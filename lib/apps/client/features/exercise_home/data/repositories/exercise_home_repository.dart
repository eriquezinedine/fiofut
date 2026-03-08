import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:model/model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/model/exercise.dart';
import '../../domain/model/exercise_schedule_item.dart';
import '../local/pending_schedule.dart';

final exerciseHomeRepositoryProvider =
    Provider<ExerciseHomeRepository>((ref) {
  return ExerciseHomeRepository();
});

class ExerciseHomeRepository {
  ExerciseHomeRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  // ── Fetch ─────────────────────────────────────────────────────────

  Future<List<ExerciseScheduleItem>> fetchExercisesForDate({
    required String userId,
    required DateTime date,
  }) async {
    final dateStr = date.toIso8601String().split('T').first;
    final dayOfWeek = date.weekday - 1;

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

  // ── Schedule CRUD ─────────────────────────────────────────────────

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
    final daysStr = isWeekly ? (daysOfWeek.toList()..sort()).join(',') : null;

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

  // ── Set CRUD ──────────────────────────────────────────────────────

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

  Future<void> markAllSetsCompleted(String scheduleId) async {
    await _client.from('exercise_set').update({
      'is_completed': true,
      'completed_at': DateTime.now().toIso8601String(),
    }).eq('id_exercise_schedule', scheduleId);
  }

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

  Future<void> deleteSet(String setId) async {
    await _client.from('exercise_set').delete().eq('id', setId);
  }

  // ── Exercise Catalog ──────────────────────────────────────────────

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

  // ── Pending Schedule Builders ─────────────────────────────────────

  /// Creates PendingSchedule objects from exercises for local storage.
  List<PendingSchedule> buildPendingSchedules({
    required List<Exercise> exercises,
    required String userId,
    required DateTime date,
    Set<int>? daysOfWeek,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final isWeekly = daysOfWeek != null && daysOfWeek.isNotEmpty;
    final dateStr = date.toIso8601String().split('T').first;
    final now = DateTime.now();

    return exercises.map((exercise) {
      final tempId = 'pending_${now.millisecondsSinceEpoch}_${exercise.id}';
      final type = exerciseTypeString(exercise.metricType);

      return PendingSchedule()
        ..tempId = tempId
        ..exerciseId = exercise.id
        ..exerciseName = exercise.title
        ..exerciseDescription = exercise.description
        ..exerciseImageUrl = exercise.imageUrl
        ..exerciseVideoUrl = exercise.videoUrl
        ..exerciseType = type
        ..userId = userId
        ..dateStr = dateStr
        ..scheduleType = isWeekly ? 'weekly' : 'custom'
        ..daysOfWeek =
            isWeekly ? (daysOfWeek.toList()..sort()).join(',') : null
        ..startDateStr = isWeekly
            ? (startDate ?? date).toIso8601String().split('T').first
            : null
        ..endDateStr = isWeekly
            ? (endDate ?? date).toIso8601String().split('T').first
            : null
        ..createdAt = now;
    }).toList();
  }

  /// Converts PendingSchedule to ExerciseScheduleItem for UI display.
  ExerciseScheduleItem pendingToScheduleItem(PendingSchedule p) {
    final sets = _buildDefaultSets(p.tempId, p.exerciseType);

    return ExerciseScheduleItem(
      scheduleId: p.tempId,
      exerciseId: p.exerciseId,
      exerciseName: p.exerciseName,
      exerciseDescription: p.exerciseDescription,
      exerciseImageUrl: p.exerciseImageUrl,
      exerciseVideoUrl: p.exerciseVideoUrl,
      exerciseType: p.exerciseType,
      sets: sets,
      daysOfWeek: p.daysOfWeek,
      startDate: p.startDateStr != null
          ? DateTime.parse(p.startDateStr!)
          : DateTime.parse(p.dateStr),
      endDate: p.endDateStr != null
          ? DateTime.parse(p.endDateStr!)
          : DateTime.parse(p.dateStr),
    );
  }

  /// Converts PendingSchedule to Exercise for syncing.
  Exercise pendingToExercise(PendingSchedule p) {
    return Exercise(
      id: p.exerciseId,
      title: p.exerciseName,
      description: p.exerciseDescription ?? '',
      imageUrl: p.exerciseImageUrl,
      videoUrl: p.exerciseVideoUrl,
      muscleMain: const Muscle(
        id: '',
        name: '',
        isMain: true,
        muscleGroup: MuscleGroup.chest,
      ),
      muscleSecundaries: const [],
      instruccion: '',
      currentValue: 0,
      targetValue: 0,
      metricType: metricTypeFromString(p.exerciseType),
      status: ExerciseStatus.pending,
    );
  }

  /// Computes next set values based on existing sets.
  ({int? reps, double? weight, int? mins, int? secs}) computeNextSetValues(
    List<ExerciseSetData> existingSets,
    String exerciseType,
  ) {
    if (existingSets.isEmpty) {
      return switch (exerciseType) {
        'strength' => (reps: 10, weight: 0.0, mins: null, secs: null),
        'cardio' => (reps: null, weight: 0.0, mins: 5, secs: 0),
        _ => (reps: 10, weight: null, mins: null, secs: null),
      };
    }

    final last = existingSets.last;
    return switch (exerciseType) {
      'strength' => (
          reps: last.repetitions ?? 10,
          weight: last.weight ?? 0.0,
          mins: null,
          secs: null
        ),
      'cardio' => (
          reps: null,
          weight: last.weight ?? 0.0,
          mins: last.minutes ?? 5,
          secs: last.seconds ?? 0
        ),
      _ => (reps: last.repetitions ?? 10, weight: null, mins: null, secs: null),
    };
  }

  /// Builds updated item with new set added.
  ExerciseScheduleItem addSetToItem(
    ExerciseScheduleItem item,
    ExerciseSetData newSet,
  ) {
    return ExerciseScheduleItem(
      scheduleId: item.scheduleId,
      exerciseId: item.exerciseId,
      exerciseName: item.exerciseName,
      exerciseDescription: item.exerciseDescription,
      exerciseImageUrl: item.exerciseImageUrl,
      exerciseVideoUrl: item.exerciseVideoUrl,
      exerciseType: item.exerciseType,
      sets: [...item.sets, newSet],
      daysOfWeek: item.daysOfWeek,
      startDate: item.startDate,
      endDate: item.endDate,
      createdById: item.createdById,
      notes: item.notes,
    );
  }

  /// Builds updated item with set completion toggled.
  ExerciseScheduleItem toggleSetInItem(
    ExerciseScheduleItem item,
    String setId,
    bool isCompleted,
  ) {
    final updatedSets = item.sets.map((s) {
      if (s.id != setId) return s;
      return ExerciseSetData(
        id: s.id,
        setNumber: s.setNumber,
        repetitions: s.repetitions,
        weight: s.weight,
        minutes: s.minutes,
        seconds: s.seconds,
        distance: s.distance,
        isCompleted: isCompleted,
        completedAt: isCompleted ? DateTime.now() : null,
        setType: s.setType,
      );
    }).toList();

    return ExerciseScheduleItem(
      scheduleId: item.scheduleId,
      exerciseId: item.exerciseId,
      exerciseName: item.exerciseName,
      exerciseDescription: item.exerciseDescription,
      exerciseImageUrl: item.exerciseImageUrl,
      exerciseVideoUrl: item.exerciseVideoUrl,
      exerciseType: item.exerciseType,
      sets: updatedSets,
      daysOfWeek: item.daysOfWeek,
      startDate: item.startDate,
      endDate: item.endDate,
      createdById: item.createdById,
      notes: item.notes,
    );
  }

  // ── Private Helpers ───────────────────────────────────────────────

  List<ExerciseSetData> _buildDefaultSets(String tempId, String exerciseType) {
    return List.generate(
      3,
      (i) => ExerciseSetData(
        id: '${tempId}_set_$i',
        setNumber: i + 1,
        repetitions: exerciseType != 'cardio' ? 10 : null,
        weight: exerciseType == 'strength' ? 0.0 : null,
        minutes: exerciseType == 'cardio' ? 5 : null,
        seconds: exerciseType == 'cardio' ? 0 : null,
        isCompleted: false,
      ),
    );
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

  static MetricType metricTypeFromString(String type) => switch (type) {
        'cardio' => MetricType.distance,
        'strength' => MetricType.weight,
        _ => MetricType.reps,
      };
}
