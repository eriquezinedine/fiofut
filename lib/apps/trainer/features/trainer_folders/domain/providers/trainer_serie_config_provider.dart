import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise_schedule_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Key for the trainer serie config provider.
typedef SerieConfigKey = ({String exerciseId, MetricType repiteType});

/// In-memory provider for configuring series per exercise during selection.
/// Initializes with 3 default series based on the exercise's RepiteType.
final trainerSerieConfigProvider = NotifierProvider.autoDispose
    .family<TrainerSerieConfigNotifier, List<ExerciseSetData>, SerieConfigKey>(
  TrainerSerieConfigNotifier.new,
);

class TrainerSerieConfigNotifier
    extends AutoDisposeFamilyNotifier<List<ExerciseSetData>, SerieConfigKey> {
  @override
  List<ExerciseSetData> build(SerieConfigKey arg) {
    final defaults = _defaultsFor(arg.repiteType);
    return List.generate(
      1,
      (i) => ExerciseSetData(
        id: _uuid.v4(),
        setNumber: i + 1,
        sessionDate: DateTime.now(),
        repetitions: defaults.reps,
        weight: defaults.kg,
        minutes: defaults.mins,
        seconds: defaults.segs,
      ),
    );
  }

  /// Load existing series (for editing an already-saved exercise).
  void initWithSeries(List<ExerciseSetData> series) {
    if (series.isEmpty) return;
    state = [
      for (var i = 0; i < series.length; i++)
        series[i].copyWith(setNumber: i + 1),
    ];
  }

  void addSerie() {
    final defaults = _defaultsFor(arg.repiteType);
    final next = state.isEmpty
        ? ExerciseSetData(
            id: _uuid.v4(),
            setNumber: 1,
            sessionDate: DateTime.now(),
            repetitions: defaults.reps,
            weight: defaults.kg,
            minutes: defaults.mins,
            seconds: defaults.segs,
          )
        : ExerciseSetData(
            id: _uuid.v4(),
            setNumber: state.length + 1,
            sessionDate: DateTime.now(),
            repetitions: state.last.repetitions,
            weight: state.last.weight,
            minutes: state.last.minutes,
            seconds: state.last.seconds,
          );
    state = [...state, next];
  }

  void removeSerie(String serieId) {
    if (state.length <= 1) return;
    final filtered = state.where((s) => s.id != serieId).toList();
    state = [
      for (var i = 0; i < filtered.length; i++)
        filtered[i].copyWith(setNumber: i + 1),
    ];
  }

  void updateReps(String serieId, int reps) {
    state = [
      for (final s in state) s.id == serieId ? s.copyWith(repetitions: reps) : s,
    ];
  }

  void updateKg(String serieId, double kg) {
    state = [
      for (final s in state) s.id == serieId ? s.copyWith(weight: kg) : s,
    ];
  }

  void updateMins(String serieId, int mins) {
    state = [
      for (final s in state) s.id == serieId ? s.copyWith(minutes: mins) : s,
    ];
  }

  void updateSegs(String serieId, int segs) {
    state = [
      for (final s in state) s.id == serieId ? s.copyWith(seconds: segs) : s,
    ];
  }

  /// Completes all series with default values (adds 3 series total).
  void completeAll() {
    final defaults = _defaultsFor(arg.repiteType);
    state = List.generate(
      3,
      (i) => ExerciseSetData(
        id: _uuid.v4(),
        setNumber: i + 1,
        sessionDate: DateTime.now(),
        repetitions: defaults.reps,
        weight: defaults.kg,
        minutes: defaults.mins,
        seconds: defaults.segs,
      ),
    );
  }

  ({int? reps, double? kg, int? mins, int? segs}) _defaultsFor(
    MetricType type,
  ) {
    return switch (type) {
      MetricType.strength => (reps: 5, kg: 5.0, mins: null, segs: null),
      MetricType.cardio => (reps: null, kg: 5.0, mins: 5, segs: 5),
      MetricType.reps => (reps: 5, kg: null, mins: null, segs: null),
    };
  }
}
