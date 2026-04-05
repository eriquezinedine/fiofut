import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/muscle_item.dart';
import 'package:fio_fut/apps/client/features/repose/domain/providers/daily_muscles_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MuscleReset extends ConsumerWidget {
  const MuscleReset({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final muscles = ref.watch(dailyMusclesProvider);

    if (muscles.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Músculos a entrenar',
            style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 32,
              children: muscles
                  .map((e) => MuscleItem(
                        percentage: e.percentage,
                        muscleRepose: e,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
