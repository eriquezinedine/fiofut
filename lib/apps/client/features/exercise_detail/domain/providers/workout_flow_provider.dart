import 'package:fio_fut/apps/client/features/exercise_detail/domain/models/models.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/domain/providers/serie_detail_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final workoutFlowProvider =
    NotifierProvider.autoDispose<WorkoutFlowNotifier, WorkoutFlowState>(
  WorkoutFlowNotifier.new,
);

class WorkoutFlowState {
  const WorkoutFlowState({this.warmupHidden = false});

  final bool warmupHidden;

  WorkoutFlowState copyWith({bool? warmupHidden}) {
    return WorkoutFlowState(warmupHidden: warmupHidden ?? this.warmupHidden);
  }
}

class WorkoutFlowNotifier extends AutoDisposeNotifier<WorkoutFlowState> {
  @override
  WorkoutFlowState build() => const WorkoutFlowState();

  void toggleWarmupHidden() {
    state = state.copyWith(warmupHidden: !state.warmupHidden);
  }

  /// Returns the next serie to register: warmup first (if visible), then effective.
  ({SerieGroupType group, String id})? nextSerieToRegister({
    required bool hasWarmup,
  }) {
    if (hasWarmup && !state.warmupHidden) {
      final warmupState =
          ref.read(serieDetailProvider(SerieGroupType.warmup));
      if (warmupState is SerieDetailLoaded) {
        final next =
            warmupState.series.where((s) => !s.isCompleted).firstOrNull;
        if (next != null) return (group: SerieGroupType.warmup, id: next.id);
      }
    }

    final effectiveState =
        ref.read(serieDetailProvider(SerieGroupType.effective));
    if (effectiveState is SerieDetailLoaded) {
      final next =
          effectiveState.series.where((s) => !s.isCompleted).firstOrNull;
      if (next != null) return (group: SerieGroupType.effective, id: next.id);
    }

    return null;
  }

  /// Registers the next serie in sequence.
  void registerNext({required bool hasWarmup}) {
    final next = nextSerieToRegister(hasWarmup: hasWarmup);
    if (next == null) return;
    ref
        .read(serieDetailProvider(next.group).notifier)
        .toggleSerieCompleted(next.id);
  }

  /// Whether there are more series left after completing the current one.
  bool hasMoreAfterCurrent({required bool hasWarmup}) {
    int remaining = 0;

    if (hasWarmup && !state.warmupHidden) {
      final ws = ref.read(serieDetailProvider(SerieGroupType.warmup));
      if (ws is SerieDetailLoaded) {
        remaining += ws.series.where((s) => !s.isCompleted).length;
      }
    }

    final es = ref.read(serieDetailProvider(SerieGroupType.effective));
    if (es is SerieDetailLoaded) {
      remaining += es.series.where((s) => !s.isCompleted).length;
    }

    return remaining > 1;
  }

  /// Checks if all relevant series are completed.
  bool isAllCompleted({required bool hasWarmup}) {
    if (hasWarmup && !state.warmupHidden) {
      final warmupState =
          ref.read(serieDetailProvider(SerieGroupType.warmup));
      if (warmupState is SerieDetailLoaded && !warmupState.allCompleted) {
        return false;
      }
    }

    final effectiveState =
        ref.read(serieDetailProvider(SerieGroupType.effective));
    return effectiveState is SerieDetailLoaded && effectiveState.allCompleted;
  }

  /// Completes all relevant series at once.
  void completeAll({required bool hasWarmup}) {
    ref
        .read(serieDetailProvider(SerieGroupType.effective).notifier)
        .completeAll();
    if (hasWarmup && !state.warmupHidden) {
      ref
          .read(serieDetailProvider(SerieGroupType.warmup).notifier)
          .completeAll();
    }
  }
}
