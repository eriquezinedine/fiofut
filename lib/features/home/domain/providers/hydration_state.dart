part of 'hydration_provider.dart';

/// Base state for hydration modal.
sealed class HydrationState {
  const HydrationState();
}

/// Initial state before data is loaded.
class HydrationInitial extends HydrationState {
  const HydrationInitial();
}

/// Loading state while fetching data.
class HydrationLoading extends HydrationState {
  const HydrationLoading();
}

/// Loaded state with hydration data.
class HydrationLoaded extends HydrationState {
  const HydrationLoaded({
    required this.consumed,
    required this.goal,
    required this.records,
    this.customAmount,
  });

  /// Water consumed in ml
  final int consumed;

  /// Daily water goal in ml
  final int goal;

  /// List of water intake records for today
  final List<HydrationRecord> records;

  /// Custom amount being entered
  final int? customAmount;

  /// Progress percentage (0.0 to 1.0)
  double get progress => goal > 0 ? consumed / goal : 0;

  /// Progress percentage as integer (0 to 100)
  int get progressPercent => (progress * 100).clamp(0, 100).toInt();

  HydrationLoaded copyWith({
    int? consumed,
    int? goal,
    List<HydrationRecord>? records,
    int? customAmount,
  }) {
    return HydrationLoaded(
      consumed: consumed ?? this.consumed,
      goal: goal ?? this.goal,
      records: records ?? this.records,
      customAmount: customAmount,
    );
  }
}

/// Error state.
class HydrationError extends HydrationState {
  const HydrationError({required this.message});

  final String message;
}
