import 'package:fio_fut/apps/client/features/configuration_exercise/presentation/pages/configuration_exercise_screen.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/providers/exercise_home/exercise_home_provider.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/configuration_exercise.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/list-exercise.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/muscle_reset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
        ConfigurationExerciseButton(
          onTap: () => context.pushNamed(ConfigurationExerciseScreen.name),
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
