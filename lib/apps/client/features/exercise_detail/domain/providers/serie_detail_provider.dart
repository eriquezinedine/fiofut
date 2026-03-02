import 'package:fio_fut/apps/client/features/exercise_detail/domain/models/models.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/widgets/serie_exercise_widget.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

part 'serie_detail_state.dart';

const _uuid = Uuid();

/// Single provider for all series (no more family keyed by group type).
final serieDetailProvider =
    NotifierProvider.autoDispose<SerieDetailNotifier, SerieDetailState>(
  SerieDetailNotifier.new,
);

class SerieDetailNotifier extends AutoDisposeNotifier<SerieDetailState> {
  @override
  SerieDetailState build() => const SerieDetailInitial();

  /// Initializes the workout with an exercise and its type.
  void init({
    required Exercise exercise,
    required RepiteType repiteType,
    DateTime? scheduledDate,
    String? scheduleId,
  }) {
    final now = DateTime.now();
    final date = scheduledDate ?? DateTime(now.year, now.month, now.day);

    final defaults = _defaultsFor(repiteType);
    final firstSerie = SerieSet(
      id: _uuid.v4(),
      number: 1,
      reps: defaults.reps,
      kg: defaults.kg,
      mins: defaults.mins,
      segs: defaults.segs,
    );

    final workout = WorkoutExercise(
      id: _uuid.v4(),
      exercise: exercise,
      repiteType: repiteType,
      scheduledDate: date,
      series: [firstSerie],
      status: WorkoutStatus.pending,
      scheduleId: scheduleId,
    );

    state = SerieDetailLoaded(workout: workout);
  }

  // ── Series management ───────────────────────────────────────────

  void addSerie() {
    final current = _loaded;
    if (current == null) return;

    final last = current.series.last;
    final defaults = _defaultsFor(current.repiteType);
    final newNumber = current.series.length + 1;
    final newSerie = SerieSet(
      id: _uuid.v4(),
      number: newNumber,
      reps: last.reps ?? defaults.reps,
      kg: last.kg ?? defaults.kg,
      mins: last.mins ?? defaults.mins,
      segs: last.segs ?? defaults.segs,
    );

    final updatedSeries = [...current.series, newSerie];
    state = current.copyWith(
      workout: current.workout.copyWith(series: updatedSeries),
    );
  }

  void removeSerie(String serieId) {
    final current = _loaded;
    if (current == null) return;
    if (current.series.length <= 1) return;

    final filtered = current.series.where((s) => s.id != serieId).toList();
    // Re-number
    final renumbered = [
      for (var i = 0; i < filtered.length; i++)
        filtered[i].copyWith(number: i + 1),
    ];

    state = current.copyWith(
      workout: current.workout.copyWith(series: renumbered),
    );
  }

  // ── Update serie values ─────────────────────────────────────────

  void updateReps(String serieId, int reps) {
    _updateSerie(serieId, (s) => s.copyWith(reps: reps));
  }

  void updateKg(String serieId, double kg) {
    final current = _loaded;
    if (current == null) return;

    final index = current.series.indexWhere((s) => s.id == serieId);
    if (index == -1) return;

    final updatedSeries = [
      for (var i = 0; i < current.series.length; i++)
        if (i >= index)
          current.series[i].copyWith(kg: kg)
        else
          current.series[i],
    ];

    state = current.copyWith(
      workout: current.workout.copyWith(series: updatedSeries),
    );
  }

  void updateMins(String serieId, int mins) {
    _updateSerie(serieId, (s) => s.copyWith(mins: mins));
  }

  void updateSegs(String serieId, int segs) {
    _updateSerie(serieId, (s) => s.copyWith(segs: segs));
  }

  // ── Set type ──────────────────────────────────────────────────

  void updateSetType(String serieId, SetType type) {
    _updateSerie(serieId, (s) => s.copyWith(setType: type));
  }

  // ── Complete / uncomplete serie ─────────────────────────────────

  void toggleSerieCompleted(String serieId) {
    final current = _loaded;
    if (current == null) return;

    final updatedSeries = current.series.map((s) {
      if (s.id != serieId) return s;

      if (s.isCompleted) {
        return s.copyWith(status: SerieStatus.pending);
      }

      if (!s.canComplete(current.repiteType)) return s;
      return s.copyWith(status: SerieStatus.completed);
    }).toList();

    final allDone = updatedSeries.every((s) => s.isCompleted);
    final anyInProgress = updatedSeries.any(
      (s) => s.isCompleted || s.reps != null || s.kg != null,
    );

    final workoutStatus = allDone
        ? WorkoutStatus.completed
        : anyInProgress
            ? WorkoutStatus.inProgress
            : WorkoutStatus.pending;

    state = current.copyWith(
      workout: current.workout.copyWith(
        series: updatedSeries,
        status: workoutStatus,
      ),
    );
  }

  // ── Complete all series ─────────────────────────────────────────

  void completeAll() {
    final current = _loaded;
    if (current == null) return;

    final updatedSeries = current.series.map((s) {
      if (s.isCompleted) return s;
      return s.copyWith(status: SerieStatus.completed);
    }).toList();

    state = current.copyWith(
      workout: current.workout.copyWith(
        series: updatedSeries,
        status: WorkoutStatus.completed,
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────

  void _updateSerie(String serieId, SerieSet Function(SerieSet) update) {
    final current = _loaded;
    if (current == null) return;

    final updatedSeries = current.series.map((s) {
      return s.id == serieId ? update(s) : s;
    }).toList();

    state = current.copyWith(
      workout: current.workout.copyWith(series: updatedSeries),
    );
  }

  SerieDetailLoaded? get _loaded =>
      state is SerieDetailLoaded ? state as SerieDetailLoaded : null;

  /// Default values per RepiteType — used for first serie and fallback.
  ({int? reps, double? kg, int? mins, int? segs}) _defaultsFor(
    RepiteType type,
  ) {
    return switch (type) {
      RepiteType.byKg => (reps: 5, kg: 5.0, mins: null, segs: null),
      RepiteType.byKm => (reps: null, kg: 5.0, mins: 5, segs: 5),
      RepiteType.retryOnly => (reps: 5, kg: null, mins: null, segs: null),
    };
  }
}
