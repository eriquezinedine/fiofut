import 'package:fio_fut/apps/client/features/exercise_detail/domain/providers/workout_session_provider/workout_session_provider.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/widgets/confirm_sheet.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/widgets/workout_flow_body.dart';
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

  void _onBackPressed() {
    final session = ref.read(workoutSessionProvider);
    if (session.isStarted && !session.isFinished) {
      _showExitConfirmation();
    } else {
      Navigator.pop(context, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(workoutSessionProvider);

    return PopScope(
      canPop: !session.isStarted || session.isFinished,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _showExitConfirmation();
      },
      child: WorkoutFlowBody(
        exercises: widget.exercises,
        pageController: _pageController,
        currentPage: _currentPage,
        completedExercises: _completedExercises,
        session: session,
        onPageChanged: (index) => setState(() => _currentPage = index),
        onStartWorkout: _onStartWorkout,
        onExerciseCompleted: _onExerciseCompleted,
        onExerciseUncompleted: _onExerciseUncompleted,
        onGoToNextExercise: _goToNextExercise,
        onDone: _onDone,
        onBackPressed: _onBackPressed,
      ),
    );
  }
}
