part of 'week_provider.dart';

/// Base state for the week calendar.
sealed class WeekState {
  const WeekState();
}

/// Initial state before week data is loaded.
class WeekInitial extends WeekState {
  const WeekInitial();
}

/// Loading state while fetching week data.
class WeekLoading extends WeekState {
  const WeekLoading();
}

/// Loaded state with week calendar data.
class WeekLoaded extends WeekState {
  const WeekLoaded({
    required this.selectedDate,
    required this.currentWeekStart,
  });

  /// Currently selected date.
  final DateTime selectedDate;

  /// Start date (Monday) of the currently visible week.
  final DateTime currentWeekStart;

  WeekLoaded copyWith({
    DateTime? selectedDate,
    DateTime? currentWeekStart,
  }) {
    return WeekLoaded(
      selectedDate: selectedDate ?? this.selectedDate,
      currentWeekStart: currentWeekStart ?? this.currentWeekStart,
    );
  }
}

/// Error state when week data loading fails.
class WeekError extends WeekState {
  const WeekError({required this.message});

  final String message;
}
