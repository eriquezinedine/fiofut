part of 'home_provider.dart';

/// Base state for the home screen.
sealed class HomeState {
  const HomeState();
}

/// Initial state before data is loaded.
class HomeInitial extends HomeState {
  const HomeInitial();
}

/// Loading state while fetching home data.
class HomeLoading extends HomeState {
  const HomeLoading();
}

/// Loaded state with all home data.
/// Nutrition and hydration are cached per date to avoid race conditions
/// when the user switches dates rapidly.
class HomeLoaded extends HomeState {
  const HomeLoaded({
    required this.caloriesCache,
    required this.hydrationCache,
    required this.selectedDateKey,
    required this.defaultCaloriesGoals,
    required this.defaultWaterGoal,
    required this.weekDays,
    required this.mealItems,
    required this.streak,
  });

  /// Calories data per date. Key = "yyyy-MM-dd".
  final Map<String, CaloriesData> caloriesCache;

  /// Hydration data per date. Key = "yyyy-MM-dd".
  final Map<String, HydrationData> hydrationCache;

  /// Currently selected date key ("yyyy-MM-dd").
  final String selectedDateKey;

  /// Default goals from profile (used when no data for a date yet).
  final CaloriesData defaultCaloriesGoals;
  final int defaultWaterGoal;

  final List<WeekDay> weekDays;
  final List<MealItem> mealItems;
  final int streak;

  /// Convenience getter — returns cached data for the selected date,
  /// or defaults with zero consumed + profile goals.
  CaloriesData get caloriesData =>
      caloriesCache[selectedDateKey] ?? defaultCaloriesGoals.copyWith(
        consumed: 0, protein: 0, carbs: 0, fat: 0,
      );

  /// Convenience getter — returns cached hydration for the selected date.
  HydrationData get hydrationData =>
      hydrationCache[selectedDateKey] ??
      HydrationData(consumed: 0, goal: defaultWaterGoal);

  HomeLoaded copyWith({
    Map<String, CaloriesData>? caloriesCache,
    Map<String, HydrationData>? hydrationCache,
    String? selectedDateKey,
    CaloriesData? defaultCaloriesGoals,
    int? defaultWaterGoal,
    List<WeekDay>? weekDays,
    List<MealItem>? mealItems,
    int? streak,
  }) {
    return HomeLoaded(
      caloriesCache: caloriesCache ?? this.caloriesCache,
      hydrationCache: hydrationCache ?? this.hydrationCache,
      selectedDateKey: selectedDateKey ?? this.selectedDateKey,
      defaultCaloriesGoals: defaultCaloriesGoals ?? this.defaultCaloriesGoals,
      defaultWaterGoal: defaultWaterGoal ?? this.defaultWaterGoal,
      weekDays: weekDays ?? this.weekDays,
      mealItems: mealItems ?? this.mealItems,
      streak: streak ?? this.streak,
    );
  }
}

/// Error state when data loading fails.
class HomeError extends HomeState {
  const HomeError({required this.message});

  final String message;
}
