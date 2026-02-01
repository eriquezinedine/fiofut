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
class HomeLoaded extends HomeState {
  const HomeLoaded({
    required this.caloriesData,
    required this.hydrationData,
    required this.weekDays,
    required this.mealItems,
    required this.streak,
  });

  final CaloriesData caloriesData;
  final HydrationData hydrationData;
  final List<WeekDay> weekDays;
  final List<MealItem> mealItems;
  final int streak;

  HomeLoaded copyWith({
    CaloriesData? caloriesData,
    HydrationData? hydrationData,
    List<WeekDay>? weekDays,
    List<MealItem>? mealItems,
    int? streak,
  }) {
    return HomeLoaded(
      caloriesData: caloriesData ?? this.caloriesData,
      hydrationData: hydrationData ?? this.hydrationData,
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
