import 'package:fio_fut/features/home/domain/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'home_state.dart';

/// Provider for the home screen state.
final homeProvider = NotifierProvider<HomeNotifier, HomeState>(
  HomeNotifier.new,
);

/// Notifier that manages the home screen state.
class HomeNotifier extends Notifier<HomeState> {
  @override
  HomeState build() {
    // TODO: Initialize with actual data from repository
    return const HomeInitial();
  }

  /// Loads the home data for the current user.
  Future<void> loadHomeData() async {
    state = const HomeLoading();

    try {
      // TODO: Fetch data from repository
      // final data = await ref.read(homeRepositoryProvider).getHomeData();

      // Placeholder data
      state = HomeLoaded(
        caloriesData: const CaloriesData(
          consumed: 1300,
          goal: 2000,
          protein: 50,
          proteinGoal: 150,
          carbs: 50,
          carbsGoal: 250,
          fat: 50,
          fatGoal: 70,
        ),
        hydrationData: const HydrationData(
          consumed: 0,
          goal: 2500,
        ),
        weekDays: [],
        mealItems: [],
        streak: 0,
      );
    } catch (e) {
      state = HomeError(message: e.toString());
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

    // TODO: Load data for the selected date
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

  /// Adds water intake (in ml).
  void addWater(int amount) {
    if (state is! HomeLoaded) return;
    final currentState = state as HomeLoaded;
    final currentHydration = currentState.hydrationData;

    state = currentState.copyWith(
      hydrationData: currentHydration.copyWith(
        consumed: currentHydration.consumed + amount,
      ),
    );
  }

  /// Refreshes all home data.
  Future<void> refresh() async {
    await loadHomeData();
  }
}
