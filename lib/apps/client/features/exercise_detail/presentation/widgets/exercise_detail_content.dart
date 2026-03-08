import 'dart:async';

import 'package:fio_fut/apps/client/features/exercise_detail/domain/providers/serie_detail_provider/serie_detail_provider.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/domain/providers/workout_flow_provider.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/widgets/exercise_detail_body.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/widgets/serie_exercise_widget.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise_schedule_item.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/model.dart';
import 'package:fio_fut/core/widgets/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExerciseDetailContent extends ConsumerStatefulWidget {
  const ExerciseDetailContent({
    super.key,
    required this.exercise,
    required this.scheduleId,
    this.existingSets = const [],
    this.showAppBar = false,
    this.isSessionStarted = false,
    this.onStartWorkout,
    this.onExerciseCompleted,
    this.onExerciseUncompleted,
  });

  final Exercise exercise;
  final String scheduleId;
  final List<ExerciseSetData> existingSets;
  final bool showAppBar;

  /// Whether the global session is already started (from another exercise).
  final bool isSessionStarted;

  /// Called when user taps "Comenzar entrenamiento".
  final VoidCallback? onStartWorkout;

  /// Called when all series for this exercise are completed.
  final VoidCallback? onExerciseCompleted;

  /// Called when a previously-completed exercise gets uncompleted.
  final VoidCallback? onExerciseUncompleted;

  @override
  ConsumerState<ExerciseDetailContent> createState() =>
      _ExerciseDetailContentState();
}

class _ExerciseDetailContentState extends ConsumerState<ExerciseDetailContent> {
  RepiteType get _repiteType => switch (widget.exercise.metricType) {
        MetricType.weight => RepiteType.byKg,
        MetricType.distance => RepiteType.byKm,
        MetricType.time => RepiteType.byKm,
        MetricType.reps => RepiteType.retryOnly,
      };

  // ── Workout flow state ──────────────────────────────────────────
  bool _isStarted = false;
  bool _showDescanso = false;
  bool _descansoRunning = false;
  int _descansoSeconds = 58;
  Timer? _descansoTimer;
  bool _wasAllDone = false;

  @override
  void initState() {
    super.initState();
    _isStarted = widget.isSessionStarted;
    Future.microtask(() {
      ref.read(serieDetailProvider(widget.scheduleId).notifier).init(
            exercise: widget.exercise,
            repiteType: _repiteType,
            scheduleId: widget.scheduleId,
            existingSets: widget.existingSets,
          );
    });
  }

  @override
  void didUpdateWidget(ExerciseDetailContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSessionStarted && !_isStarted) {
      setState(() => _isStarted = true);
    }
  }

  @override
  void dispose() {
    _descansoTimer?.cancel();
    super.dispose();
  }

  // ── Actions ─────────────────────────────────────────────────────

  void _startWorkout() {
    setState(() => _isStarted = true);
    widget.onStartWorkout?.call();
  }

  void _registerSerie() {
    final flowNotifier =
        ref.read(workoutFlowProvider(widget.scheduleId).notifier);

    final success = flowNotifier.registerNext();
    if (!success) {
      AppToast.error(context, 'Completa las repeticiones y peso');
      return;
    }

    // // Show descanso if there are more series to do,
    // // but skip it if the next serie is a dropset (no rest between drops).
    // final nextId = flowNotifier.nextSerieToRegister();
    // final nextType = flowNotifier.nextSerieSetType();
    // if (nextId != null && nextType != SetType.dropset) {
    //   setState(() {
    //     _showDescanso = true;
    //     _descansoRunning = true;
    //     _descansoSeconds = 58;
    //   });
    //   _startDescansoTimer();
    // } else {
    //   _stopDescanso();
    // }

    // // Check if all series just got completed
    // _checkCompletion();
  }

  void _checkCompletion() {
    final allDone = ref
        .read(workoutFlowProvider(widget.scheduleId).notifier)
        .isAllCompleted();
    if (allDone && !_wasAllDone) {
      _wasAllDone = true;
      widget.onExerciseCompleted?.call();
    } else if (!allDone && _wasAllDone) {
      _wasAllDone = false;
      widget.onExerciseUncompleted?.call();
    }
  }

  void _startDescansoTimer() {
    _descansoTimer?.cancel();
    // _descansoTimer = Timer.periodic(const Duration(seconds: 1), (_) {
    //   if (_descansoSeconds <= 0) {
    //     _descansoTimer?.cancel();
    //     setState(() {
    //       _showDescanso = false;
    //       _descansoRunning = false;
    //       _descansoSeconds = 58;
    //     });
    //     return;
    //   }
    //   setState(() => _descansoSeconds--);
    // });
  }

  void _adjustDescanso(int delta) {
    setState(() {
      _descansoSeconds = (_descansoSeconds + delta).clamp(0, 599);
    });
  }

  void _toggleDescanso() {
    setState(() {
      _descansoRunning = !_descansoRunning;
      if (_descansoRunning) {
        _startDescansoTimer();
      } else {
        _descansoTimer?.cancel();
      }
    });
  }

  void _stopDescanso() {
    _descansoTimer?.cancel();
    setState(() {
      _showDescanso = false;
      _descansoRunning = false;
      _descansoSeconds = 58;
    });
  }

  void _onAddSerie() {
    ref.read(serieDetailProvider(widget.scheduleId).notifier).addSerie();
  }

  // ── Build ───────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    ref.watch(workoutFlowProvider(widget.scheduleId));
    ref.watch(serieDetailProvider(widget.scheduleId));

    String? currentId;
    if (_isStarted) {
      currentId = ref
          .read(workoutFlowProvider(widget.scheduleId).notifier)
          .nextSerieToRegister();
    }

    final allDone = _isStarted &&
        ref
            .read(workoutFlowProvider(widget.scheduleId).notifier)
            .isAllCompleted();

    return ExerciseDetailBody(
      exercise: widget.exercise,
      scheduleId: widget.scheduleId,
      repiteType: _repiteType,
      isStarted: _isStarted,
      allDone: allDone,
      currentSerieId: currentId,
      showDescanso: _showDescanso,
      descansoSeconds: _descansoSeconds,
      descansoRunning: _descansoRunning,
      onStartWorkout: _startWorkout,
      onRegisterSerie: _registerSerie,
      onAddSerie: _onAddSerie,
      onToggleDescanso: _toggleDescanso,
      onAdjustDescanso: _adjustDescanso,
      onStopDescanso: _stopDescanso,
    );
  }
}
