import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/pages/exercise_detail_page.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise_schedule_item.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/serie_table.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ScheduleExerciseCard extends StatelessWidget {
  const ScheduleExerciseCard({
    super.key,
    required this.item,
    required this.onToggleSet,
    required this.onAddSet,
  });

  final ExerciseScheduleItem item;
  final void Function(String setId, bool completed) onToggleSet;
  final VoidCallback onAddSet;

  bool get _isCardio => item.exerciseType == 'cardio';
  bool get _showKg => item.exerciseType != 'reps';

  String get _middleHeader {
    if (_isCardio) return 'Tiempo';
    return 'Repeticiones';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(
        ExerciseDetailPage.name,
        extra: {
          'exercise': item.toExercise(),
          'scheduleId': item.scheduleId,
        },
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card,
          border: Border.all(
            width: 1.5,
            color: item.isCompleted ? AppColors.primary : AppColors.card,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header: image + name + chips ──
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: item.exerciseImageUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            item.exerciseImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              LucideIcons.dumbbell,
                              color: AppColors.textMuted,
                              size: 22,
                            ),
                          ),
                        )
                      : const Icon(
                          LucideIcons.dumbbell,
                          color: AppColors.textMuted,
                          size: 22,
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.exerciseName,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          InfoChip(
                            label: '${item.totalSets} series',
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 6),
                          InfoChip(
                            label:
                                '${item.completedSets}/${item.totalSets}',
                            color: item.isCompleted
                                ? AppColors.success
                                : AppColors.warning,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // ── Series table ──
            if (item.sets.isNotEmpty) ...[
              const SizedBox(height: 12),
              SerieTableHeaders(
                middleHeader: _middleHeader,
                showKg: _showKg,
              ),
              const SizedBox(height: 4),
              ...item.sets.map(
                (set) => GestureDetector(
                  onTap: () => onToggleSet(set.id, !set.isCompleted),
                  child: SerieTableRow(
                    set: set,
                    isCardio: _isCardio,
                    showKg: _showKg,
                  ),
                ),
              ),
            ],

            // ── Add serie button ──
            const SizedBox(height: 8),
            GestureDetector(
              onTap: onAddSet,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: AppColors.green.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 16,
                      color: AppColors.green,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Agregar serie',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoChip extends StatelessWidget {
  const InfoChip({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}
