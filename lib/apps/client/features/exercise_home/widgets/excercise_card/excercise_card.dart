import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/pages/exercise_detail_page.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/excercise_card/excercise_card_header.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/excercise_card/excercise_card_image.dart';
import 'package:fio_fut/core/widgets/status_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ExerciseCard extends StatelessWidget {
  const ExerciseCard({
    super.key,
    required this.exercise,
  });

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    final isCompleted = exercise.status == ExerciseStatus.completed;
    final separator = Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
      child: CircleAvatar(radius: 2,backgroundColor: AppColors.textDescription,));

    return GestureDetector(
      onTap: () => context.pushNamed(ExerciseDetailPage.name, extra: exercise),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.card,
          border: Border.all(
            width: 1.5,
            color: isCompleted ? AppColors.primary : AppColors.card,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              ExcerciseCardImage(exercise: exercise),
              const SizedBox(width: 16),
              // Content section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + status badge
                    ExcerciseCardHeader(exercise: exercise,),
                    const SizedBox(height: 4),
                    // Description
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _label('4 series'),
                        separator,
                        _label('10 reps'),
                        separator,
                        _label('11 kg'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    StatusWidget(isCompleted: isCompleted),
                    // Metric + progress bar
                    // Row(
                    //   children: [
                    //     Icon(
                    //       _metricIcon(exercise.metricType),
                    //       color: AppColors.textSecondary,
                    //       size: 14,
                    //     ),
                    //     const SizedBox(width: 4),
                    //     Text(
                    //       '${exercise.currentFormatted} / ${exercise.targetFormatted}',
                    //       style: const TextStyle(
                    //         fontFamily: 'Inter',
                    //         fontSize: 13,
                    //         fontWeight: FontWeight.w600,
                    //         color: AppColors.white,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(height: 6),
                    // // Progress bar
                    // _ProgressBar(
                    //   progress: exercise.progress,
                    //   status: exercise.status,
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Text _label(String text) {
    return Text(
                  text,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.textDescription
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                );
  }

  

  // IconData _metricIcon(MetricType type) => switch (type) {
  //       MetricType.weight => LucideIcons.dumbbell,
  //       MetricType.distance => LucideIcons.mapPin,
  //       MetricType.time => LucideIcons.timer,
  //       MetricType.reps => LucideIcons.repeat,
  //     };
}

// class _ProgressBar extends StatelessWidget {
//   const _ProgressBar({required this.progress, required this.status});

//   final double progress;
//   final ExerciseStatus status;

//   @override
//   Widget build(BuildContext context) {
//     final color = switch (status) {
//       ExerciseStatus.pending => AppColors.textMuted,
//       ExerciseStatus.inProgress => AppColors.warning,
//       ExerciseStatus.completed => AppColors.primary,
//     };

//     return ClipRRect(
//       borderRadius: BorderRadius.circular(4),
//       child: SizedBox(
//         height: 6,
//         child: TweenAnimationBuilder<double>(
//           tween: Tween(begin: 0, end: progress),
//           duration: const Duration(milliseconds: 600),
//           curve: Curves.easeOutCubic,
//           builder: (context, value, _) {
//             return LinearProgressIndicator(
//               value: value,
//               backgroundColor: AppColors.surface,
//               valueColor: AlwaysStoppedAnimation(color),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
