import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/excercise_card/excercise_card.dart';
import 'package:flutter/material.dart';

class ListExercise extends StatelessWidget {
  const ListExercise({
    super.key,
    required this.exercises,
    this.onExerciseTap,
  });

  final List<Exercise> exercises;
  final void Function(Exercise exercise)? onExerciseTap;

  @override
  Widget build(BuildContext context) {
    if (exercises.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Text(
            'No hay ejercicios programados',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textMuted,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: exercises.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final exercise = exercises[index];
        return ExerciseCard(
          exercise: exercise,
          // onTap: onExerciseTap != null
          //     ? () => onExerciseTap!(exercise)
          //     : null,
        );
      },
    );
  }
}
