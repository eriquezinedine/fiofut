import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:fio_fut/apps/client/features/exercise_detail/domain/models/serie_set.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/widgets/serie_exercise_widget.dart';

const _uuid = Uuid();

/// Key for the trainer serie config provider.
typedef SerieConfigKey = ({String exerciseId, RepiteType repiteType});

/// In-memory provider for configuring series per exercise during selection.
/// Initializes with 3 default series based on the exercise's RepiteType.
final trainerSerieConfigProvider = NotifierProvider.autoDispose
    .family<TrainerSerieConfigNotifier, List<SerieSet>, SerieConfigKey>(
  TrainerSerieConfigNotifier.new,
);

class TrainerSerieConfigNotifier
    extends AutoDisposeFamilyNotifier<List<SerieSet>, SerieConfigKey> {
  @override
  List<SerieSet> build(SerieConfigKey arg) {
    final defaults = _defaultsFor(arg.repiteType);
    return List.generate(
      1,
      (i) => SerieSet(
        id: _uuid.v4(),
        number: i + 1,
        reps: defaults.reps,
        kg: defaults.kg,
        mins: defaults.mins,
        segs: defaults.segs,
      ),
    );
  }

  /// Load existing series (for editing an already-saved exercise).
  void initWithSeries(List<SerieSet> series) {
    if (series.isEmpty) return;
    state = [
      for (var i = 0; i < series.length; i++)
        series[i].copyWith(number: i + 1),
    ];
  }

  void addSerie() {
    final defaults = _defaultsFor(arg.repiteType);
    final next = state.isEmpty
        ? SerieSet(
            id: _uuid.v4(),
            number: 1,
            reps: defaults.reps,
            kg: defaults.kg,
            mins: defaults.mins,
            segs: defaults.segs,
          )
        : SerieSet(
            id: _uuid.v4(),
            number: state.length + 1,
            reps: state.last.reps,
            kg: state.last.kg,
            mins: state.last.mins,
            segs: state.last.segs,
          );
    state = [...state, next];
  }

  void removeSerie(String serieId) {
    if (state.length <= 1) return;
    final filtered = state.where((s) => s.id != serieId).toList();
    state = [
      for (var i = 0; i < filtered.length; i++)
        filtered[i].copyWith(number: i + 1),
    ];
  }

  void updateReps(String serieId, int reps) {
    state = [
      for (final s in state) s.id == serieId ? s.copyWith(reps: reps) : s,
    ];
  }

  void updateKg(String serieId, double kg) {
    state = [
      for (final s in state) s.id == serieId ? s.copyWith(kg: kg) : s,
    ];
  }

  void updateMins(String serieId, int mins) {
    state = [
      for (final s in state) s.id == serieId ? s.copyWith(mins: mins) : s,
    ];
  }

  void updateSegs(String serieId, int segs) {
    state = [
      for (final s in state) s.id == serieId ? s.copyWith(segs: segs) : s,
    ];
  }

  /// Completes all series with default values (adds 3 series total).
  void completeAll() {
    final defaults = _defaultsFor(arg.repiteType);
    state = List.generate(
      3,
      (i) => SerieSet(
        id: _uuid.v4(),
        number: i + 1,
        reps: defaults.reps,
        kg: defaults.kg,
        mins: defaults.mins,
        segs: defaults.segs,
      ),
    );
  }

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
