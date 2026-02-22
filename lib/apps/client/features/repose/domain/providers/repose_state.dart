part of 'repose_provider.dart';

/// Base state for the repose feature.
sealed class ReposeState {
  const ReposeState();
}

/// Initial state before a repose session is started.
class ReposeInitial extends ReposeState {
  const ReposeInitial();
}

/// Loading state while setting up a repose session.
class ReposeLoading extends ReposeState {
  const ReposeLoading();
}

/// Active repose session state with timer data.
class ReposeLoaded extends ReposeState {
  const ReposeLoaded({
    required this.durationSeconds,
    required this.remainingSeconds,
    required this.isRunning,
  });

  final int durationSeconds;
  final int remainingSeconds;
  final bool isRunning;

  /// Progress from 1.0 (full) down to 0.0 (done).
  double get progress =>
      durationSeconds > 0 ? remainingSeconds / durationSeconds : 0;

  ReposeLoaded copyWith({
    int? durationSeconds,
    int? remainingSeconds,
    bool? isRunning,
  }) {
    return ReposeLoaded(
      durationSeconds: durationSeconds ?? this.durationSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}

/// Error state when something goes wrong.
class ReposeError extends ReposeState {
  const ReposeError({required this.message});

  final String message;
}
