import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/domain/models/models.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/domain/providers/serie_detail_provider.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/widgets/exercise_detail_sliver_app_bar.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/widgets/serie_exercise_widget.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/model.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/exercise_detail/exercise_detail.dart';
import 'package:fio_fut/core/widgets/modal/add_serie_group_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ExerciseDetailPage extends ConsumerStatefulWidget {
  const ExerciseDetailPage({super.key, required this.exercise});
  final Exercise exercise;

  static const String name = 'exercise-detail';
  static const String path = '/exercise-detail';

  @override
  ConsumerState<ExerciseDetailPage> createState() =>
      _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends ConsumerState<ExerciseDetailPage> {
  static const _repiteType = RepiteType.byKg;

  // ── Workout flow state ──────────────────────────────────────────
  bool _isStarted = false;
  bool _showDescanso = false;
  bool _descansoRunning = false;
  int _descansoSeconds = 58;
  Timer? _descansoTimer;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(serieDetailProvider(SerieGroupType.effective).notifier)
          .init(exercise: widget.exercise, repiteType: _repiteType);

      if (widget.exercise.hasWarmup) {
        ref
            .read(serieDetailProvider(SerieGroupType.warmup).notifier)
            .init(exercise: widget.exercise, repiteType: _repiteType);
      }
    });
  }

  @override
  void dispose() {
    _descansoTimer?.cancel();
    super.dispose();
  }

  // ── Actions ─────────────────────────────────────────────────────

  void _startWorkout() {
    setState(() => _isStarted = true);
  }

  void _registerSerie() {
    final state =
        ref.read(serieDetailProvider(SerieGroupType.effective));
    if (state is! SerieDetailLoaded) return;

    final currentSerie =
        state.series.where((s) => !s.isCompleted).firstOrNull;
    if (currentSerie == null) return;

    ref
        .read(serieDetailProvider(SerieGroupType.effective).notifier)
        .toggleSerieCompleted(currentSerie.id);

    // Check if there are more series to do
    final updatedState =
        ref.read(serieDetailProvider(SerieGroupType.effective));
    if (updatedState is SerieDetailLoaded && !updatedState.allCompleted) {
      setState(() {
        _showDescanso = true;
        _descansoRunning = true;
        _descansoSeconds = 58;
      });
      _startDescansoTimer();
    }
  }

  void _startDescansoTimer() {
    _descansoTimer?.cancel();
    _descansoTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_descansoSeconds <= 0) {
        _descansoTimer?.cancel();
        setState(() {
          _showDescanso = false;
          _descansoRunning = false;
          _descansoSeconds = 58;
        });
        return;
      }
      setState(() => _descansoSeconds--);
    });
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

  void _done() => Navigator.pop(context);

  Future<void> _onAddSerie() async {
    if (widget.exercise.hasWarmup) {
      final group = await AddSerieGroupModal.show(context);
      if (group == null) return;
      ref.read(serieDetailProvider(group).notifier).addSerie();
    } else {
      ref
          .read(serieDetailProvider(SerieGroupType.effective).notifier)
          .addSerie();
    }
  }

  // ── Helpers ─────────────────────────────────────────────────────

  String? _currentSerieId(SerieDetailState state) {
    if (!_isStarted) return null;
    return switch (state) {
      SerieDetailLoaded(:final series) =>
        series.where((s) => !s.isCompleted).firstOrNull?.id,
      _ => null,
    };
  }

  bool _allCompleted(SerieDetailState state) {
    return switch (state) {
      SerieDetailLoaded(:final allCompleted) => allCompleted,
      _ => false,
    };
  }

  // ── Build ───────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final effectiveState =
        ref.watch(serieDetailProvider(SerieGroupType.effective));
    final currentId = _currentSerieId(effectiveState);
    final allDone = _isStarted && _allCompleted(effectiveState);

    String? warmupCurrentId;
    if (widget.exercise.hasWarmup) {
      final warmupState =
          ref.watch(serieDetailProvider(SerieGroupType.warmup));
      warmupCurrentId = _currentSerieId(warmupState);
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            ExerciseDetailSliverAppBar(
              title: widget.exercise.title,
              imageUrl: widget.exercise.imageUrl,
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailActionChips(
                    exercise: widget.exercise,
                    duration: Duration(seconds: 20),
                  ),
                  if (widget.exercise.hasWarmup)
                    SerieExerciseWidget(
                      repiteType: _repiteType,
                      groupType: SerieGroupType.warmup,
                      isStarted: _isStarted,
                      currentSerieId: warmupCurrentId,
                    ),
                  SerieExerciseWidget(
                    repiteType: _repiteType,
                    groupType: SerieGroupType.effective,
                    isStarted: _isStarted,
                    currentSerieId: currentId,
                  ),
                  AddSerieButton(onTap: _onAddSerie),
                  if (_showDescanso) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: DescansoWidget(
                        seconds: _descansoSeconds,
                        isRunning: _descansoRunning,
                        onToggle: _toggleDescanso,
                        onAdjust: _adjustDescanso,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildFooter(allDone, context),
      ),
    );
  }

  Widget _buildFooter(bool allDone, BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        MediaQuery.of(context).viewPadding.bottom + AppSpacing.md,
      ),
      child: !_isStarted
          ? _buildStartButton()
          : allDone
              ? _buildDoneButton()
              : _buildRegisterRow(),
    );
  }

  Widget _buildStartButton() {
    return GestureDetector(
      onTap: _startWorkout,
      child: Container(
        height: 56,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
        child: Text(
          'Comenzar entrenamiento',
          style: AppTextStyles.button.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildDoneButton() {
    return GestureDetector(
      onTap: _done,
      child: Container(
        height: 56,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
        child: Text(
          'Hecho',
          style: AppTextStyles.button.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterRow() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: _registerSerie,
            child: Container(
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius:
                    BorderRadius.circular(AppSpacing.radiusFull),
              ),
              child: Text(
                'Registrar serie',
                style: AppTextStyles.button.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        GestureDetector(
          onTap: _registerSerie,
          child: Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
            child: const Icon(
              LucideIcons.check,
              color: AppColors.black,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }
}
