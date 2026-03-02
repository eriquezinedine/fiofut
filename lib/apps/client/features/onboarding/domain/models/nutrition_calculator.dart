import 'activity_level.dart';
import 'gender.dart';
import 'onboarding_data.dart';
import 'weight_goal.dart';

/// Result of nutrition calculations based on user onboarding data.
class NutritionResult {
  const NutritionResult({
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    required this.waterMl,
  });

  final int calories;
  final int proteinG;
  final int carbsG;
  final int fatG;
  final int waterMl;
}

/// Calculates daily nutrition goals from onboarding data.
///
/// Uses the Mifflin-St Jeor equation for BMR and standard
/// activity multipliers for TDEE.
class NutritionCalculator {
  const NutritionCalculator._();

  /// Calculates BMR using the Mifflin-St Jeor equation.
  ///
  /// - Male:   (10 × kg) + (6.25 × cm) - (5 × age) + 5
  /// - Female: (10 × kg) + (6.25 × cm) - (5 × age) - 161
  /// - preferNotToSay: average of both formulas
  static double calculateBMR({
    required double weightKg,
    required double heightCm,
    required int age,
    required Gender gender,
  }) {
    final base = (10 * weightKg) + (6.25 * heightCm) - (5 * age);
    return switch (gender) {
      Gender.male => base + 5,
      Gender.female => base - 161,
      Gender.preferNotToSay => base + (5 + -161) / 2, // average offset
    };
  }

  /// Returns the TDEE activity multiplier for a given activity level.
  static double activityMultiplier(ActivityLevel? level) {
    return switch (level) {
      ActivityLevel.sedentary => 1.2,
      ActivityLevel.lightlyActive => 1.375,
      ActivityLevel.moderatelyActive => 1.55,
      ActivityLevel.veryActive => 1.725,
      null => 1.2,
    };
  }

  /// Calculates TDEE (Total Daily Energy Expenditure).
  static double calculateTDEE(double bmr, ActivityLevel? activityLevel) {
    return bmr * activityMultiplier(activityLevel);
  }

  /// Adjusts TDEE based on weight goal.
  ///
  /// - Lose: -500 kcal deficit
  /// - Gain: +400 kcal surplus
  /// - Maintain: no change
  static int calculateDailyCalories(double tdee, WeightGoal? goal) {
    final adjusted = switch (goal) {
      WeightGoal.lose => tdee - 500,
      WeightGoal.gain => tdee + 400,
      WeightGoal.maintain => tdee,
      null => tdee,
    };
    return adjusted.round().clamp(1200, 5000);
  }

  /// Calculates macronutrient goals in grams.
  ///
  /// Splits vary by goal:
  /// - Lose:     40% carbs, 30% protein, 30% fat
  /// - Gain:     40% carbs, 35% protein, 25% fat
  /// - Maintain:  45% carbs, 30% protein, 25% fat
  static ({int proteinG, int carbsG, int fatG}) calculateMacros(
    int calories,
    WeightGoal? goal,
  ) {
    final (carbsPct, proteinPct, fatPct) = switch (goal) {
      WeightGoal.lose => (0.40, 0.30, 0.30),
      WeightGoal.gain => (0.40, 0.35, 0.25),
      WeightGoal.maintain => (0.45, 0.30, 0.25),
      null => (0.45, 0.30, 0.25),
    };

    return (
      proteinG: (calories * proteinPct / 4).round(),
      carbsG: (calories * carbsPct / 4).round(),
      fatG: (calories * fatPct / 9).round(),
    );
  }

  /// Calculates daily water intake in milliliters.
  ///
  /// Formula: weight (kg) × 30 ml, rounded to nearest 50 ml.
  static int calculateWaterMl(double weightKg) {
    final raw = weightKg * 30;
    return ((raw / 50).round() * 50).clamp(1500, 5000);
  }

  /// Calculates all nutrition goals from onboarding data.
  ///
  /// Returns null if required fields are missing.
  static NutritionResult? calculateAll(OnboardingData data) {
    if (data.currentWeight == null ||
        data.height == null ||
        data.gender == null ||
        data.birthDate == null) {
      return null;
    }

    final age = data.age;
    if (age == null) return null;

    final bmr = calculateBMR(
      weightKg: data.currentWeight!,
      heightCm: data.height!,
      age: age,
      gender: data.gender!,
    );

    final tdee = calculateTDEE(bmr, data.activityLevel);
    final calories = calculateDailyCalories(tdee, data.weightGoal);
    final macros = calculateMacros(calories, data.weightGoal);
    final waterMl = calculateWaterMl(data.currentWeight!);

    return NutritionResult(
      calories: calories,
      proteinG: macros.proteinG,
      carbsG: macros.carbsG,
      fatG: macros.fatG,
      waterMl: waterMl,
    );
  }
}
