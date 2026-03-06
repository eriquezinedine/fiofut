import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/domain/providers/workout_session_provider.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/pages/exercise_detail_page.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/widgets/siguiente_widget.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/widgets/workout_flow_progress_bar.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise_schedule_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

class WorkoutFlowPage extends ConsumerStatefulWidget {
  const WorkoutFlowPage({
    super.key,
    required this.exercises,
    required this.initialIndex,
  });

  final List<ExerciseScheduleItem> exercises;
  final int initialIndex;

  static const String name = 'workout-flow';
  static const String path = '/workout-flow';

  @override
  ConsumerState<WorkoutFlowPage> createState() => _WorkoutFlowPageState();
}

class _WorkoutFlowPageState extends ConsumerState<WorkoutFlowPage> {
  late final PageController _pageController;
  late int _currentPage;
  final Set<int> _completedExercises = {};

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onStartWorkout() {
    final session = ref.read(workoutSessionProvider);
    if (!session.isStarted) {
      ref
          .read(workoutSessionProvider.notifier)
          .startSession(widget.exercises.length);
    }
  }

  void _onExerciseCompleted(int index) {
    setState(() => _completedExercises.add(index));
    ref.read(workoutSessionProvider.notifier).markExerciseCompleted();
  }

  void _onExerciseUncompleted(int index) {
    setState(() => _completedExercises.remove(index));
    ref.read(workoutSessionProvider.notifier).markExerciseUncompleted();
  }

  void _goToNextExercise() {
    // Find the next non-completed exercise after current page
    for (var i = _currentPage + 1; i < widget.exercises.length; i++) {
      if (!_completedExercises.contains(i)) {
        _pageController.animateToPage(
          i,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
        return;
      }
    }
    // If no non-completed found after, go to the immediate next
    if (_currentPage < widget.exercises.length - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _onDone() async {
    await ref.read(workoutSessionProvider.notifier).finishSession();
    if (mounted) {
      Navigator.pop(context, true); // true = show stats modal
    }
  }

  Future<void> _showExitConfirmation() async {
    final shouldExit = await showModalBottomSheet<bool>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const ConfirmSheet(
            title: 'Entrenamiento en progreso',
            subtitle: '¿Estás en pleno entrenamiento, deseas regresar?',
            icon: LucideIcons.alertTriangle,
            confirmText: 'Regresar',
          ),
        ) ??
        false;

    if (shouldExit && mounted) {
      Navigator.pop(context, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(workoutSessionProvider);
    final allExercisesCompleted =
        _completedExercises.length == widget.exercises.length;

    // Determine if current exercise is completed and has a next exercise
    final currentCompleted = _completedExercises.contains(_currentPage);
    final hasNext = _currentPage < widget.exercises.length - 1;

    // Find next exercise name/image
    String? nextExerciseName;
    String? nextExerciseImageUrl;
    if (currentCompleted && hasNext) {
      final nextItem = widget.exercises[_currentPage + 1];
      nextExerciseName = nextItem.exerciseName;
      nextExerciseImageUrl = nextItem.exerciseImageUrl;
    }

    return PopScope(
      canPop: !session.isStarted || session.isFinished,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _showExitConfirmation();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Top: back button + progress bar
              Padding(
                padding: const EdgeInsets.only(
                  left: 4,
                  right: AppSpacing.md,
                  top: AppSpacing.xs,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (session.isStarted && !session.isFinished) {
                          _showExitConfirmation();
                        } else {
                          Navigator.pop(context, false);
                        }
                      },
                      icon: const Icon(
                        LucideIcons.arrowLeft,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Expanded(
                      child: WorkoutFlowProgressBar(
                        completedExercises: _completedExercises.length,
                        totalExercises: widget.exercises.length,
                        isSessionStarted: session.isStarted,
                        elapsedMinutes: session.formattedTime,
                      ),
                    ),
                  ],
                ),
              ),

              // PageView with exercises
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.exercises.length,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemBuilder: (context, index) {
                    final item = widget.exercises[index];
                    return ExerciseDetailContent(
                      exercise: item.toExercise(),
                      scheduleId: item.scheduleId,
                      existingSets: item.sets,
                      isSessionStarted: session.isStarted,
                      onStartWorkout: _onStartWorkout,
                      onExerciseCompleted: () =>
                          _onExerciseCompleted(index),
                      onExerciseUncompleted: () =>
                          _onExerciseUncompleted(index),
                    );
                  },
                ),
              ),

              // Bottom: Siguiente widget or Hecho button
              if (currentCompleted && hasNext && nextExerciseName != null)
                SiguienteWidget(
                  nextExerciseName: nextExerciseName,
                  nextExerciseImageUrl: nextExerciseImageUrl,
                  onTap: _goToNextExercise,
                ),

              if (allExercisesCompleted && session.isStarted)
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.sm,
                    AppSpacing.md,
                    MediaQuery.of(context).viewPadding.bottom +
                        AppSpacing.md,
                  ),
                  child: GestureDetector(
                    onTap: _onDone,
                    child: Container(
                      height: 56,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusFull),
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
                            'Hecho',
                            style: AppTextStyles.button.copyWith(
                              color: AppColors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
