import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/repose/domain/models/muscle_group.dart';
import 'package:fio_fut/apps/client/features/repose/presentation/widgets/repose_list_sliders/muscle_repose_group_card.dart';
import 'package:flutter/material.dart';

class MostUsedMusclesSection extends StatelessWidget {
  const MostUsedMusclesSection({
    super.key,
    required this.muscles,
  });

  final List<MuscleGroup> muscles;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Text(
        //   'Músculos más utilizados',
        //   style: AppTextStyles.bodyMedium.copyWith(
        //     fontWeight: FontWeight.w700,
        //   ),
        // ),
        // const SizedBox(height: AppSpacing.sm),
        IgnorePointer(
          child: Column(
            spacing: AppSpacing.xs,
            children: muscles.map((e) => MuscleReposeGroupCard(muscle: e,sliderEnabled: false,),).toList(),
            // children: [
            //   for (int i = 0; i < .length; i++) ...[
            //     MuscleReposeGroupCard(muscle: muscles[i]),
            //     if (i < muscles.length - 1)
            //       const SizedBox(height: AppSpacing.xs),
            //   ],
            // ],
          ),
        ),
      ],
    );
  }
}
