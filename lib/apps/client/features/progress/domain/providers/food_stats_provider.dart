import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:model/model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

sealed class FoodStatsState {
  const FoodStatsState();
}

class FoodStatsInitial extends FoodStatsState {
  const FoodStatsInitial();
}

class FoodStatsLoading extends FoodStatsState {
  const FoodStatsLoading();
}

class FoodStatsLoaded extends FoodStatsState {
  const FoodStatsLoaded({
    required this.avgCalories,
    required this.avgProtein,
    required this.avgCarbs,
    required this.avgFat,
    required this.caloriesData,
    required this.proteinData,
    required this.carbsData,
    required this.fatData,
    required this.selectedFilter,
    required this.selectedNutrient,
  });

  final double avgCalories;
  final double avgProtein;
  final double avgCarbs;
  final double avgFat;

  final List<ExerciseStatsData> caloriesData;
  final List<ExerciseStatsData> proteinData;
  final List<ExerciseStatsData> carbsData;
  final List<ExerciseStatsData> fatData;

  /// 0 = Semana, 1 = Mes.
  final int selectedFilter;

  /// 0 = Calorías, 1 = Proteínas, 2 = Carbs, 3 = Grasas.
  final int selectedNutrient;

  FoodStatsLoaded copyWith({
    double? avgCalories,
    double? avgProtein,
    double? avgCarbs,
    double? avgFat,
    List<ExerciseStatsData>? caloriesData,
    List<ExerciseStatsData>? proteinData,
    List<ExerciseStatsData>? carbsData,
    List<ExerciseStatsData>? fatData,
    int? selectedFilter,
    int? selectedNutrient,
  }) {
    return FoodStatsLoaded(
      avgCalories: avgCalories ?? this.avgCalories,
      avgProtein: avgProtein ?? this.avgProtein,
      avgCarbs: avgCarbs ?? this.avgCarbs,
      avgFat: avgFat ?? this.avgFat,
      caloriesData: caloriesData ?? this.caloriesData,
      proteinData: proteinData ?? this.proteinData,
      carbsData: carbsData ?? this.carbsData,
      fatData: fatData ?? this.fatData,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      selectedNutrient: selectedNutrient ?? this.selectedNutrient,
    );
  }
}

