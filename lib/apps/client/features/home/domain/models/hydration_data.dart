import 'hydration_record.dart';

/// Represents the hydration data for the user's daily water intake.
class HydrationData {
  const HydrationData({
    required this.consumed,
    required this.goal,
    this.records = const [],
  });

  /// Water consumed in milliliters
  final int consumed;

  /// Daily water goal in milliliters
  final int goal;

  /// List of hydration records for today
  final List<HydrationRecord> records;

  /// Calculates remaining water to drink
  int get remaining => goal - consumed;

  /// Calculates progress percentage (0.0 to 1.0)
  double get progress => consumed / goal;

  /// Checks if the daily goal has been reached
  bool get isGoalReached => consumed >= goal;

  HydrationData copyWith({
    int? consumed,
    int? goal,
    List<HydrationRecord>? records,
  }) {
    return HydrationData(
      consumed: consumed ?? this.consumed,
      goal: goal ?? this.goal,
      records: records ?? this.records,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! HydrationData) return false;

    return other.consumed == consumed &&
        other.goal == goal &&
        _listEquals(other.records, records);
  }

  bool _listEquals(List<HydrationRecord> a, List<HydrationRecord> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(consumed, goal, Object.hashAll(records));

  @override
  String toString() =>
      'HydrationData(consumed: $consumed, goal: $goal, records: ${records.length})';
}
