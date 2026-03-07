import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/domain/providers/workout_session_provider/workout_session_provider.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/domain/providers/workout_session_provider/workout_session_state.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/widgets/exercise_detail_content.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/widgets/footer_buttons_section.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/widgets/siguiente_widget.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/widgets/workout_done_button.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/widgets/workout_flow_progress_bar.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise_schedule_item.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class WorkoutFlowBody extends StatelessWidget {
  const WorkoutFlowBody({
    super.key,
    required this.exercises,
    required this.pageController,
    required this.currentPage,
    required this.completedExercises,
    required this.session,
    required this.onPageChanged,
    required this.onStartWorkout,
    required this.onExerciseCompleted,
    required this.onExerciseUncompleted,
    required this.onGoToNextExercise,
    required this.onDone,
    required this.onBackPressed,
  });

  final List<ExerciseScheduleItem> exercises;
  final PageController pageController;
  final int currentPage;
  final Set<int> completedExercises;
  final WorkoutSessionState session;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onStartWorkout;
  final ValueChanged<int> onExerciseCompleted;
  final ValueChanged<int> onExerciseUncompleted;
  final VoidCallback onGoToNextExercise;
  final VoidCallback onDone;
  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    final allExercisesCompleted = completedExercises.length == exercises.length;
    final currentCompleted = completedExercises.contains(currentPage);
    final hasNext = currentPage < exercises.length - 1;

    String? nextExerciseName;
    String? nextExerciseImageUrl;
    if (currentCompleted && hasNext) {
      final nextItem = exercises[currentPage + 1];
      nextExerciseName = nextItem.exerciseName;
      nextExerciseImageUrl = nextItem.exerciseImageUrl;
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
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
                    onPressed: onBackPressed,
                    icon: const Icon(
                      LucideIcons.arrowLeft,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Expanded(
                    child: WorkoutFlowProgressBar(
                      completedExercises: completedExercises.length,
                      totalExercises: exercises.length,
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
                controller: pageController,
                itemCount: exercises.length,
                onPageChanged: onPageChanged,
                itemBuilder: (context, index) {
                  final item = exercises[index];
                  return ExerciseDetailContent(
                    exercise: item.toExercise(),
                    scheduleId: item.scheduleId,
                    existingSets: item.sets,
                    isSessionStarted: session.isStarted,
                    onStartWorkout: onStartWorkout,
                    onExerciseCompleted: () => onExerciseCompleted(index),
                    onExerciseUncompleted: () => onExerciseUncompleted(index),
                  );
                },
              ),
            ),

            // Bottom: Siguiente widget or Hecho button
            if (currentCompleted && hasNext && nextExerciseName != null)
              SiguienteWidget(
                nextExerciseName: nextExerciseName,
                nextExerciseImageUrl: nextExerciseImageUrl,
                onTap: onGoToNextExercise,
              ),

            if (allExercisesCompleted && session.isStarted)
              WorkoutDoneButton(onTap: onDone),
            FooterButtonsSection(
              isStarted: session.isStarted,
              allDone: false,
              onStartWorkout: onStartWorkout,
              onRegisterSerie: (){},
              onCompleteAll: (){},
            ),
          ],
        ),
      ),
    ),
  );
  }
}
