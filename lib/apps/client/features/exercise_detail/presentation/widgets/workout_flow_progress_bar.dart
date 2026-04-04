import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class WorkoutFlowProgressBar extends StatelessWidget {
  const WorkoutFlowProgressBar({
    super.key,
    required this.completedExercises,
    required this.totalExercises,
    this.elapsedMinutes,
    this.isSessionStarted = false,
  });

  final int completedExercises;
  final int totalExercises;
  final String? elapsedMinutes;
  final bool isSessionStarted;

  @override
  Widget build(BuildContext context) {
    final progress =
        totalExercises > 0 ? completedExercises / totalExercises : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 0,
      ),
      child: Row(
        children: [
          // Left: elapsed time (only when session started)
          if (isSessionStarted) ...[
            Text(
              elapsedMinutes ?? '00:00',
              style: AppTextStyles.body.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          // Center: progress bar
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                height: 8,
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  tween: Tween(begin: 0, end: progress),
                  builder: (context, value, _) {
                    return LinearProgressIndicator(
                      value: value,
                      backgroundColor: AppColors.divider,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          // Right: counter
          const SizedBox(width: AppSpacing.sm),
          Text(
            '$completedExercises/$totalExercises',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
