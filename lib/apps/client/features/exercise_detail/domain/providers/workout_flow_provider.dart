import 'package:fio_fut/apps/client/features/exercise_detail/domain/models/models.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/domain/providers/serie_detail_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final workoutFlowProvider =
    NotifierProvider.autoDispose<WorkoutFlowNotifier, WorkoutFlowState>(
  WorkoutFlowNotifier.new,
);

class WorkoutFlowState {
  const WorkoutFlowState();
}

class WorkoutFlowNotifier extends AutoDisposeNotifier<WorkoutFlowState> {
  @override
  WorkoutFlowState build() => const WorkoutFlowState();

  /// Returns the next serie to register (first incomplete).
  String? nextSerieToRegister() {
    final state = ref.read(serieDetailProvider);
    if (state is SerieDetailLoaded) {
      final next = state.series.where((s) => !s.isCompleted).firstOrNull;
      if (next != null) return next.id;
    }
    return null;
  }

  /// Returns the SetType of the next incomplete serie (null if none).
  SetType? nextSerieSetType() {
    final state = ref.read(serieDetailProvider);
    if (state is SerieDetailLoaded) {
      final next = state.series.where((s) => !s.isCompleted).firstOrNull;
      if (next != null) return next.setType;
    }
    return null;
  }

  /// Registers the next serie in sequence.
  void registerNext() {
    final next = nextSerieToRegister();
    if (next == null) return;
    ref.read(serieDetailProvider.notifier).toggleSerieCompleted(next);
  }

  /// Whether there are more series left after completing the current one.
  bool hasMoreAfterCurrent() {
    final state = ref.read(serieDetailProvider);
    if (state is SerieDetailLoaded) {
      return state.series.where((s) => !s.isCompleted).length > 1;
    }
    return false;
  }

  /// Checks if all series are completed.
  bool isAllCompleted() {
    final state = ref.read(serieDetailProvider);
    return state is SerieDetailLoaded && state.allCompleted;
  }

  /// Completes all series at once.
  void completeAll() {
    ref.read(serieDetailProvider.notifier).completeAll();
  }
}
