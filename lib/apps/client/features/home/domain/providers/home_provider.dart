import 'package:fio_fut/apps/client/features/home/data/repositories/home_repository_impl.dart';
import 'package:fio_fut/apps/client/features/home/domain/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'week_provider.dart';

part 'home_state.dart';

/// Provider for the home screen state.
final homeProvider = NotifierProvider<HomeNotifier, HomeState>(
  HomeNotifier.new,
);

/// Notifier that manages the home screen state.
class HomeNotifier extends Notifier<HomeState> {
  @override
  HomeState build() {
    // Listen to weekProvider date changes to update selectedDateKey
    // and fetch data if not cached.
    ref.listen(weekProvider, (prev, next) {
      if (next is! WeekLoaded) return;
      final prevLoaded = prev is WeekLoaded ? prev : null;
      if (prevLoaded != null &&
          prevLoaded.selectedDate == next.selectedDate) {
        return; // Same date, skip.
      }
      _onDateChanged(next.selectedDate);
    });

    return const HomeInitial();
  }

  /// Converts a DateTime to the map key format.
  static String _dateKey(DateTime date) =>
      date.toIso8601String().split('T').first;

  /// Called when the selected date changes.
  /// Updates the selectedDateKey immediately (instant switch if cached),
  /// then fetches from backend if data is missing for the new date.
  void _onDateChanged(DateTime date) {
    if (state is! HomeLoaded) return;
    final current = state as HomeLoaded;
    final key = _dateKey(date);

    // Switch date key immediately — UI will read cached data or defaults.
    state = current.copyWith(selectedDateKey: key);

    // Fetch from backend if not already cached.
    if (!current.caloriesCache.containsKey(key)) {
      loadNutritionForDate(date);
    }
    if (!current.hydrationCache.containsKey(key)) {
      loadHydrationForDate(date);
    }
  }

