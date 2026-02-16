import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/list-exercise.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/muscle_reset.dart';
import 'package:flutter/material.dart';

class ExerciseHomePage extends StatelessWidget {
  const ExerciseHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
      children: [
        const MuscleReset(),
        const SizedBox(height: 16),
        ListExercise(
          exercises: Exercise.sampleData,
          onExerciseTap: (exercise) {
            // TODO: navigate to exercise detail
          },
        ),
      ],
    );
  }
}
