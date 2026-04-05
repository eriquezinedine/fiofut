import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise_schedule_item.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/add_exercise/add_exercise.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/excercise_card/excercise_card.dart';
import 'package:fio_fut/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ListExercise extends StatelessWidget {
  const ListExercise({super.key, required this.exercises, this.onDelete});

  final List<ExerciseScheduleItem> exercises;
  final void Function(String scheduleId)? onDelete;

  @override
  Widget build(BuildContext context) {
    if (exercises.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Column(
            spacing: 16,
            children: [
              OutLineButton(
                label: 'Agregar Ejercicio',
                onTap: () => AddExerciseModal.show(context),
              ),
              Text(
                'No hay ejercicios programados',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: exercises.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index == 0) {
          return OutLineButton(
            label: 'Agregar Ejercicio',
            onTap: () => AddExerciseModal.show(context),
          );
        }

        final item = exercises[index - 1];
        final card = ExerciseCard(
          item: item,
          allExercises: exercises,
          index: index,
        );

        if (onDelete == null) return card;

        return Dismissible(
          key: ValueKey(item.scheduleId),
          direction: DismissDirection.endToStart,
          confirmDismiss: (_) async {
            return await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor: AppColors.card,
                title: Text(
                  'Eliminar ejercicio',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.white,
                  ),
                ),
                content: Text(
                  'Se eliminará "${item.exerciseName}" de tu plan.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: Text(
                      'Cancelar',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: Text(
                      'Eliminar',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          onDismissed: (_) => onDelete!(item.scheduleId),
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              LucideIcons.trash2,
              color: AppColors.error,
              size: 24,
            ),
          ),
          child: card,
        );
      },
    );
  }
}
