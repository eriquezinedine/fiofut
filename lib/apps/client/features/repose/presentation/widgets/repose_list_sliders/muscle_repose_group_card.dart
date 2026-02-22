import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:model/model.dart';

import 'muscle_progress_bar.dart';
import 'progress_badge.dart';
import 'provider/muscle_repose_provider.dart';

/// Card showing a muscle's image, name, remaining time, progress bar
/// and percentage badge. State comes from [muscleReposeProvider].
class MuscleReposeGroupCard extends ConsumerWidget {
  const MuscleReposeGroupCard({
    required this.muscleRepose,
    required this.sliderEnabled,
    super.key,
  });

  final MuscleRepose muscleRepose;
  final bool sliderEnabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(muscleReposeProvider(muscleRepose));

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: AppSpacing.borderRadiusXl,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 8, horizontal: 8
      ),
      child: Row(
        spacing: 8,
        children: [
          _MuscleImage(muscleRepose: muscleRepose),
          _MuscleReposeData(muscleRepose: muscleRepose, state: state, sliderEnabled: sliderEnabled),
        ],
      ),
    );
  }
}

class _MuscleReposeData extends ConsumerWidget {
  const _MuscleReposeData({
    required this.muscleRepose,
    required this.state,
    required this.sliderEnabled,
  });

  final MuscleRepose muscleRepose;
  final MuscleReposeState state;
  final bool sliderEnabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      muscleRepose.muscle.name,
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
                        .read(muscleReposeProvider(muscleRepose).notifier)
                        .updateProgress(value);
                  }
                : null,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Muscle image placeholder (private, only used by MuscleReposeGroupCard)
// ---------------------------------------------------------------------------

class _MuscleImage extends StatelessWidget {
  const _MuscleImage({required this.muscleRepose});

  final MuscleRepose muscleRepose;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppSpacing.borderRadiusLg,
      child: Container(
        // width: AppSpacing.xxxl,
        color: AppColors.surfaceAlt,
        child: SvgPicture.asset(muscleRepose.muscle.muscleGroup.getIcon),
      ),
    );
  }
}
