import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise_schedule_item.dart';
import 'package:flutter/foundation.dart';

/// State for exercise home — caches exercise lists per date.
@immutable
class ExerciseHomeState {
  const ExerciseHomeState({
    this.cache = const {},
    this.selectedDateKey = '',
  });

  /// Exercises per date. Key = "yyyy-MM-dd".
  final Map<String, List<ExerciseScheduleItem>> cache;

  /// Currently selected date key.
  final String selectedDateKey;

  /// Convenience getter — returns exercises for the selected date.
  List<ExerciseScheduleItem> get exercises =>
      cache[selectedDateKey] ?? const [];

  ExerciseHomeState copyWith({
    Map<String, List<ExerciseScheduleItem>>? cache,
    String? selectedDateKey,
  }) {
    return ExerciseHomeState(
      cache: cache ?? this.cache,
      selectedDateKey: selectedDateKey ?? this.selectedDateKey,
    );
  }
}