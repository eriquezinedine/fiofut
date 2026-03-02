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
    // Listen to weekProvider date changes to refresh nutrition.
    ref.listen(weekProvider, (prev, next) {
      if (next is! WeekLoaded) return;
      final prevLoaded = prev is WeekLoaded ? prev : null;
      if (prevLoaded != null &&
          prevLoaded.selectedDate == next.selectedDate) {
        return; // Same date, skip.
      }
      loadNutritionForDate(next.selectedDate);
    });

    return const HomeInitial();
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

      if (userId != null) {
        final repo = ref.read(homeRepositoryProvider);

        // Fetch goals + consumed nutrition in parallel.
        final profileFuture = supabase
            .from('profiles')
            .select(
              'daily_calories, daily_protein_g, daily_carbs_g, daily_fat_g, daily_water_ml',
            )
            .eq('id', userId)
            .maybeSingle();
        final nutritionFuture = repo.getDailyNutrition(userId, DateTime.now());

        // Both futures are already running, await results.
        final profile = await profileFuture;
        final nutrition = await nutritionFuture;

        if (profile != null) {
          caloriesGoal = profile['daily_calories'] as int? ?? caloriesGoal;
          proteinGoal = profile['daily_protein_g'] as int? ?? proteinGoal;
          carbsGoal = profile['daily_carbs_g'] as int? ?? carbsGoal;
          fatGoal = profile['daily_fat_g'] as int? ?? fatGoal;
          waterGoal = profile['daily_water_ml'] as int? ?? waterGoal;
        }

        state = HomeLoaded(
          caloriesData: CaloriesData(
            consumed: nutrition.totalCalories,
            goal: caloriesGoal,
            protein: nutrition.totalProtein,
            proteinGoal: proteinGoal,
            carbs: nutrition.totalCarbs,
            carbsGoal: carbsGoal,
            fat: nutrition.totalFat,
            fatGoal: fatGoal,
          ),
          hydrationData: HydrationData(
            consumed: 0,
            goal: waterGoal,
          ),
          weekDays: [],
          mealItems: const [],
          streak: 0,
        );
      } else {
        state = HomeLoaded(
          caloriesData: CaloriesData(
            consumed: 0,
            goal: caloriesGoal,
            protein: 0,
            proteinGoal: proteinGoal,
            carbs: 0,
            carbsGoal: carbsGoal,
            fat: 0,
            fatGoal: fatGoal,
          ),
          hydrationData: HydrationData(
            consumed: 0,
            goal: waterGoal,
          ),
          weekDays: [],
          mealItems: const [],
          streak: 0,
        );
      }
    } catch (e) {
      state = HomeError(message: e.toString());
    }
  }

  /// Loads consumed nutrition for a specific date and updates CaloriesData.
  Future<void> loadNutritionForDate(DateTime date) async {
    if (state is! HomeLoaded) return;
    final currentState = state as HomeLoaded;

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final repo = ref.read(homeRepositoryProvider);
      final nutrition = await repo.getDailyNutrition(userId, date);

      state = currentState.copyWith(
        caloriesData: currentState.caloriesData.copyWith(
          consumed: nutrition.totalCalories,
          protein: nutrition.totalProtein,
          carbs: nutrition.totalCarbs,
          fat: nutrition.totalFat,
        ),
      );
    } catch (_) {
      // Keep current state on error
    }
  }

  /// Selects a specific day in the week calendar.
  void selectDay(DateTime date) {
    if (state is! HomeLoaded) return;

    final currentState = state as HomeLoaded;
    final updatedDays = currentState.weekDays.map((day) {
      return day.copyWith(
        isSelected: day.date.year == date.year &&
            day.date.month == date.month &&
            day.date.day == date.day,
      );
    }).toList();

    state = currentState.copyWith(weekDays: updatedDays);

    // Load nutrition for the selected date
    loadNutritionForDate(date);
  }

  /// Updates the calories data.
  void updateCalories(CaloriesData caloriesData) {
    if (state is! HomeLoaded) return;
    final currentState = state as HomeLoaded;
    state = currentState.copyWith(caloriesData: caloriesData);
  }

  /// Updates the hydration data.
  void updateHydration(HydrationData hydrationData) {
    if (state is! HomeLoaded) return;
    final currentState = state as HomeLoaded;
    state = currentState.copyWith(hydrationData: hydrationData);
  }

  /// Adds water intake (in ml) with optional records.
  void addWater(int amount, {List<HydrationRecord>? newRecords}) {
    if (state is! HomeLoaded) return;
    final currentState = state as HomeLoaded;
    final currentHydration = currentState.hydrationData;

    // Merge existing records with new records
    final updatedRecords = newRecords != null
        ? [...newRecords, ...currentHydration.records]
        : currentHydration.records;

    state = currentState.copyWith(
      hydrationData: currentHydration.copyWith(
        consumed: currentHydration.consumed + amount,
        records: updatedRecords,
      ),
    );
  }

  /// Refreshes all home data.
  Future<void> refresh() async {
    await loadHomeData();
  }
}
