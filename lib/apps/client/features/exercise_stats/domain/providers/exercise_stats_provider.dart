import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:model/model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

sealed class ExerciseStatsState {
  const ExerciseStatsState();
}

class ExerciseStatsInitial extends ExerciseStatsState {
  const ExerciseStatsInitial();
}

class ExerciseStatsLoading extends ExerciseStatsState {
  const ExerciseStatsLoading();
}

class ExerciseStatsLoaded extends ExerciseStatsState {
  const ExerciseStatsLoaded({
    required this.exerciseId,
    required this.exerciseName,
    required this.weightHistory,
    required this.repsHistory,
  });

  final String exerciseId;
  final String exerciseName;
  final List<ExerciseStatsData> weightHistory;
  final List<ExerciseStatsData> repsHistory;
}

class ExerciseStatsError extends ExerciseStatsState {
  const ExerciseStatsError({required this.message});
  final String message;
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class ExerciseStatsNotifier extends StateNotifier<ExerciseStatsState> {
  ExerciseStatsNotifier() : super(const ExerciseStatsInitial());

  final _client = Supabase.instance.client;

  List<Map<String, dynamic>> _allRows = [];
  String _exerciseId = '';
  String _exerciseName = '';
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  Future<void> load(String exerciseId, String exerciseName) async {
    state = const ExerciseStatsLoading();
    _exerciseId = exerciseId;
    _exerciseName = exerciseName;

    try {
      final schedules = await _client
          .from('exercise_schedule')
          .select('id')
          .eq('id_exercise', exerciseId);

      final scheduleIds =
          (schedules as List).map((s) => s['id'] as String).toList();

      if (scheduleIds.isEmpty) {
        state = ExerciseStatsLoaded(
          exerciseId: exerciseId,
          exerciseName: exerciseName,
          weightHistory: const [],
          repsHistory: const [],
        );
        return;
      }

      final rows = await _client
          .from('exercise_set')
          .select(
              'id, weight, repetitions, distance, session_date, is_completed')
          .inFilter('id_exercise_schedule', scheduleIds)
          .eq('is_completed', true)
          .order('session_date', ascending: true);

      _allRows = List<Map<String, dynamic>>.from(rows as List);
      _recompute();
    } catch (e) {
      state =
          ExerciseStatsError(message: 'Error al cargar estadísticas: $e');
    }
  }

  void setDateRange(DateTime start, DateTime end) {
    _rangeStart = start;
    _rangeEnd = end;
    if (state is ExerciseStatsLoaded) {
      _recompute();
    }
  }

  void _recompute() {
    final filtered = _rangeStart != null && _rangeEnd != null
        ? _allRows.where((row) {
            final dateStr = row['session_date'] as String? ?? '';
            if (dateStr.isEmpty) return false;
            final date = DateTime.tryParse(dateStr);
            if (date == null) return false;
            return !date.isBefore(_rangeStart!) &&
                date.isBefore(_rangeEnd!.add(const Duration(days: 1)));
          }).toList()
        : _allRows;

    final maxWeightByDate = <String, double>{};
    final repsSumByDate = <String, double>{};
    final repsCountByDate = <String, int>{};

    for (final row in filtered) {
      final date = row['session_date'] as String? ?? '';
      if (date.isEmpty) continue;

      final weight = (row['weight'] as num?)?.toDouble() ?? 0;
      final reps = (row['repetitions'] as num?)?.toDouble() ?? 0;

      maxWeightByDate[date] =
          math.max(maxWeightByDate[date] ?? 0, weight);
      repsSumByDate[date] = (repsSumByDate[date] ?? 0) + reps;
      repsCountByDate[date] = (repsCountByDate[date] ?? 0) + 1;
    }

    final weightHistory = _toChartData(maxWeightByDate);
    final repsHistory = <ExerciseStatsData>[];
    for (final entry in (repsSumByDate.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key)))) {
      final count = repsCountByDate[entry.key] ?? 1;
      repsHistory.add(ExerciseStatsData(
        date: DateTime.tryParse(entry.key) ?? DateTime.now(),
        value: entry.value / count,
      ));
    }

    state = ExerciseStatsLoaded(
      exerciseId: _exerciseId,
      exerciseName: _exerciseName,
      weightHistory: weightHistory,
      repsHistory: repsHistory,
    );
  }

  /// Summary global (todos los datos, sin filtro de fecha).
  ({double maxWeight, double avgReps, int totalSets}) globalSummary() {
    if (state is! ExerciseStatsLoaded) {
      return (maxWeight: 0, avgReps: 0, totalSets: 0);
    }

    var maxW = 0.0;
    var totalReps = 0.0;
    var totalSets = 0;

    for (final row in _allRows) {
      final weight = (row['weight'] as num?)?.toDouble() ?? 0;
      final reps = (row['repetitions'] as num?)?.toDouble() ?? 0;
      maxW = math.max(maxW, weight);
      totalReps += reps;
      totalSets++;
    }

    return (
      maxWeight: maxW,
      avgReps: totalSets > 0 ? totalReps / totalSets : 0,
      totalSets: totalSets,
    );
  }

  /// Summary stats filtrados por rango.
  ({double maxWeight, double avgReps, int totalSets}) filteredSummary() {
    final loaded = state;
    if (loaded is! ExerciseStatsLoaded) {
      return (maxWeight: 0, avgReps: 0, totalSets: 0);
    }

    final filtered = _rangeStart != null && _rangeEnd != null
        ? _allRows.where((row) {
            final dateStr = row['session_date'] as String? ?? '';
            if (dateStr.isEmpty) return false;
            final date = DateTime.tryParse(dateStr);
            if (date == null) return false;
            return !date.isBefore(_rangeStart!) &&
                date.isBefore(_rangeEnd!.add(const Duration(days: 1)));
          })
        : _allRows;

    var maxW = 0.0;
    var totalReps = 0.0;
    var totalSets = 0;

    for (final row in filtered) {
      final weight = (row['weight'] as num?)?.toDouble() ?? 0;
      final reps = (row['repetitions'] as num?)?.toDouble() ?? 0;
      maxW = math.max(maxW, weight);
      totalReps += reps;
      totalSets++;
    }

    return (
      maxWeight: maxW,
      avgReps: totalSets > 0 ? totalReps / totalSets : 0,
      totalSets: totalSets,
    );
  }

  List<ExerciseStatsData> _toChartData(Map<String, double> byDate) {
    final sorted = byDate.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return sorted
        .map((e) => ExerciseStatsData(
              date: DateTime.tryParse(e.key) ?? DateTime.now(),
              value: e.value,
            ))
        .toList();
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final exerciseStatsProvider = StateNotifierProvider.autoDispose<
    ExerciseStatsNotifier, ExerciseStatsState>(
  (ref) => ExerciseStatsNotifier(),
);
