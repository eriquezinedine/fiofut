import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:model/model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

sealed class ProgressState {
  const ProgressState();
}

class ProgressInitial extends ProgressState {
  const ProgressInitial();
}

class ProgressLoading extends ProgressState {
  const ProgressLoading();
}

class ProgressLoaded extends ProgressState {
  const ProgressLoaded({
    required this.totalWeight,
    required this.totalDistance,
    required this.weightData,
    required this.distanceData,
    required this.selectedFilter,
    required this.selectedMetric,
  });

  /// Total weight volume (kg) across all time.
  final double totalWeight;

  /// Total distance (km) across all time.
  final double totalDistance;

  /// Weight volume per session date (for the chart).
  final List<ExerciseStatsData> weightData;

  /// Distance per session date (for the chart).
  final List<ExerciseStatsData> distanceData;

  /// 0 = Semana, 1 = Mes.
  final int selectedFilter;

  /// 0 = Peso, 1 = Distancia.
  final int selectedMetric;

  ProgressLoaded copyWith({
    double? totalWeight,
    double? totalDistance,
    List<ExerciseStatsData>? weightData,
    List<ExerciseStatsData>? distanceData,
    int? selectedFilter,
    int? selectedMetric,
  }) {
    return ProgressLoaded(
      totalWeight: totalWeight ?? this.totalWeight,
      totalDistance: totalDistance ?? this.totalDistance,
      weightData: weightData ?? this.weightData,
      distanceData: distanceData ?? this.distanceData,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      selectedMetric: selectedMetric ?? this.selectedMetric,
    );
  }
}

class ProgressError extends ProgressState {
  const ProgressError({required this.message});
  final String message;
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class ProgressNotifier extends StateNotifier<ProgressState> {
  ProgressNotifier() : super(const ProgressInitial());

  final _client = Supabase.instance.client;

  Future<void> load() async {
    state = const ProgressLoading();
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        state = const ProgressError(message: 'Usuario no autenticado');
        return;
      }

      // Fetch all completed exercise_set rows for this user
      final rows = await _client
          .from('exercise_set')
          .select('''
            weight, repetitions, distance, session_date, is_completed,
            exercise_schedule:id_exercise_schedule (id_user_profile)
          ''')
          .eq('is_completed', true)
          .order('session_date', ascending: true);

      // Filter to only this user's sets
      final userRows = (rows as List).where((r) {
        final schedule = r['exercise_schedule'];
        if (schedule == null) return false;
        return schedule['id_user_profile'] == userId;
      }).toList();

      // Aggregate by session_date
      final weightByDate = <String, double>{};
      final distanceByDate = <String, double>{};
      var totalWeight = 0.0;
      var totalDistance = 0.0;

      for (final row in userRows) {
        final date = row['session_date'] as String? ?? '';
        if (date.isEmpty) continue;

        final weight = (row['weight'] as num?)?.toDouble() ?? 0;
        final reps = (row['repetitions'] as num?)?.toDouble() ?? 0;
        final distance = (row['distance'] as num?)?.toDouble() ?? 0;

        final volume = weight * reps;
        weightByDate[date] = (weightByDate[date] ?? 0) + volume;
        distanceByDate[date] = (distanceByDate[date] ?? 0) + distance;

        totalWeight += volume;
        totalDistance += distance;
      }

      // Convert to ExerciseStatsData lists
      final weightData = _mapToStatsData(weightByDate);
      final distanceData = _mapToStatsData(distanceByDate);

      state = ProgressLoaded(
        totalWeight: totalWeight,
        totalDistance: totalDistance,
        weightData: weightData,
        distanceData: distanceData,
        selectedFilter: 0,
        selectedMetric: 0,
      );
    } catch (e) {
      state = ProgressError(message: 'Error al cargar progreso: $e');
    }
  }

  List<ExerciseStatsData> _mapToStatsData(Map<String, double> byDate) {
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

  void setFilter(int index) {
    final current = state;
    if (current is ProgressLoaded) {
      state = current.copyWith(selectedFilter: index);
    }
  }

  void setMetric(int index) {
    final current = state;
    if (current is ProgressLoaded) {
      state = current.copyWith(selectedMetric: index);
    }
  }

  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  /// Setea el rango de fechas para filtrar (semana o mes custom).
  void setDateRange(DateTime start, DateTime end) {
    _rangeStart = start;
    _rangeEnd = end;
    final current = state;
    if (current is ProgressLoaded) {
      // Force rebuild
      state = current.copyWith();
    }
  }

  /// Returns the chart data filtered by the rango seleccionado.
  List<ExerciseStatsData> filteredData(ProgressLoaded loaded) {
    final source =
        loaded.selectedMetric == 0 ? loaded.weightData : loaded.distanceData;
    if (source.isEmpty) return source;

    final now = DateTime.now();

    final DateTime start;
    final DateTime end;

    if (_rangeStart != null && _rangeEnd != null) {
      start = _rangeStart!;
      end = _rangeEnd!;
    } else if (loaded.selectedFilter == 0) {
      // Semana: lunes a domingo de esta semana
      final monday = now.subtract(Duration(days: now.weekday - 1));
      start = DateTime(monday.year, monday.month, monday.day);
      end = start.add(const Duration(days: 6));
    } else {
      // Mes: dia 1 al ultimo dia del mes actual
      start = DateTime(now.year, now.month, 1);
      end = DateTime(now.year, now.month + 1, 0);
    }

    return source
        .where((d) =>
            !d.date.isBefore(start) &&
            d.date.isBefore(end.add(const Duration(days: 1))))
        .toList();
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final progressProvider =
    StateNotifierProvider.autoDispose<ProgressNotifier, ProgressState>(
  (ref) => ProgressNotifier(),
);
