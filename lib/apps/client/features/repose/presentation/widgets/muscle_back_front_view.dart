import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:model/model.dart';

import '../../domain/providers/all_muscles_repose_provider.dart';
import 'muscle_custom_painter/back_body_custom_paint.dart';
import 'muscle_custom_painter/front_body_custom_paint.dart';

class MuscleBackFrontView extends ConsumerWidget {
  const MuscleBackFrontView({super.key, required this.bodyWidth});

  final double bodyWidth;

  /// Maps a percentage (0-100) to a recovery color.
  static Color _colorForPercentage(int? percentage) {
    if (percentage == null) return AppColors.muscleDefaultColor;
    if (percentage >= 100) return AppColors.muscleDefaultColor;
    if (percentage <= 10) return AppColors.reposeRed;
    return AppColors.reposeOrange;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allMuscles = ref.watch(allMusclesReposeProvider);

    Color colorFor(MuscleGroup group) =>
        _colorForPercentage(allMuscles.percentageFor(group));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FrontBodyCustomPaint(
          width: bodyWidth,
          colors: FrontMuscleColors(
            chest: colorFor(MuscleGroup.chest),
            abs: colorFor(MuscleGroup.abs),
            biceps: colorFor(MuscleGroup.biceps),
            obliques: colorFor(MuscleGroup.obliques),
            forearms: colorFor(MuscleGroup.forearms),
            quadriceps: colorFor(MuscleGroup.quadriceps),
            adductors: colorFor(MuscleGroup.adductors),
            abductors: colorFor(MuscleGroup.abductors),
            lateralDeltoid: colorFor(MuscleGroup.lateralDeltoid),
            frontDeltoid: colorFor(MuscleGroup.frontDeltoid),
          ),
        ),
        BackBodyCustomPaint(
          width: bodyWidth,
          colors: BackMuscleColors(
            back: colorFor(MuscleGroup.back),
            traps: colorFor(MuscleGroup.traps),
            lowerBack: colorFor(MuscleGroup.lowerBack),
            glutes: colorFor(MuscleGroup.glutes),
            triceps: colorFor(MuscleGroup.triceps),
            rearDeltoid: colorFor(MuscleGroup.rearDeltoid),
            hamstrings: colorFor(MuscleGroup.hamstrings),
            calves: colorFor(MuscleGroup.calves),
          ),
        ),
      ],
    );
  }
}