  /// Loads the home data for the current user (today by default).
  Future<void> loadHomeData() async {
    state = const HomeLoading();

    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;

      // Defaults
      int caloriesGoal = 2000;
      int proteinGoal = 150;
      int carbsGoal = 250;
      int fatGoal = 70;
      int waterGoal = 2500;

      final today = DateTime.now();
      final todayKey = _dateKey(today);

      if (userId != null) {
        final repo = ref.read(homeRepositoryProvider);

        // Fetch goals + consumed nutrition + hydration in parallel.
        final profileFuture = supabase
            .from('profiles')
            .select(
              'daily_calories, daily_protein_g, daily_carbs_g, daily_fat_g, daily_water_ml',
            )
            .eq('id', userId)
            .maybeSingle();
        final nutritionFuture = repo.getDailyNutrition(userId, today);
        final waterFuture = repo.getDailyWater(userId, today);

        // All futures are already running, await results.
        final profile = await profileFuture;
        final nutrition = await nutritionFuture;
        final water = await waterFuture;

        if (profile != null) {
          caloriesGoal = profile['daily_calories'] as int? ?? caloriesGoal;
          proteinGoal = profile['daily_protein_g'] as int? ?? proteinGoal;
          carbsGoal = profile['daily_carbs_g'] as int? ?? carbsGoal;
          fatGoal = profile['daily_fat_g'] as int? ?? fatGoal;
          waterGoal = profile['daily_water_ml'] as int? ?? waterGoal;
        }

        final defaultGoals = CaloriesData(
          consumed: 0,
          goal: caloriesGoal,
          protein: 0,
          proteinGoal: proteinGoal,
          carbs: 0,
          carbsGoal: carbsGoal,
          fat: 0,
          fatGoal: fatGoal,
        );

        final todayCalories = CaloriesData(
          consumed: nutrition.totalCalories,
          goal: caloriesGoal,
          protein: nutrition.totalProtein,
          proteinGoal: proteinGoal,
          carbs: nutrition.totalCarbs,
          carbsGoal: carbsGoal,
          fat: nutrition.totalFat,
          fatGoal: fatGoal,
        );

        final todayHydration = HydrationData(
          consumed: water.totalMl,
          goal: waterGoal,
          records: water.records
              .map((r) => HydrationRecord(
                    id: r.id,
                    amount: r.amountMl,
                    time: _formatTime(r.intakeTime),
                    createdAt: r.createdAt,
                  ))
              .toList(),
        );

        state = HomeLoaded(
          caloriesCache: {todayKey: todayCalories},
          hydrationCache: {todayKey: todayHydration},
          selectedDateKey: todayKey,
          defaultCaloriesGoals: defaultGoals,
          defaultWaterGoal: waterGoal,
          weekDays: [],
          mealItems: const [],
          streak: 0,
        );
      } else {
        final defaultGoals = CaloriesData(
          consumed: 0,
          goal: caloriesGoal,
          protein: 0,
          proteinGoal: proteinGoal,
          carbs: 0,
          carbsGoal: carbsGoal,
          fat: 0,
          fatGoal: fatGoal,
        );

        state = HomeLoaded(
          caloriesCache: {todayKey: defaultGoals},
          hydrationCache: {
            todayKey: HydrationData(consumed: 0, goal: waterGoal),
          },
          selectedDateKey: todayKey,
          defaultCaloriesGoals: defaultGoals,
          defaultWaterGoal: waterGoal,
          weekDays: [],
          mealItems: const [],
          streak: 0,
        );
      }
    } catch (e) {
      state = HomeError(message: e.toString());
    }
  }

  /// Loads consumed nutrition for a specific date and writes to the cache map.
  Future<void> loadNutritionForDate(DateTime date) async {
    if (state is! HomeLoaded) return;

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    final key = _dateKey(date);

    try {
      final repo = ref.read(homeRepositoryProvider);
      final nutrition = await repo.getDailyNutrition(userId, date);

      if (state is! HomeLoaded) return;
      final latest = state as HomeLoaded;

      // Write to the date's own key — no conflict with other dates.
      final updatedCache = Map<String, CaloriesData>.from(latest.caloriesCache);
      updatedCache[key] = latest.defaultCaloriesGoals.copyWith(
        consumed: nutrition.totalCalories,
        protein: nutrition.totalProtein,
        carbs: nutrition.totalCarbs,
        fat: nutrition.totalFat,
      );

      state = latest.copyWith(caloriesCache: updatedCache);
    } catch (_) {
      // Keep current state on error
    }
  }

  /// Loads hydration data for a specific date and writes to the cache map.
  Future<void> loadHydrationForDate(DateTime date) async {
    if (state is! HomeLoaded) return;

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    final key = _dateKey(date);

    try {
      final repo = ref.read(homeRepositoryProvider);
      final water = await repo.getDailyWater(userId, date);

      if (state is! HomeLoaded) return;
      final latest = state as HomeLoaded;

      // Write to the date's own key — no conflict with other dates.
      final updatedCache =
          Map<String, HydrationData>.from(latest.hydrationCache);
      updatedCache[key] = HydrationData(
        consumed: water.totalMl,
        goal: latest.defaultWaterGoal,
        records: water.records
            .map((r) => HydrationRecord(
                  id: r.id,
                  amount: r.amountMl,
                  time: _formatTime(r.intakeTime),
                  createdAt: r.createdAt,
                ))
            .toList(),
      );

      state = latest.copyWith(hydrationCache: updatedCache);
    } catch (_) {
      // Keep current state on error
    }
  }

  /// Updates the hydration data for a specific date (or selected date).
  void updateHydration(HydrationData hydrationData, {String? dateKey}) {
    if (state is! HomeLoaded) return;
    final current = state as HomeLoaded;
    final key = dateKey ?? current.selectedDateKey;

    final updatedCache =
        Map<String, HydrationData>.from(current.hydrationCache);
    updatedCache[key] = hydrationData;

    state = current.copyWith(hydrationCache: updatedCache);
  }

  /// Adds water intake (in ml) for the selected date.
  void addWater(int amount, {List<HydrationRecord>? newRecords}) {
    if (state is! HomeLoaded) return;
    final current = state as HomeLoaded;
    final currentHydration = current.hydrationData;

    final updatedRecords = newRecords != null
        ? [...newRecords, ...currentHydration.records]
        : currentHydration.records;

    updateHydration(
      currentHydration.copyWith(
        consumed: currentHydration.consumed + amount,
        records: updatedRecords,
      ),
    );
  }

  /// Refreshes all home data.
  Future<void> refresh() async {
    await loadHomeData();
  }

  /// Formats a time string from "HH:mm:ss" to "h:mm AM/PM".
  static String _formatTime(String timeStr) {
    final parts = timeStr.split(':');
    if (parts.length < 2) return timeStr;
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts[1];
    final displayHour = hour > 12
        ? hour - 12
        : (hour == 0 ? 12 : hour);
    final period = hour >= 12 ? 'PM' : 'AM';
    return '$displayHour:$minute $period';
  }
}
