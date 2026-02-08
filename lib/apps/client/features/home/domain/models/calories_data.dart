/// Represents the calories data for the user's daily intake.
class CaloriesData {
  const CaloriesData({
    required this.consumed,
    required this.goal,
    required this.protein,
    required this.proteinGoal,
    required this.carbs,
    required this.carbsGoal,
    required this.fat,
    required this.fatGoal,
  });

  /// Calories consumed so far today
  final int consumed;

  /// Daily calorie goal
  final int goal;

  /// Protein in grams
  final int protein;

  /// Protein goal in grams
  final int proteinGoal;

  /// Carbohydrates in grams
  final int carbs;

  /// Carbohydrates goal in grams
  final int carbsGoal;

  /// Fat in grams
  final int fat;

  /// Fat goal in grams
  final int fatGoal;

  /// Calculates remaining calories
  int get remaining => goal - consumed;

  /// Calculates progress percentage (0.0 to 1.0)
  double get progress => consumed / goal;

  /// Calculates protein progress (0.0 to 1.0)
  double get proteinProgress => proteinGoal > 0 ? protein / proteinGoal : 0;

  /// Calculates carbs progress (0.0 to 1.0)
  double get carbsProgress => carbsGoal > 0 ? carbs / carbsGoal : 0;

  /// Calculates fat progress (0.0 to 1.0)
  double get fatProgress => fatGoal > 0 ? fat / fatGoal : 0;

  CaloriesData copyWith({
    int? consumed,
    int? goal,
    int? protein,
    int? proteinGoal,
    int? carbs,
    int? carbsGoal,
    int? fat,
    int? fatGoal,
  }) {
    return CaloriesData(
      consumed: consumed ?? this.consumed,
      goal: goal ?? this.goal,
      protein: protein ?? this.protein,
      proteinGoal: proteinGoal ?? this.proteinGoal,
      carbs: carbs ?? this.carbs,
      carbsGoal: carbsGoal ?? this.carbsGoal,
      fat: fat ?? this.fat,
      fatGoal: fatGoal ?? this.fatGoal,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CaloriesData) return false;

    return other.consumed == consumed &&
        other.goal == goal &&
        other.protein == protein &&
        other.proteinGoal == proteinGoal &&
        other.carbs == carbs &&
        other.carbsGoal == carbsGoal &&
        other.fat == fat &&
        other.fatGoal == fatGoal;
  }

  @override
  int get hashCode => Object.hash(
        consumed,
        goal,
        protein,
        proteinGoal,
        carbs,
        carbsGoal,
        fat,
        fatGoal,
      );

  @override
  String toString() => 'CaloriesData('
      'consumed: $consumed, '
      'goal: $goal, '
      'protein: $protein, '
      'proteinGoal: $proteinGoal, '
      'carbs: $carbs, '
      'carbsGoal: $carbsGoal, '
      'fat: $fat, '
      'fatGoal: $fatGoal)';
}
