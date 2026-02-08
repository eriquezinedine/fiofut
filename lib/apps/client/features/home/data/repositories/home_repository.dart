import 'package:fio_fut/apps/client/features/home/domain/models/models.dart';

/// Repository interface for home data operations.
abstract class HomeRepository {
  /// Fetches the home data for the current user.
  Future<HomeData> getHomeData();

  /// Fetches the home data for a specific date.
  Future<HomeData> getHomeDataForDate(DateTime date);

  /// Updates the calories data.
  Future<void> updateCalories(CaloriesData caloriesData);

  /// Updates the hydration data.
  Future<void> updateHydration(HydrationData hydrationData);

  /// Fetches meal items for the current user.
  Future<List<MealItem>> getMealItems();

  /// Fetches exercise items for the current user.
  Future<List<MealItem>> getExerciseItems();
}

/// Aggregated home data model.
class HomeData {
  const HomeData({
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
}
