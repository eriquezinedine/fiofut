/// A single data point for exercise statistics charts.
class ExerciseStatsData {
  const ExerciseStatsData({
    required this.date,
    required this.value,
    this.label,
  });

  /// The date of this data point.
  final DateTime date;

  /// The numeric value (weight volume, distance, max weight, etc.).
  final double value;

  /// Optional label for display (e.g. formatted date).
  final String? label;

  factory ExerciseStatsData.fromJson(Map<String, dynamic> json) {
    return ExerciseStatsData(
      date: DateTime.parse(json['date'] as String),
      value: (json['value'] as num).toDouble(),
      label: json['label'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'value': value,
        if (label != null) 'label': label,
      };

  @override
  String toString() => 'ExerciseStatsData(date: $date, value: $value)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseStatsData &&
          date == other.date &&
          value == other.value &&
          label == other.label;

  @override
  int get hashCode => Object.hash(date, value, label);
}
