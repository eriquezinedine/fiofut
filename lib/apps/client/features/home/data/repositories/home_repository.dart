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

  /// Obtiene los totales de nutrición consumida para un usuario en una fecha.
  /// Solo cuenta comidas con is_completed = true.
  /// Llama al RPC `get_daily_nutrition`.
  Future<DailyNutritionSummary> getDailyNutrition(String userId, DateTime date);

  /// Obtiene las comidas del día con ingredientes completos.
  /// Incluye completadas y programadas, con totales precalculados.
  /// Llama al RPC `get_daily_meals`.
  Future<List<DailyMealItem>> getDailyMeals(String userId, DateTime date);

  /// Gets total water consumed + records for a user on a date.
  Future<DailyWaterSummary> getDailyWater(String userId, DateTime date);

  /// Adds a water intake record.
  Future<WaterIntakeRecord> addWaterIntake({
    required String userId,
    required int amountMl,
    required DateTime date,
  });

  /// Deletes a water intake record.
  Future<void> deleteWaterIntake(String recordId);
}

/// Summary of daily water intake from Supabase.
class DailyWaterSummary {
  const DailyWaterSummary({required this.totalMl, required this.records});

  final int totalMl;
  final List<WaterIntakeRecord> records;

  static const empty = DailyWaterSummary(totalMl: 0, records: []);
}

/// A single water intake record from Supabase.
class WaterIntakeRecord {
  const WaterIntakeRecord({
    required this.id,
    required this.amountMl,
    required this.intakeDate,
    required this.intakeTime,
    required this.createdAt,
  });

  final String id;
  final int amountMl;
  final String intakeDate;
  final String intakeTime;
  final DateTime createdAt;

  factory WaterIntakeRecord.fromJson(Map<String, dynamic> json) {
    return WaterIntakeRecord(
      id: json['id'] as String,
      amountMl: (json['amount_ml'] as num).toInt(),
      intakeDate: json['intake_date'] as String,
      intakeTime: json['intake_time'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
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
