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
            distance, set_type, session_date, is_completed, completed_at
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

      // Filter sets for this specific date
      final allSets = row['exercise_set'] as List<dynamic>? ?? [];
      final setsForDate = allSets.where((s) {
        final sd = (s as Map<String, dynamic>)['session_date'];
        return sd == dateStr;
      }).toList();

      // On-demand creation: if schedule matches but has no sets for this date
      if (setsForDate.isEmpty) {
        final exerciseType = (row['exercise'] as Map<String, dynamic>?)?['type_exercise'] as String? ?? 'strength';
        final newSets = await createSetsForDate(
          scheduleId: row['id'] as String,
          sessionDate: date,
          exerciseType: exerciseType,
        );
        row['exercise_set'] = newSets.map((s) => {
          'id': s.id,
          'set_number': s.setNumber,
          'repetitions': s.repetitions,
          'weight': s.weight,
          'minutes': s.minutes,
          'seconds': s.seconds,
          'distance': s.distance,
          'set_type': s.setType.name,
          'session_date': s.sessionDate.toIso8601String().split('T').first,
          'is_completed': s.isCompleted,
          'completed_at': s.completedAt?.toIso8601String(),
        }).toList();
      } else {
        row['exercise_set'] = setsForDate;
      }

      items.add(_parseSchedule(row));
    }

    return items;
  }

  /// Parses a schedule row with sets already filtered by date.
  ExerciseScheduleItem _parseSchedule(Map<String, dynamic> json) {
    final exercise = json['exercise'] as Map<String, dynamic>?;
    final setsData = json['exercise_set'] as List<dynamic>? ?? [];
    final muscle = exercise?['muscle'] as Map<String, dynamic>?;

    final sets = setsData
        .map((s) => ExerciseSetData.fromJson(s as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => a.setNumber.compareTo(b.setNumber));

    return ExerciseScheduleItem(
      scheduleId: json['id'] as String,
      exerciseId: json['id_exercise'] as String,
      exerciseName: exercise?['name'] as String? ?? 'Ejercicio',
      exerciseDescription: exercise?['description'] as String?,
      exerciseImageUrl: exercise?['url_img_exercise'] as String?,
      exerciseVideoUrl: exercise?['url_video_exercise'] as String?,
      typeExercise: exercise?['type_exercise'] != null
          ? metricTypeFromString(exercise!['type_exercise'] as String)
          : null,
      sets: sets,
      daysOfWeek: json['days_of_week'] as String?,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'] as String)
          : null,
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'] as String)
          : null,
      createdById: json['id_created_by'] as String?,
      notes: json['notes'] as String?,
      muscleId: muscle?['id'] as String?,
      muscleName: muscle?['name'] as String?,
      muscleGroup: muscle?['muscle_group'] as String?,
    );
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
    final dateStr = date.toIso8601String().split('T').first;
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
            'session_date': dateStr,
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
    required DateTime sessionDate,
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
          'session_date': sessionDate.toIso8601String().split('T').first,
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

  Future<void> markAllSetsCompleted(String scheduleId, DateTime sessionDate) async {
    final dateStr = sessionDate.toIso8601String().split('T').first;
    await _client.from('exercise_set').update({
      'is_completed': true,
      'completed_at': DateTime.now().toIso8601String(),
    })
    .eq('id_exercise_schedule', scheduleId)
    .eq('session_date', dateStr);
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

  /// Batch: completa o descompleta múltiples series en 1 query.
  Future<void> batchToggleCompleted({
    required List<String> setIds,
    required bool isCompleted,
  }) async {
    if (setIds.isEmpty) return;
    await _client.from('exercise_set').update({
      'is_completed': isCompleted,
      'completed_at': isCompleted ? DateTime.now().toIso8601String() : null,
    }).inFilter('id', setIds);
  }

  /// Batch: actualiza valores (reps, weight, mins, secs) de múltiples series en 1 query.
  /// Solo actualiza los campos que no son null.
  Future<void> batchSyncValues({
    required List<String> setIds,
    int? repetitions,
    double? weight,
    int? minutes,
    int? seconds,
    double? distance,
  }) async {
    if (setIds.isEmpty) return;
    final data = <String, dynamic>{};
    if (repetitions != null) data['repetitions'] = repetitions;
    if (weight != null) data['weight'] = weight;
    if (minutes != null) data['minutes'] = minutes;
    if (seconds != null) data['seconds'] = seconds;
    if (distance != null) data['distance'] = distance;
    if (data.isEmpty) return;
    await _client.from('exercise_set').update(data).inFilter('id', setIds);
  }

  Future<void> deleteSet(String setId) async {
    await _client.from('exercise_set').delete().eq('id', setId);
  }

  // ── On-demand set creation ────────────────────────────────────────

  Future<List<ExerciseSetData>> createSetsForDate({
    required String scheduleId,
    required DateTime sessionDate,
    required String exerciseType,
  }) async {
    final dateStr = sessionDate.toIso8601String().split('T').first;

    // Find most recent sets for this schedule (any date)
    final recentSets = await _client
        .from('exercise_set')
        .select()
        .eq('id_exercise_schedule', scheduleId)
        .not('session_date', 'is', null)
        .order('session_date', ascending: false)
        .order('set_number', ascending: true)
        .limit(20);

    List<Map<String, dynamic>> setsToInsert;

    if (recentSets.isNotEmpty) {
      final mostRecentDate = recentSets.first['session_date'];
      final templateSets = recentSets
          .where((s) => s['session_date'] == mostRecentDate)
          .toList();

      setsToInsert = templateSets.map((s) => <String, dynamic>{
        'id_exercise_schedule': scheduleId,
        'set_number': s['set_number'],
        'repetitions': s['repetitions'],
        'weight': s['weight'],
        'minutes': s['minutes'],
        'seconds': s['seconds'],
        'set_type': s['set_type'] ?? 'normal',
        'session_date': dateStr,
        'is_completed': false,
      }).toList();
    } else {
      setsToInsert = List.generate(3, (i) => <String, dynamic>{
        'id_exercise_schedule': scheduleId,
        'set_number': i + 1,
        'repetitions': exerciseType != 'cardio' ? 10 : null,
        'weight': exerciseType == 'strength' ? 0.0 : null,
        'minutes': exerciseType == 'cardio' ? 5 : null,
        'seconds': exerciseType == 'cardio' ? 0 : null,
        'session_date': dateStr,
        'is_completed': false,
      });
    }

    final inserted = await _client
        .from('exercise_set')
        .insert(setsToInsert)
        .select();

    return inserted
        .map((s) => ExerciseSetData.fromJson(s as Map<String, dynamic>))
        .toList();
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

  ExerciseScheduleItem pendingToScheduleItem(PendingSchedule p) {
    final sessionDate = DateTime.parse(p.dateStr);
    final sets = _buildDefaultSets(p.tempId, p.exerciseType, sessionDate);

    return ExerciseScheduleItem(
      scheduleId: p.tempId,
      exerciseId: p.exerciseId,
      exerciseName: p.exerciseName,
      exerciseDescription: p.exerciseDescription,
      exerciseImageUrl: p.exerciseImageUrl,
      exerciseVideoUrl: p.exerciseVideoUrl,
      typeExercise: metricTypeFromString(p.exerciseType),
      sets: sets,
      daysOfWeek: p.daysOfWeek,
      startDate: p.startDateStr != null
          ? DateTime.parse(p.startDateStr!)
          : sessionDate,
      endDate: p.endDateStr != null
          ? DateTime.parse(p.endDateStr!)
          : sessionDate,
    );
  }

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

  // ── Private Helpers ───────────────────────────────────────────────

  List<ExerciseSetData> _buildDefaultSets(String tempId, String exerciseType, DateTime sessionDate) {
    return List.generate(
      3,
      (i) => ExerciseSetData(
        id: '${tempId}_set_$i',
        setNumber: i + 1,
        sessionDate: sessionDate,
        repetitions: exerciseType != 'cardio' ? 10 : null,
        weight: exerciseType == 'strength' ? 0.0 : null,
        minutes: exerciseType == 'cardio' ? 5 : null,
        seconds: exerciseType == 'cardio' ? 0 : null,
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
      'cardio' => MetricType.cardio,
      'strength' => MetricType.strength,
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
        MetricType.cardio => 'cardio',
        MetricType.strength => 'strength',
        MetricType.reps => 'reps',
      };

  static MetricType metricTypeFromString(String type) => switch (type) {
        'cardio' => MetricType.cardio,
        'strength' => MetricType.strength,
        _ => MetricType.reps,
      };
}
