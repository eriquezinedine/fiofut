import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise_schedule_item.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/excercise_card/excercise_card_header.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/excercise_card/excercise_card_image.dart';
import 'package:fio_fut/apps/client/features/training_exercise/presentation/screens/training_exercise_screen.dart';
import 'package:fio_fut/core/widgets/status_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ExerciseCard extends ConsumerWidget {
  const ExerciseCard({
    super.key,
    required this.item,
    required this.allExercises,
    required this.index,
    this.style2 = false,
    this.isSelected = false,
    this.onTap,
  });

  final ExerciseScheduleItem item;
  final List<ExerciseScheduleItem> allExercises;
  final int index;
  final bool style2;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercise = item.toExercise();
    final isCompleted = item.isCompleted;
    final separator = Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
      child: CircleAvatar(
        radius: 2,
        backgroundColor: AppColors.textDescription,
      ),
    );

    return CustomGestureDetector(
      onTap:
          onTap ??
          () async {
            if (style2) {
              return;
            }
            final result = await context.pushNamed<bool>(
              // WorkoutFlowPage.name,
              TrainingExerciseScreen.name,
              extra: {'exercises': allExercises, 'initialIndex': index},
            );
            // if (!context.mounted) return;
            // if (result == true) {
            //   WorkoutCompleteModal.show(context);
            // }
          },
      child: Container(
        // padding: style2? AppSpacing.sm.vertical : const EdgeInsets.all(12),
        padding: AppSpacing.sm.all,
        decoration: BoxDecoration(
          color: style2 ? Colors.transparent : AppColors.card,
          border: Border.all(
            width: 1.5,
            color: isSelected
                ? AppColors.primary
                : (style2 ? Colors.transparent : AppColors.card),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              ExcerciseCardImage(exercise: exercise, style2: style2),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExcerciseCardHeader(exercise: exercise, style2: style2),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _label('${item.totalSets} series'),
                        separator,
                        _label('${item.repsPerSet} reps'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    StatusWidget(isCompleted: isCompleted),
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
        color: AppColors.textDescription,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
