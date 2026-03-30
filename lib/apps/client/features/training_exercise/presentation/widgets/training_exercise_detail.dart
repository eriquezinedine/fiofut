import 'package:fio_fut/apps/client/features/exercise_home/widgets/exercise_detail/exercise_detail.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/exercise_detail_card/exercise_detail_card.dart';
import 'package:fio_fut/apps/client/features/training_exercise/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrainingExerciseDetail extends ConsumerWidget {
  const TrainingExerciseDetail({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercises = ref.watch(trainingSessionProvider).exercises;
    final index = ref.watch(currentPageIndexProvider);
    return SafeArea(
      bottom: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ExerciseDetailCard(
            exercise: exercises[index].toExercise(),
          ),
        ],
      ),
    );
  }
}
