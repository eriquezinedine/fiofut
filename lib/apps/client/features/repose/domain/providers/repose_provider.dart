import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'repose_state.dart';

/// Provider for the repose screen state.
final reposeProvider = NotifierProvider<ReposeNotifier, ReposeState>(
  ReposeNotifier.new,
);

/// Notifier that manages the repose screen state.
class ReposeNotifier extends Notifier<ReposeState> {
  @override
  ReposeState build() {
    return const ReposeInitial();
  }

  /// Starts a rest timer for [durationSeconds].
  Future<void> startRepose(int durationSeconds) async {
    state = const ReposeLoading();

    try {
      // TODO: Persist repose session via repository
      state = ReposeLoaded(
        durationSeconds: durationSeconds,
        remainingSeconds: durationSeconds,
        isRunning: true,
      );
    } catch (e) {
      state = ReposeError(message: e.toString());
    }
  }

  /// Ticks the timer down by one second.
  void tick() {
    if (state is! ReposeLoaded) return;
    final current = state as ReposeLoaded;
    final next = current.remainingSeconds - 1;

    if (next <= 0) {
      state = current.copyWith(remainingSeconds: 0, isRunning: false);
    } else {
      state = current.copyWith(remainingSeconds: next);
    }
  }

  /// Pauses or resumes the running timer.
  void togglePause() {
    if (state is! ReposeLoaded) return;
    final current = state as ReposeLoaded;
    state = current.copyWith(isRunning: !current.isRunning);
  }

  /// Resets the repose state back to initial.
  void reset() {
    state = const ReposeInitial();
  }
}
