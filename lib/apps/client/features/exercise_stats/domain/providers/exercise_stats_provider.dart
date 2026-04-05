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
    required this.maxWeight,
    required this.avgReps,
    required this.totalSets,
    required this.weightHistory,
    required this.repsHistory,
    required this.selectedFilter,
  });

  final String exerciseId;
  final String exerciseName;
  final double maxWeight;
  final double avgReps;
  final int totalSets;

  /// Max weight per session date.
  final List<ExerciseStatsData> weightHistory;

  /// Average reps per session date.
  final List<ExerciseStatsData> repsHistory;

  /// 0 = Semana, 1 = Mes.
  final int selectedFilter;

  ExerciseStatsLoaded copyWith({
    int? selectedFilter,
    List<ExerciseStatsData>? weightHistory,
    List<ExerciseStatsData>? repsHistory,
  }) {
    return ExerciseStatsLoaded(
      exerciseId: exerciseId,
      exerciseName: exerciseName,
      maxWeight: maxWeight,
      avgReps: avgReps,
      totalSets: totalSets,
      weightHistory: weightHistory ?? this.weightHistory,
      repsHistory: repsHistory ?? this.repsHistory,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
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

  // Store all data so we can re-filter without re-fetching
  List<Map<String, dynamic>> _allRows = [];
  String _exerciseId = '';
  String _exerciseName = '';

  Future<void> load(String exerciseId, String exerciseName) async {
    state = const ExerciseStatsLoading();
    _exerciseId = exerciseId;
    _exerciseName = exerciseName;

    try {
      // Get all exercise_schedule IDs for this exercise
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
          maxWeight: 0,
          avgReps: 0,
          totalSets: 0,
          weightHistory: const [],
          repsHistory: const [],
          selectedFilter: 0,
        );
        return;
      }

      // Fetch all completed sets for those schedules
      final rows = await _client
          .from('exercise_set')
          .select(
              'id, weight, repetitions, distance, session_date, is_completed, id_exercise_schedule')
          .inFilter('id_exercise_schedule', scheduleIds)
          .eq('is_completed', true)
          .order('session_date', ascending: true);

      _allRows = List<Map<String, dynamic>>.from(rows as List);

      _computeState(0);
    } catch (e) {
      state = ExerciseStatsError(
          message: 'Error al cargar estadisticas: $e');
    }
  }

  void setFilter(int index) {
    final current = state;
    if (current is ExerciseStatsLoaded) {
      _computeState(index);
    }
  }

  void _computeState(int filterIndex) {
    if (_allRows.isEmpty) {
      state = ExerciseStatsLoaded(
        exerciseId: _exerciseId,
        exerciseName: _exerciseName,
        maxWeight: 0,
        avgReps: 0,
        totalSets: 0,
        weightHistory: const [],
        repsHistory: const [],
        selectedFilter: filterIndex,
      );
      return;
    }

    // Filter by time range
    final now = DateTime.now();
    final cutoff = filterIndex == 0
        ? now.subtract(const Duration(days: 7))
        : DateTime(now.year, now.month - 1, now.day);

    final filtered = _allRows.where((row) {
      final dateStr = row['session_date'] as String? ?? '';
      if (dateStr.isEmpty) return false;
      final date = DateTime.tryParse(dateStr);
      return date != null && date.isAfter(cutoff);
    }).toList();

    // Aggregate by session_date
    final maxWeightByDate = <String, double>{};
    final repsSumByDate = <String, double>{};
    final repsCountByDate = <String, int>{};
    var globalMaxWeight = 0.0;
    var totalReps = 0.0;
    var totalSets = 0;

    for (final row in filtered) {
      final date = row['session_date'] as String? ?? '';
      if (date.isEmpty) continue;

      final weight = (row['weight'] as num?)?.toDouble() ?? 0;
      final reps = (row['repetitions'] as num?)?.toDouble() ?? 0;

      // Max weight per session
      maxWeightByDate[date] =
          math.max(maxWeightByDate[date] ?? 0, weight);

      // Avg reps per session
      repsSumByDate[date] = (repsSumByDate[date] ?? 0) + reps;
      repsCountByDate[date] = (repsCountByDate[date] ?? 0) + 1;

      globalMaxWeight = math.max(globalMaxWeight, weight);
      totalReps += reps;
      totalSets++;
    }

    final avgReps = totalSets > 0 ? totalReps / totalSets : 0.0;

    // Build chart data
    final weightHistory = _buildChartData(maxWeightByDate);
    final repsHistory = <ExerciseStatsData>[];
    for (final entry in (repsSumByDate.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key)))) {
      final count = repsCountByDate[entry.key] ?? 1;
      final date = DateTime.tryParse(entry.key) ?? DateTime.now();
      repsHistory.add(ExerciseStatsData(
        date: date,
        value: entry.value / count,
      ));
    }

    state = ExerciseStatsLoaded(
      exerciseId: _exerciseId,
      exerciseName: _exerciseName,
      maxWeight: globalMaxWeight,
      avgReps: avgReps,
      totalSets: totalSets,
      weightHistory: weightHistory,
      repsHistory: repsHistory,
      selectedFilter: filterIndex,
    );
  }

  List<ExerciseStatsData> _buildChartData(Map<String, double> byDate) {
    final sorted = byDate.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return sorted.map((entry) {
      final date = DateTime.tryParse(entry.key) ?? DateTime.now();
      return ExerciseStatsData(
        date: date,
        value: entry.value,
      );
    }).toList();
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final exerciseStatsProvider = StateNotifierProvider.autoDispose<
    ExerciseStatsNotifier, ExerciseStatsState>(
  (ref) => ExerciseStatsNotifier(),
);