class FoodStatsError extends FoodStatsState {
  const FoodStatsError({required this.message});
  final String message;
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class FoodStatsNotifier extends StateNotifier<FoodStatsState> {
  FoodStatsNotifier() : super(const FoodStatsInitial());

  final _client = Supabase.instance.client;

  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  Future<void> load() async {
    state = const FoodStatsLoading();
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        state = const FoodStatsError(message: 'Usuario no autenticado');
        return;
      }

      final rows = await _client
          .from('food_schedule')
          .select('''
            id, start_date, is_completed,
            food:id_food (
              detail_food_ingredient (
                quantity,
                ingredient:id_ingredient (
                  calories, protein, fat, carbohydrates, base_quantity
                )
              )
            )
          ''')
          .eq('id_user_profile', userId)
          .order('start_date', ascending: true);

      // Agregar por fecha
      final calByDate = <String, double>{};
      final proByDate = <String, double>{};
      final carbByDate = <String, double>{};
      final fatByDate = <String, double>{};

      for (final row in rows) {
        final date = row['start_date'] as String? ?? '';
        if (date.isEmpty) continue;

        final food = row['food'] as Map<String, dynamic>?;
        if (food == null) continue;

        final details =
            food['detail_food_ingredient'] as List<dynamic>? ?? [];

        var cal = 0.0;
        var pro = 0.0;
        var carb = 0.0;
        var fat = 0.0;

        for (final d in details) {
          final detail = d as Map<String, dynamic>;
          final qty = (detail['quantity'] as num?)?.toDouble() ?? 0;
          final ing = detail['ingredient'] as Map<String, dynamic>?;
          if (ing == null) continue;

          final baseQty =
              (ing['base_quantity'] as num?)?.toDouble() ?? 100;
          if (baseQty <= 0) continue;

          cal += ((ing['calories'] as num?)?.toDouble() ?? 0) * qty / baseQty;
          pro += ((ing['protein'] as num?)?.toDouble() ?? 0) * qty / baseQty;
          carb +=
              ((ing['carbohydrates'] as num?)?.toDouble() ?? 0) * qty / baseQty;
          fat += ((ing['fat'] as num?)?.toDouble() ?? 0) * qty / baseQty;
        }

        calByDate[date] = (calByDate[date] ?? 0) + cal;
        proByDate[date] = (proByDate[date] ?? 0) + pro;
        carbByDate[date] = (carbByDate[date] ?? 0) + carb;
        fatByDate[date] = (fatByDate[date] ?? 0) + fat;
      }

      final daysCount = calByDate.length.clamp(1, 999);

      final totalCal = calByDate.values.fold(0.0, (a, b) => a + b);
      final totalPro = proByDate.values.fold(0.0, (a, b) => a + b);
      final totalCarb = carbByDate.values.fold(0.0, (a, b) => a + b);
      final totalFat = fatByDate.values.fold(0.0, (a, b) => a + b);

      state = FoodStatsLoaded(
        avgCalories: totalCal / daysCount,
        avgProtein: totalPro / daysCount,
        avgCarbs: totalCarb / daysCount,
        avgFat: totalFat / daysCount,
        caloriesData: _toStatsData(calByDate),
        proteinData: _toStatsData(proByDate),
        carbsData: _toStatsData(carbByDate),
        fatData: _toStatsData(fatByDate),
        selectedFilter: 0,
        selectedNutrient: 0,
      );
    } catch (e) {
      state = FoodStatsError(message: 'Error al cargar nutrición: $e');
    }
  }

  List<ExerciseStatsData> _toStatsData(Map<String, double> byDate) {
    final sorted = byDate.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return sorted
        .map((e) => ExerciseStatsData(
              date: DateTime.tryParse(e.key) ?? DateTime.now(),
              value: e.value,
            ))
        .toList();
  }

  void setFilter(int index) {
    final c = state;
    if (c is FoodStatsLoaded) {
      state = c.copyWith(selectedFilter: index);
    }
  }

  void setNutrient(int index) {
    final c = state;
    if (c is FoodStatsLoaded) {
      state = c.copyWith(selectedNutrient: index);
    }
  }

  void setDateRange(DateTime start, DateTime end) {
    _rangeStart = start;
    _rangeEnd = end;
    final c = state;
    if (c is FoodStatsLoaded) {
      state = c.copyWith();
    }
  }

  List<ExerciseStatsData> _filterByRange(List<ExerciseStatsData> source) {
    if (source.isEmpty || _rangeStart == null || _rangeEnd == null) {
      return source;
    }
    return source
        .where((d) =>
            !d.date.isBefore(_rangeStart!) &&
            d.date.isBefore(_rangeEnd!.add(const Duration(days: 1))))
        .toList();
  }

  /// Chart data filtrado por el rango.
  List<ExerciseStatsData> filteredData(FoodStatsLoaded loaded) {
    final source = switch (loaded.selectedNutrient) {
      0 => loaded.caloriesData,
      1 => loaded.proteinData,
      2 => loaded.carbsData,
      3 => loaded.fatData,
      _ => loaded.caloriesData,
    };
    return _filterByRange(source);
  }

  /// Promedios filtrados por el rango seleccionado.
  ({double avgCalories, double avgProtein, double avgCarbs, double avgFat})
      filteredAverages(FoodStatsLoaded loaded) {
    final cal = _filterByRange(loaded.caloriesData);
    final pro = _filterByRange(loaded.proteinData);
    final carb = _filterByRange(loaded.carbsData);
    final fat = _filterByRange(loaded.fatData);

    final days = cal.length.clamp(1, 999);
    return (
      avgCalories: cal.fold(0.0, (s, d) => s + d.value) / days,
      avgProtein: pro.fold(0.0, (s, d) => s + d.value) / days,
      avgCarbs: carb.fold(0.0, (s, d) => s + d.value) / days,
      avgFat: fat.fold(0.0, (s, d) => s + d.value) / days,
    );
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final foodStatsProvider =
    StateNotifierProvider.autoDispose<FoodStatsNotifier, FoodStatsState>(
  (ref) => FoodStatsNotifier(),
);
