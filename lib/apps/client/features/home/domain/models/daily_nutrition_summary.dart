/// Pre-calculated daily nutrition totals from the Postgres RPC `get_daily_nutrition`.
class DailyNutritionSummary {
  const DailyNutritionSummary({
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    required this.completedMealsCount,
  });

  final int totalCalories;
  final int totalProtein;
  final int totalCarbs;
  final int totalFat;
  final int completedMealsCount;

  static const empty = DailyNutritionSummary(
    totalCalories: 0,
    totalProtein: 0,
    totalCarbs: 0,
    totalFat: 0,
    completedMealsCount: 0,
  );

  factory DailyNutritionSummary.fromJson(Map<String, dynamic> json) {
    return DailyNutritionSummary(
      totalCalories: (json['total_calories'] as num?)?.round() ?? 0,
      totalProtein: (json['total_protein'] as num?)?.round() ?? 0,
      totalCarbs: (json['total_carbs'] as num?)?.round() ?? 0,
      totalFat: (json['total_fat'] as num?)?.round() ?? 0,
      completedMealsCount:
          (json['completed_meals_count'] as num?)?.toInt() ?? 0,
    );
  }
}
