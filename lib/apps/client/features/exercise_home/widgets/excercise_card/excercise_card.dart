import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/pages/workout_flow_page.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/widgets/workout_complete_modal.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise_schedule_item.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/providers/exercise_home_provider.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/excercise_card/excercise_card_header.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/excercise_card/excercise_card_image.dart';
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
  });

  final ExerciseScheduleItem item;
  final List<ExerciseScheduleItem> allExercises;
  final int index;

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

    return GestureDetector(
      onTap: () async {
        final result = await context.pushNamed<bool>(
          WorkoutFlowPage.name,
          extra: {
            'exercises': allExercises,
            'initialIndex': index,
          },
        );
        if (!context.mounted) return;
        ref.read(exerciseHomeProvider.notifier).reload();
        if (result == true) {
          WorkoutCompleteModal.show(context);
        }
      },
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExcerciseCardHeader(exercise: exercise),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _label('${item.totalSets} series'),
                        separator,
                        _label('${item.repsPerSet} reps'),
                        if (_weightText != null) ...[
                          separator,
                          _label(_weightText!),
                        ],
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

  String? get _weightText {
    if (item.sets.isEmpty) return null;
    final w = item.sets.first.weight;
    if (w == null) return null;
    return '${w == w.roundToDouble() ? w.toInt() : w} kg';
  }

  Text _label(String text) {
    return Text(
      text,
      style: AppTextStyles.labelLarge.copyWith(color: AppColors.textDescription),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
