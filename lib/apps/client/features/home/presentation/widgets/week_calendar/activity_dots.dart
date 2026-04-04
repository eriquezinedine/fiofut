import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/home/domain/models/models.dart';
import 'package:flutter/material.dart';

/// Activity indicator dots for meals and exercise.
class ActivityDots extends StatelessWidget {
  const ActivityDots({required this.weekDay, super.key});

  final WeekDay weekDay;

  @override
  Widget build(BuildContext context) {
    final hasMeals = weekDay.hasMeals;
    final hasExercise = weekDay.hasExercise;

    if (!hasMeals && !hasExercise) {
      return const SizedBox(height: 6);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasMeals)
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
        if (hasMeals && hasExercise) const SizedBox(width: 4),
        if (hasExercise)
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.blue,
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }
}
