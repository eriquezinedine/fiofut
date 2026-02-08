/// Represents a single water intake record.
class HydrationRecord {
  const HydrationRecord({
    required this.id,
    required this.amount,
    required this.time,
    this.createdAt,
  });

  /// Unique identifier
  final String id;

  /// Amount of water in ml
  final int amount;

  /// Display time (e.g., "8:30 AM")
  final String time;

  /// Timestamp when the record was created
  final DateTime? createdAt;

  HydrationRecord copyWith({
    String? id,
    int? amount,
    String? time,
    DateTime? createdAt,
  }) {
    return HydrationRecord(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      time: time ?? this.time,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! HydrationRecord) return false;

    return other.id == id &&
        other.amount == amount &&
        other.time == time &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode => Object.hash(id, amount, time, createdAt);

  @override
  String toString() => 'HydrationRecord('
      'id: $id, '
      'amount: $amount, '
      'time: $time, '
      'createdAt: $createdAt)';
}
