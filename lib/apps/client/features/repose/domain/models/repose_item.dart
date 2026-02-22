import 'package:flutter/foundation.dart';

/// Represents a single repose (rest) session item.
@immutable
class ReposeItem {
  const ReposeItem({
    required this.id,
    required this.durationSeconds,
    required this.startedAt,
    this.completedAt,
    this.isCompleted = false,
  });

  final String id;
  final int durationSeconds;
  final DateTime startedAt;
  final DateTime? completedAt;
  final bool isCompleted;

  ReposeItem copyWith({
    String? id,
    int? durationSeconds,
    DateTime? startedAt,
    DateTime? completedAt,
    bool? isCompleted,
  }) {
    return ReposeItem(
      id: id ?? this.id,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ReposeItem) return false;
    return other.id == id &&
        other.durationSeconds == durationSeconds &&
        other.startedAt == startedAt &&
        other.completedAt == completedAt &&
        other.isCompleted == isCompleted;
  }

  @override
  int get hashCode =>
      Object.hash(id, durationSeconds, startedAt, completedAt, isCompleted);

  @override
  String toString() => 'ReposeItem('
      'id: $id, '
      'durationSeconds: $durationSeconds, '
      'isCompleted: $isCompleted)';
}
