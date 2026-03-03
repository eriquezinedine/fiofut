import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/domain/models/models.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/domain/providers/serie_detail_provider.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/domain/providers/workout_flow_provider.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/widgets/exercise_detail_sliver_app_bar.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/widgets/serie_exercise_widget.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise_schedule_item.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/model.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/exercise_detail/exercise_detail.dart';
import 'package:fio_fut/core/widgets/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:lucide_icons/lucide_icons.dart';

// ── Standalone page (used for direct navigation) ────────────────────

class ExerciseDetailPage extends StatelessWidget {
  const ExerciseDetailPage({
    super.key,
    required this.exercise,
    required this.scheduleId,
  });

  final Exercise exercise;
  final String scheduleId;

  static const String name = 'exercise-detail';
  static const String path = '/exercise-detail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExerciseDetailContent(
        exercise: exercise,
        scheduleId: scheduleId,
        showAppBar: true,
      ),
    );
  }
}

// ── Embeddable content (used inside PageView or standalone) ─────────

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

class _ExerciseDetailContentState
    extends ConsumerState<ExerciseDetailContent> {
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

    // Show descanso if there are more series to do,
    // but skip it if the next serie is a dropset (no rest between drops).
    final nextId = flowNotifier.nextSerieToRegister();
    final nextType = flowNotifier.nextSerieSetType();
    if (nextId != null && nextType != SetType.dropset) {
      setState(() {
        _showDescanso = true;
        _descansoRunning = true;
        _descansoSeconds = 58;
      });
      _startDescansoTimer();
    } else {
      _stopDescanso();
    }

    // Check if all series just got completed
    _checkCompletion();
  }

  Future<void> _completeAllSeries() async {
    final confirmed = await _showConfirmCompleteSheet();
    if (!confirmed) return;

    ref.read(workoutFlowProvider(widget.scheduleId).notifier).completeAll();
    _stopDescanso();
    _checkCompletion();
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

  // ── Bottom Sheets ──────────────────────────────────────────────

  Future<bool> _showConfirmCompleteSheet() async {
    return await showModalBottomSheet<bool>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const ConfirmSheet(
            title: 'Completar ejercicio',
            subtitle: '¿Deseas completar todas las series?',
            icon: LucideIcons.checkCircle,
            confirmText: 'Completar',
          ),
        ) ??
        false;
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

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  if (widget.showAppBar)
                    ExerciseDetailSliverAppBar(
                      title: widget.exercise.title,
                      imageUrl: widget.exercise.imageUrl,
                    )
                  else
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
                          duration: const Duration(seconds: 20),
                        ),
                        SerieExerciseWidget(
                          scheduleId: widget.scheduleId,
                          repiteType: _repiteType,
                          isStarted: _isStarted,
                          currentSerieId: currentId,
                          onRegisterSerie: _registerSerie,
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
                              onStop: _stopDescanso,
                            ),
                          ),
                        ],
                        const SizedBox(height: AppSpacing.md),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _buildFooter(allDone, context),
          ],
        ),
        if (allDone)
          Positioned.fill(
            top: 0,
            child: IgnorePointer(
              child: Lottie.asset(
                'assets/lottie/confeti.json',
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
                repeat: false,
              ),
            ),
          ),
      ],
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
              ? _buildDoneIndicator()
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

  Widget _buildDoneIndicator() {
    return Container(
      height: 56,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            LucideIcons.checkCircle,
            color: AppColors.black,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Ejercicio completado',
            style: AppTextStyles.button.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
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
          onTap: _completeAllSeries,
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

// ── Confirm Bottom Sheet ───────────────────────────────────────

class ConfirmSheet extends StatelessWidget {
  const ConfirmSheet({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.confirmText,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String confirmText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.md),
            child: Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg - 4,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(title, style: AppTextStyles.h2),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    LucideIcons.x,
                    color: AppColors.textPrimary,
                    size: AppSpacing.iconMd,
                  ),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg - 4,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: AppSpacing.borderRadiusXl,
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: AppSpacing.borderRadiusMd,
                    ),
                    child: Icon(
                      icon,
                      color: AppColors.primary,
                      size: AppSpacing.iconMd,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      subtitle,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg - 4,
              AppSpacing.md,
              AppSpacing.lg - 4,
              AppSpacing.lg,
            ),
            child: Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'Cancelar',
                    onPressed: () => Navigator.pop(context, false),
                    fullWidth: true,
                    type: AppButtonType.secondary,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AppButton(
                    text: confirmText,
                    onPressed: () => Navigator.pop(context, true),
                    fullWidth: true,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height:
                MediaQuery.of(context).viewPadding.bottom + AppSpacing.xs,
          ),
        ],
      ),
    );
  }
}
