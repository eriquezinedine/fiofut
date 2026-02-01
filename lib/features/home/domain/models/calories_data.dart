/// Represents the calories data for the user's daily intake.
class CaloriesData {
  const CaloriesData({
    required this.consumed,
    required this.goal,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  /// Calories consumed so far today
  final int consumed;

  /// Daily calorie goal
  final int goal;

  /// Protein in grams
  final int protein;

  /// Carbohydrates in grams
  final int carbs;

  /// Fat in grams
  final int fat;

  /// Calculates remaining calories
  int get remaining => goal - consumed;

  /// Calculates progress percentage (0.0 to 1.0)
  double get progress => consumed / goal;

  CaloriesData copyWith({
    int? consumed,
    int? goal,
    int? protein,
    int? carbs,
    int? fat,
  }) {
    return CaloriesData(
      consumed: consumed ?? this.consumed,
      goal: goal ?? this.goal,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CaloriesData) return false;

    return other.consumed == consumed &&
        other.goal == goal &&
        other.protein == protein &&
        other.carbs == carbs &&
        other.fat == fat;
  }

  @override
  int get hashCode => Object.hash(consumed, goal, protein, carbs, fat);

  @override
  String toString() => 'CaloriesData('
      'consumed: $consumed, '
      'goal: $goal, '
      'protein: $protein, '
      'carbs: $carbs, '
      'fat: $fat)';
}
