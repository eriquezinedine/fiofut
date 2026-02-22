import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/repose/domain/models/muscle_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'muscle_progress_bar.dart';
import 'progress_badge.dart';
import 'provider/muscle_repose_provider.dart';

/// Card showing a muscle group's image, name, remaining time, progress bar
/// and percentage badge. State comes from [muscleReposeProvider].
class MuscleReposeGroupCard extends ConsumerWidget {
  const MuscleReposeGroupCard({required this.muscle, super.key, required this.sliderEnabled,});

  final MuscleGroup muscle;
  final bool sliderEnabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(muscleReposeProvider(muscle));

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: AppSpacing.borderRadiusXl,
      ),
      padding: const EdgeInsets.only(
        left: AppSpacing.xs,
        right: AppSpacing.md,
        top: AppSpacing.sm,
        bottom: AppSpacing.sm,
      ),
      child: Row(
        children: [
          _MuscleImage(muscle: muscle),
          AppSpacing.horizontalMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            muscle.label,
                            style: AppTextStyles.bodyMedium.copyWith(
                              letterSpacing: -0.32,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            state.remainingText,
                            style: AppTextStyles.caption.copyWith(
                              letterSpacing: -0.28,
                              color: AppColors.textDescription,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    ProgressBadge(
                      text: state.progressText,
                      color: state.progressColor,
                    ),
                  ],
                ),
                if (!sliderEnabled)
                  const SizedBox(height: AppSpacing.sm),
                MuscleProgressBar(
                  progress: state.progress,
                  color: state.progressColor,
                  showKnob: sliderEnabled,
                  onChanged: state.sliderEnabled
                      ? (value) {
                          ref
                              .read(muscleReposeProvider(muscle).notifier)
                              .updateProgress(value);
                        }
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Muscle image placeholder (private, only used by MuscleGroupCard)
// ---------------------------------------------------------------------------

class _MuscleImage extends StatelessWidget {
  const _MuscleImage({required this.muscle});

  final MuscleGroup muscle;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppSpacing.borderRadiusLg,
      child: Container(
        width: AppSpacing.xxxl,
        height: AppSpacing.xxxl,
        color: AppColors.surfaceAlt,
        child: Center(
          child: Icon(
            Icons.fitness_center_rounded,
            color: muscle.defaultColor,
            size: AppSpacing.iconLg,
          ),
        ),
      ),
    );
  }
}
