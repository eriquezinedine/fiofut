import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise_schedule_item.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/excercise_card/excercise_card.dart';
import 'package:fio_fut/apps/client/features/training_exercise/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrainingBody extends ConsumerWidget {
  const TrainingBody({
    super.key,
    required this.exercises,
  });

  final List<ExerciseScheduleItem> exercises;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedExercise = ref.watch(selectedExerciseProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${exercises.length} Ejercicios'.toUpperCase(),
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        AppSpacing.xs.gap,
        Column(
          spacing: AppSpacing.xs,
          children: exercises
              .mapIndex(
                (e, i) => ExerciseCard(
                  isSelected: selectedExercise == e,
                  onTap: () {
                    ref.read(selectedExerciseProvider.notifier).select(e);
                  },
                  style2: true,
                  item: e,
                  allExercises: exercises,
                  index: i,
                ),
              )
              .toList(),
        ),
        AppSpacing.xxxl.gap,
      ],
    );
  }
}
