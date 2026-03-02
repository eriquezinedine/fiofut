import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/providers/exercise_home_provider.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/add_exercise/add_exercise.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/list-exercise.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/muscle_reset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ExerciseHomePage extends ConsumerWidget {
  const ExerciseHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercises = ref.watch(exerciseHomeProvider).exercises;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
      children: [
        const MuscleReset(),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GestureDetector(
            onTap: () => AddExerciseModal.show(context),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ejercicios',
                    style: AppTextStyles.h3
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        LucideIcons.plus,
                        color: AppColors.textDescription,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Agregar ejercicios',
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.textDescription),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        ListExercise(
          exercises: exercises,
          onDelete: (scheduleId) {
            ref.read(exerciseHomeProvider.notifier).deleteSchedule(scheduleId);
          },
        ),
      ],
    );
  }
}
