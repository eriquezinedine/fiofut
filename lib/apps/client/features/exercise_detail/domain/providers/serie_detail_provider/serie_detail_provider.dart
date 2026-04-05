import 'package:fio_fut/apps/client/features/exercise_detail/domain/providers/serie_detail_provider/serie_detail_state.dart';
import 'package:fio_fut/apps/client/features/training_exercise/presentation/widgets/modal/edit_serie_value_modal.dart';
import 'package:fio_fut/apps/client/features/exercise_home/data/repositories/offline_aware_exercise_repository.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/model.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/providers/exercise_home/exercise_home_provider.dart';
import 'package:fio_fut/apps/client/features/training_exercise/domain/providers/training_session_provider/training_session_provider.dart';
import 'package:fio_fut/apps/client/features/repose/domain/providers/all_muscles_repose_provider.dart';
import 'package:fio_fut/core/constants/workout_constants.dart';
import 'package:fio_fut/core/utils/app_logger.dart';
import 'package:fio_fut/core/utils/debouncer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:model/model.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Family provider keyed by scheduleId — one instance per exercise in PageView.
final serieDetailProvider = NotifierProvider.autoDispose
    .family<SerieDetailNotifier, SerieDetailState, String>(
  SerieDetailNotifier.new,
);

class SerieDetailNotifier
    extends AutoDisposeFamilyNotifier<SerieDetailState, String> {
  OfflineAwareExerciseRepository get _repo => ref.read(offlineExerciseRepoProvider);

  String get _scheduleId => arg;

  MetricType _repiteType = MetricType.strength;
  DateTime _scheduledDate = DateTime.now();
  MuscleGroup? _muscleGroup;
  List<MuscleGroup> _secondaryMuscles = const [];

  final _syncValuesDebouncer = Debouncer(milliseconds: 300);
  final _syncCompletedDebouncer = Debouncer(milliseconds: 300);

  @override
  SerieDetailState build(String arg) => const SerieDetailInitial();

  void init({
    required Exercise exercise,
    required MetricType repiteType,
    DateTime? scheduledDate,
    String? scheduleId,
    List<ExerciseSetData>? existingSets,
  }) {
    final now = DateTime.now();
    final date = scheduledDate ?? DateTime(now.year, now.month, now.day);

    _repiteType = repiteType;
    _scheduledDate = date;
    _muscleGroup = exercise.muscleMain.muscleGroup;

    final List<ExerciseSetData> series;
    if (existingSets != null && existingSets.isNotEmpty) {
      series = existingSets.toList();
    } else {
      final defaults = _defaultsFor(repiteType);
      series = [
        ExerciseSetData(
          id: _uuid.v4(),
          setNumber: 1,
          sessionDate: date,
          repetitions: defaults.reps,
          weight: defaults.kg,
          minutes: defaults.mins,
          seconds: defaults.segs,
        ),
      ];
    }

    AppLogger.provider('SerieDetail', 'init', {
      'scheduleId': scheduleId,
      'scheduledDate': date.toIso8601String(),
      'seriesCount': series.length,
    });

    state = SerieDetailLoaded(series: series);
  }

  void initFromSeries({
    required String scheduleId,
    required MetricType repiteType,
    required List<ExerciseSetData> series,
    MuscleGroup? muscleGroup,
    List<MuscleGroup> secondaryMuscles = const [],
  }) {
    final current = _loaded;
    if (current != null) return;

    final now = DateTime.now();
    _repiteType = repiteType;
    _scheduledDate = DateTime(now.year, now.month, now.day);
    _muscleGroup = muscleGroup;
    _secondaryMuscles = secondaryMuscles;

    state = SerieDetailLoaded(series: series);
  }

  // ── Series management ───────────────────────────────────────────

  Future<void> addSerie() async {
    final current = _loaded;
    if (current == null) return;

    final last = current.series.last;
    final defaults = _defaultsFor(_repiteType);
    final newNumber = current.series.length + 1;

    final tempId = _uuid.v4();
    final newSerie = ExerciseSetData(
      id: tempId,
      setNumber: newNumber,
      sessionDate: _scheduledDate,
      repetitions: last.repetitions ?? defaults.reps,
      weight: last.weight ?? defaults.kg,
      minutes: last.minutes ?? defaults.mins,
      seconds: last.seconds ?? defaults.segs,
    );

    final updatedSeries = [...current.series, newSerie];
    state = current.copyWith(series: updatedSeries);
    _syncToHomeProvider();

    if (!_scheduleId.startsWith('pending_')) {
      try {
        final savedSet = await _repo.addSet(
          scheduleId: _scheduleId,
          setNumber: newNumber,
          sessionDate: _scheduledDate,
          repetitions: newSerie.repetitions,
          weight: newSerie.weight,
          minutes: newSerie.minutes,
          seconds: newSerie.seconds,
        );
        _replaceSerieId(tempId, savedSet.id);
      } catch (_) {}
    }
  }

  Future<void> removeSerie(String serieId) async {
    final current = _loaded;
    if (current == null) return;
    if (current.series.length <= 1) return;

    final filtered = current.series.where((s) => s.id != serieId).toList();

    final renumbered = [
      for (var i = 0; i < filtered.length; i++)
        filtered[i].copyWith(setNumber: i + 1),
    ];

    state = current.copyWith(series: renumbered);
    _syncToHomeProvider();

    if (!_scheduleId.startsWith('pending_') &&
        !serieId.startsWith('pending_')) {
      try {
        await _repo.deleteSet(serieId);
      } catch (_) {}
    }
  }

  void _replaceSerieId(String oldId, String newId) {
    final current = _loaded;
    if (current == null) return;

    final updatedSeries = current.series.map((s) {
      return s.id == oldId ? s.copyWith(id: newId) : s;
    }).toList();

    state = current.copyWith(series: updatedSeries);
  }

  // ── Update serie values ─────────────────────────────────────────

  /// Actualiza valores de una serie y propaga weight a las siguientes.
  /// UI: inmediata. Backend: debounce 300ms.
  void updateSerieValues(String serieId, SerieValueResult result) {
    final current = _loaded;
    if (current == null) return;

    final index = current.series.indexWhere((s) => s.id == serieId);
    if (index == -1) return;

    // ── UI inmediata ──
    final updatedSeries = [
      for (var i = 0; i < current.series.length; i++)
        if (i == index)
          current.series[i].copyWith(
            repetitions: result.reps ?? current.series[i].repetitions,
            weight: result.weight ?? current.series[i].weight,
            minutes: result.minutes ?? current.series[i].minutes,
            seconds: result.seconds ?? current.series[i].seconds,
            distance: result.distance ?? current.series[i].distance,
          )
        else if (i > index && result.weight != null)
          current.series[i].copyWith(weight: result.weight)
        else
          current.series[i],
    ];

    state = current.copyWith(series: updatedSeries);
    _syncToHomeProvider();

    // ── Backend con debounce ──
    _syncValuesDebouncer.run(() => _syncValuesToBackend(
          updatedSeries: updatedSeries,
          editedIndex: index,
          propagatedWeight: result.weight,
        ));
  }

  Future<void> _syncValuesToBackend({
    required List<ExerciseSetData> updatedSeries,
    required int editedIndex,
    double? propagatedWeight,
  }) async {
    if (_scheduleId.startsWith('pending_')) return;

    final editedSerie = updatedSeries[editedIndex];
    if (!editedSerie.id.startsWith('pending_')) {
      try {
        await _repo.syncSet(
          setId: editedSerie.id,
          repetitions: editedSerie.repetitions,
          weight: editedSerie.weight,
          minutes: editedSerie.minutes,
          seconds: editedSerie.seconds,
          isCompleted: editedSerie.isCompleted,
          setType: editedSerie.setType.name,
        );
      } catch (e) {
        AppLogger.error('syncSet FAILED', e);
      }
    }

    if (propagatedWeight != null) {
      final propagatedIds = [
        for (var i = editedIndex + 1; i < updatedSeries.length; i++)
          if (!updatedSeries[i].id.startsWith('pending_'))
            updatedSeries[i].id,
      ];
      if (propagatedIds.isNotEmpty) {
        try {
          await _repo.batchSyncValues(
            setIds: propagatedIds,
            weight: propagatedWeight,
          );
        } catch (e) {
          AppLogger.error('batchSyncValues FAILED', e);
        }
      }
    }
  }

  // ── Set type ──────────────────────────────────────────────────

  void updateSetType(String serieId, SetType type) {
    _updateSerie(serieId, (s) => s.copyWith(setType: type));
    _syncSerieToSupabase(serieId);
  }

  Future<void> _syncSerieToSupabase(String serieId) async {
    final current = _loaded;
    if (current == null) return;

    if (_scheduleId.startsWith('pending_')) return;
    if (serieId.startsWith('pending_')) return;

    final serie = current.series.firstWhere(
      (s) => s.id == serieId,
      orElse: () => current.series.first,
    );
    if (serie.id != serieId) return;

    try {
      await _repo.syncSet(
        setId: serieId,
        repetitions: serie.repetitions,
        weight: serie.weight,
        minutes: serie.minutes,
        seconds: serie.seconds,
        isCompleted: serie.isCompleted,
        setType: serie.setType.name,
      );
    } catch (e) {
      AppLogger.error('syncSet FAILED', e);
    }
  }

  // ── Complete / uncomplete serie ─────────────────────────────────

  bool toggleSerieCompleted(String serieId) {
    final current = _loaded;
    if (current == null) return false;

    final targetIndex = current.series.indexWhere((s) => s.id == serieId);
    if (targetIndex == -1) return false;

    final targetSerie = current.series[targetIndex];
    final isCompleting = !targetSerie.isCompleted;

    if (isCompleting && !targetSerie.canComplete(_repiteType)) {
      return false;
    }

    // ── UI inmediata ──
    final updatedSeries = [
      for (var i = 0; i < current.series.length; i++)
        if (isCompleting && i <= targetIndex)
          current.series[i].copyWith(status: SerieStatus.completed)
        else if (!isCompleting && i >= targetIndex)
          current.series[i].copyWith(status: SerieStatus.pending)
        else
          current.series[i],
    ];

    state = current.copyWith(series: updatedSeries);

    if (isCompleting) {
      var totalReps = 0;
      for (var i = 0; i <= targetIndex; i++) {
        final s = current.series[i];
        if (!s.isCompleted && s.repetitions != null && s.repetitions! > 0) {
          totalReps += s.repetitions!;
        }
      }
      if (totalReps > 0) {
        final reposeNotifier = ref.read(allMusclesReposeProvider.notifier);

        // Musculo principal
        if (_muscleGroup != null) {
          reposeNotifier.reduceMuscleProgress(
            _muscleGroup!,
            totalReps * kFatiguePerRep,
          );
        }

        // Musculos secundarios
        for (final secondary in _secondaryMuscles) {
          reposeNotifier.reduceMuscleProgress(
            secondary,
            totalReps * kFatiguePerRepSecondary,
          );
        }
      }
    }

    _syncToHomeProvider();

    // ── Backend con debounce ──
    final changedIds = <String>[];
    for (var i = 0; i < updatedSeries.length; i++) {
      final s = updatedSeries[i];
      if (s.id.startsWith('pending_')) continue;
      if (s.isCompleted != current.series[i].isCompleted) {
        changedIds.add(s.id);
      }
    }
    _syncCompletedDebouncer.run(() => _syncCompletedToBackend(
          changedIds: changedIds,
          isCompleted: isCompleting,
        ));

    return true;
  }

  void uncompleteFromSerie(String serieId) {
    final current = _loaded;
    if (current == null) return;

    final targetIndex = current.series.indexWhere((s) => s.id == serieId);
    if (targetIndex == -1) return;

    // ── UI inmediata ──
    final changedIds = <String>[];
    final updatedSeries = [
      for (var i = 0; i < current.series.length; i++)
        if (i >= targetIndex && current.series[i].isCompleted)
          (() {
            if (!current.series[i].id.startsWith('pending_')) {
              changedIds.add(current.series[i].id);
            }
            return current.series[i].copyWith(status: SerieStatus.pending);
          })()
        else
          current.series[i],
    ];

    state = current.copyWith(series: updatedSeries);
    _syncToHomeProvider();

    // ── Backend con debounce ──
    _syncCompletedDebouncer.run(() => _syncCompletedToBackend(
          changedIds: changedIds,
          isCompleted: false,
        ));
  }

  void completeAll() {
    final current = _loaded;
    if (current == null) return;

    // ── UI inmediata ──
    final changedIds = <String>[];
    final updatedSeries = current.series.map((s) {
      if (s.isCompleted) return s;
      if (!s.id.startsWith('pending_')) {
        changedIds.add(s.id);
      }
      return s.copyWith(status: SerieStatus.completed);
    }).toList();

    state = current.copyWith(series: updatedSeries);
    _syncToHomeProvider();

    // ── Backend con debounce ──
    _syncCompletedDebouncer.run(() => _syncCompletedToBackend(
          changedIds: changedIds,
          isCompleted: true,
        ));
  }

  // ── Backend sync (llamados por debouncers) ────────────────────

  Future<void> _syncCompletedToBackend({
    required List<String> changedIds,
    required bool isCompleted,
  }) async {
    if (_scheduleId.startsWith('pending_')) return;
    if (changedIds.isEmpty) return;
    try {
      await _repo.batchToggleCompleted(
        setIds: changedIds,
        isCompleted: isCompleted,
      );
    } catch (e) {
      AppLogger.error('batchToggleCompleted FAILED', e);
    }
  }

  // ── Local helpers ─────────────────────────────────────────────

  void _updateSerie(String serieId, ExerciseSetData Function(ExerciseSetData) update) {
    final current = _loaded;
    if (current == null) return;

    final updatedSeries = current.series.map((s) {
      return s.id == serieId ? update(s) : s;
    }).toList();

    state = current.copyWith(series: updatedSeries);
  }

  SerieDetailLoaded? get _loaded =>
      state is SerieDetailLoaded ? state as SerieDetailLoaded : null;

  ({int? reps, double? kg, int? mins, int? segs}) _defaultsFor(
    MetricType type,
  ) {
    return switch (type) {
      MetricType.strength => (reps: 5, kg: 5.0, mins: null, segs: null),
      MetricType.cardio => (reps: null, kg: 5.0, mins: 5, segs: 5),
      MetricType.reps => (reps: 5, kg: null, mins: null, segs: null),
    };
  }

  // ── Flow helpers ─────────────────────────────────────────────

  String? nextSerieToRegister() {
    final current = _loaded;
    if (current == null) return null;
    return current.series.where((s) => !s.isCompleted).firstOrNull?.id;
  }

  SetType? nextSerieSetType() {
    final current = _loaded;
    if (current == null) return null;
    return current.series.where((s) => !s.isCompleted).firstOrNull?.setType;
  }

  Future<bool> registerNext() async {
    final nextId = nextSerieToRegister();
    if (nextId == null) return false;
    return toggleSerieCompleted(nextId);
  }

  bool hasMoreAfterCurrent() {
    final current = _loaded;
    if (current == null) return false;
    return current.series.where((s) => !s.isCompleted).length > 1;
  }

  bool isAllCompleted() {
    final current = _loaded;
    return current != null && current.allCompleted;
  }

  // ── Sync to home ─────────────────────────────────────────────

  void _syncToHomeProvider() {
    final current = _loaded;
    if (current == null) return;

    ref.read(exerciseHomeProvider.notifier).updateExerciseSeries(
          scheduleId: _scheduleId,
          updatedSeries: current.series,
        );

    ref.read(trainingSessionProvider.notifier).updateExerciseSeries(
          scheduleId: _scheduleId,
          updatedSeries: current.series,
        );
  }
}
