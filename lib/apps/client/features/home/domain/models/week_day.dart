/// Represents a day in the week calendar.
class WeekDay {
  const WeekDay({
    required this.date,
    required this.dayName,
    required this.dayNumber,
    required this.isSelected,
    required this.isToday,
    this.hasMeals = false,
    this.hasExercise = false,
  });

  /// The actual date
  final DateTime date;

  /// Short day name (e.g., "Lun", "Mar", "Mié")
  final String dayName;

  /// Day number (1-31)
  final int dayNumber;

  /// Whether this day is currently selected
  final bool isSelected;

  /// Whether this day is today
  final bool isToday;

  /// Whether this day has meals logged
  final bool hasMeals;

  /// Whether this day has exercises logged
  final bool hasExercise;

  WeekDay copyWith({
    DateTime? date,
    String? dayName,
    int? dayNumber,
    bool? isSelected,
    bool? isToday,
    bool? hasMeals,
    bool? hasExercise,
  }) {
    return WeekDay(
      date: date ?? this.date,
      dayName: dayName ?? this.dayName,
      dayNumber: dayNumber ?? this.dayNumber,
      isSelected: isSelected ?? this.isSelected,
      isToday: isToday ?? this.isToday,
      hasMeals: hasMeals ?? this.hasMeals,
      hasExercise: hasExercise ?? this.hasExercise,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! WeekDay) return false;

    return other.date == date &&
        other.dayName == dayName &&
        other.dayNumber == dayNumber &&
        other.isSelected == isSelected &&
        other.isToday == isToday &&
        other.hasMeals == hasMeals &&
        other.hasExercise == hasExercise;
  }

  @override
  int get hashCode => Object.hash(
        date,
        dayName,
        dayNumber,
        isSelected,
        isToday,
        hasMeals,
        hasExercise,
      );

  @override
  String toString() => 'WeekDay('
      'date: $date, '
      'dayName: $dayName, '
      'dayNumber: $dayNumber, '
      'isSelected: $isSelected, '
      'isToday: $isToday, '
      'hasMeals: $hasMeals, '
      'hasExercise: $hasExercise)';
}
