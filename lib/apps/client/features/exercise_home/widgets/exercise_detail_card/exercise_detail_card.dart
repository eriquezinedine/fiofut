import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/model.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/excercise_card/excercise_card_image.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/exercise_detail/exercise_detail.dart';
import 'package:fio_fut/apps/client/features/training_exercise/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExerciseDetailCard extends ConsumerWidget {
  const ExerciseDetailCard({super.key, required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollProgress = ref.watch(pageScrollProgressProvider);
    final opacity = (1.0 - (scrollProgress.abs() * 2.25)).clamp(0.0, 1.0);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 100),
      opacity: opacity,
      child: Padding(
        padding: AppSpacing.md.all,
        child: Row(
          spacing: AppSpacing.md,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcerciseCardImage(exercise: exercise, style2: true),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(exercise.title, style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w900
                  )),
                  DetailActionChips(
                    exercise: exercise,
                    duration: const Duration(minutes: 5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
