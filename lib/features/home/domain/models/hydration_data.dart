/// Represents the hydration data for the user's daily water intake.
class HydrationData {
  const HydrationData({
    required this.consumed,
    required this.goal,
  });

  /// Water consumed in milliliters
  final int consumed;

  /// Daily water goal in milliliters
  final int goal;

  /// Calculates remaining water to drink
  int get remaining => goal - consumed;

  /// Calculates progress percentage (0.0 to 1.0)
  double get progress => consumed / goal;

  /// Checks if the daily goal has been reached
  bool get isGoalReached => consumed >= goal;

  HydrationData copyWith({
    int? consumed,
    int? goal,
  }) {
    return HydrationData(
      consumed: consumed ?? this.consumed,
      goal: goal ?? this.goal,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! HydrationData) return false;

    return other.consumed == consumed && other.goal == goal;
  }

  @override
  int get hashCode => Object.hash(consumed, goal);

  @override
  String toString() => 'HydrationData(consumed: $consumed, goal: $goal)';
}
