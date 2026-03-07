import 'package:fio_fut/apps/client/features/exercise_detail/domain/models/models.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/domain/providers/serie_detail_provider/serie_detail_provider.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/domain/providers/serie_detail_provider/serie_detail_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Family provider keyed by scheduleId — mirrors serieDetailProvider.
final workoutFlowProvider = NotifierProvider.autoDispose
    .family<WorkoutFlowNotifier, WorkoutFlowState, String>(
  WorkoutFlowNotifier.new,
);

class WorkoutFlowState {
  const WorkoutFlowState();
}

class WorkoutFlowNotifier
    extends AutoDisposeFamilyNotifier<WorkoutFlowState, String> {
  @override
  WorkoutFlowState build(String arg) => const WorkoutFlowState();

  /// Returns the next serie to register (first incomplete).
  String? nextSerieToRegister() {
    final state = ref.read(serieDetailProvider(arg));
    if (state is SerieDetailLoaded) {
      final next = state.series.where((s) => !s.isCompleted).firstOrNull;
      if (next != null) return next.id;
    }
    return null;
  }

  /// Returns the SetType of the next incomplete serie (null if none).
  SetType? nextSerieSetType() {
    final state = ref.read(serieDetailProvider(arg));
    if (state is SerieDetailLoaded) {
      final next = state.series.where((s) => !s.isCompleted).firstOrNull;
      if (next != null) return next.setType;
    }
    return null;
  }

  /// Registers the next serie in sequence. Returns false if canComplete failed.
  bool registerNext() {
    final next = nextSerieToRegister();
    if (next == null) return false;
    return ref.read(serieDetailProvider(arg).notifier).toggleSerieCompleted(next);
  }

  /// Whether there are more series left after completing the current one.
  bool hasMoreAfterCurrent() {
    final state = ref.read(serieDetailProvider(arg));
    if (state is SerieDetailLoaded) {
      return state.series.where((s) => !s.isCompleted).length > 1;
    }
    return false;
  }

  /// Checks if all series are completed.
  bool isAllCompleted() {
    final state = ref.read(serieDetailProvider(arg));
    return state is SerieDetailLoaded && state.allCompleted;
  }

  /// Completes all series at once.
  void completeAll() {
    ref.read(serieDetailProvider(arg).notifier).completeAll();
  }
}
