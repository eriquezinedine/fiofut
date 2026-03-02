import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/presentation/pages/exercise_detail_page.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise_schedule_item.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/providers/exercise_home_provider.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/add_exercise/add_exercise.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/muscle_reset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ExerciseHomePage extends ConsumerWidget {
  const ExerciseHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercises = ref.watch(exerciseHomeProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
      children: [
        const MuscleReset(),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GestureDetector(
            onTap: () => AddExerciseModal.show(
              context,
              exercises: const [],
              recentExercises: const [],
              onConfirm: (selected) {
                // TODO: agregar ejercicios seleccionados al schedule
              },
            ),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ejercicios',
                    style: AppTextStyles.h3
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        LucideIcons.plus,
                        color: AppColors.textDescription,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Agregar ejercicios',
                        style: AppTextStyles.caption
                            .copyWith(color: AppColors.textDescription),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        if (exercises.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Text(
                'No hay ejercicios programados',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          )
        else
          ...exercises.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Dismissible(
                key: ValueKey(item.scheduleId),
                direction: DismissDirection.endToStart,
                confirmDismiss: (_) async {
                  return await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: AppColors.card,
                      title: Text(
                        'Eliminar ejercicio',
                        style: AppTextStyles.bodyLarge
                            .copyWith(color: AppColors.white),
                      ),
                      content: Text(
                        'Se eliminará "${item.exerciseName}" de tu plan.',
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: AppColors.textSecondary),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: Text(
                            'Cancelar',
                            style: AppTextStyles.caption
                                .copyWith(color: AppColors.textMuted),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: Text(
                            'Eliminar',
                            style: AppTextStyles.caption
                                .copyWith(color: AppColors.error),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                onDismissed: (_) {
                  ref
                      .read(exerciseHomeProvider.notifier)
                      .deleteSchedule(item.scheduleId);
                },
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
                child: _ScheduleExerciseCard(
                  item: item,
                  onToggleSet: (setId, completed) {
                    ref
                        .read(exerciseHomeProvider.notifier)
                        .toggleSet(setId, completed);
                  },
                  onAddSet: () {
                    ref
                        .read(exerciseHomeProvider.notifier)
                        .addSet(
                          item.scheduleId,
                          item.exerciseType ?? 'strength',
                        );
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ScheduleExerciseCard extends StatelessWidget {
  const _ScheduleExerciseCard({
    required this.item,
    required this.onToggleSet,
    required this.onAddSet,
  });

  final ExerciseScheduleItem item;
  final void Function(String setId, bool completed) onToggleSet;
  final VoidCallback onAddSet;

  bool get _isCardio => item.exerciseType == 'cardio';

  /// Whether to show the Kg column (strength and cardio use weight).
  bool get _showKg => item.exerciseType != 'reps';

  String get _middleHeader {
    if (_isCardio) return 'Mins : Segs';
    return 'Repeticiones';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(
        ExerciseDetailPage.name,
        extra: item.toExercise(),
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
                          _InfoChip(
                            label: '${item.totalSets} series',
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 6),
                          _InfoChip(
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

            // ── Series table (same layout as detail widgets) ──
            if (item.sets.isNotEmpty) ...[
              const SizedBox(height: 12),

              // Column headers
              _SerieTableHeaders(
                middleHeader: _middleHeader,
                showKg: _showKg,
              ),
              const SizedBox(height: 4),

              // Rows
              ...item.sets.map(
                (set) => GestureDetector(
                  onTap: () => onToggleSet(set.id, !set.isCompleted),
                  child: _SerieTableRow(
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

// ── Serie table headers (mirrors _SerieHeaders from detail) ──

class _SerieTableHeaders extends StatelessWidget {
  const _SerieTableHeaders({
    required this.middleHeader,
    this.showKg = true,
  });

  final String middleHeader;
  final bool showKg;

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyles.caption.copyWith(
      fontWeight: FontWeight.w500,
      color: AppColors.textDescription,
    );

    return Row(
      children: [
        SizedBox(
          width: 40,
          child: Text('Serie', textAlign: TextAlign.center, style: style),
        ),
        const SizedBox(width: 8),
        Expanded(
          child:
              Text(middleHeader, textAlign: TextAlign.center, style: style),
        ),
        if (showKg) ...[
          const SizedBox(width: 8),
          Expanded(
            child: Text('Kg', textAlign: TextAlign.center, style: style),
          ),
        ],
      ],
    );
  }
}

// ── Serie table row (mirrors _SerieRowByKg / ByKm / RetryOnly) ──

class _SerieTableRow extends StatelessWidget {
  const _SerieTableRow({
    required this.set,
    required this.isCardio,
    required this.showKg,
  });

  final ExerciseSetData set;
  final bool isCardio;
  final bool showKg;

  @override
  Widget build(BuildContext context) {
    final completed = set.isCompleted;
    final bgColor = completed
        ? AppColors.primary
        : AppColors.backgroundSecondary;
    final textColor = completed ? AppColors.black : AppColors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          // Serie number / check
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: completed
                ? Icon(LucideIcons.check, color: AppColors.black, size: 16)
                : Text(
                    '${set.setNumber}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
          const SizedBox(width: 8),

          // Middle column: reps or mins:segs
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                isCardio ? _formatTime() : '${set.repetitions ?? 0}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // Kg column (strength & cardio)
          if (showKg) ...[
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  _formatKg(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime() {
    final mins = set.minutes ?? 0;
    final secs = set.seconds ?? 0;
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }

  String _formatKg() {
    final kg = set.weight ?? 0;
    return kg == kg.roundToDouble() ? kg.toInt().toString() : kg.toString();
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.color});

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
