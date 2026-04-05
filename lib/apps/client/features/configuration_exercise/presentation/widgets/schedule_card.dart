import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:model/model.dart';

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({
    super.key,
    required this.schedule,
    this.onTapEdit,
    this.onTapDelete,
  });

  final ExerciseSchedule schedule;
  final VoidCallback? onTapEdit;
  final VoidCallback? onTapDelete;

  @override
  Widget build(BuildContext context) {
    final expired = schedule.isExpired;

    return Opacity(
      opacity: expired ? 0.5 : 1.0,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: image + name + actions
            Row(
              children: [
                // Exercise image
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  child: schedule.exerciseImageUrl != null
                      ? Image.network(
                          schedule.exerciseImageUrl!,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _PlaceholderIcon(),
                        )
                      : _PlaceholderIcon(),
                ),
                const SizedBox(width: 12),

                // Name + muscle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        schedule.exerciseName,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (schedule.muscleName != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          schedule.muscleName!,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Actions
                if (onTapEdit != null)
                  _ActionIcon(
                    icon: LucideIcons.pencil,
                    color: AppColors.primary,
                    onTap: onTapEdit,
                  ),
                if (onTapDelete != null) ...[
                  const SizedBox(width: 4),
                  _ActionIcon(
                    icon: LucideIcons.trash2,
                    color: AppColors.error,
                    onTap: onTapDelete,
                  ),
                ],
              ],
            ),

            const SizedBox(height: 12),

            // Days chips
            Row(
              children: schedule.dayLabels
                  .map((label) => Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: _DayBadge(label: label),
                      ))
                  .toList(),
            ),

            const SizedBox(height: 10),

            // Date range + summary
            Row(
              children: [
                const Icon(
                  LucideIcons.calendarDays,
                  color: AppColors.textSecondary,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  schedule.dateRangeText,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                Text(
                  '${schedule.totalSessions} sesiones · ${schedule.totalWeeks} sem',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),

            if (expired) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  'Finalizado',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PlaceholderIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: const Icon(
        LucideIcons.dumbbell,
        color: AppColors.textMuted,
        size: 22,
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    required this.icon,
    required this.color,
    this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 16),
      ),
    );
  }
}

class _DayBadge extends StatelessWidget {
  const _DayBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
