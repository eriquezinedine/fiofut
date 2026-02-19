import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../domain/models/trainer_schedule.dart';

/// Widget que muestra la lista de horarios del entrenador.
class ScheduleList extends StatelessWidget {
  const ScheduleList({
    required this.schedule,
    super.key,
  });

  final TrainerSchedule schedule;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now().weekday;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppSpacing.borderRadiusLg,
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        children: [
          for (int i = 0; i < schedule.days.length; i++) ...[
            _DayScheduleItem(
              daySchedule: schedule.days[i],
              isToday: schedule.days[i].dayOfWeek == today,
            ),
            if (i < schedule.days.length - 1)
              Divider(
                height: 1,
                color: AppColors.border.withValues(alpha: 0.3),
                indent: AppSpacing.md,
                endIndent: AppSpacing.md,
              ),
          ],
        ],
      ),
    );
  }
}

class _DayScheduleItem extends StatelessWidget {
  const _DayScheduleItem({
    required this.daySchedule,
    required this.isToday,
  });

  final DaySchedule daySchedule;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final isActive = daySchedule.isActiveNow();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: isActive
          ? BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.05),
            )
          : null,
      child: Row(
        children: [
          // Day indicator
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isToday
                  ? AppColors.roleTrainer.withValues(alpha: 0.12)
                  : AppColors.surface,
              borderRadius: AppSpacing.borderRadiusMd,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  daySchedule.shortDayName,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: isToday
                        ? AppColors.roleTrainer
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
                if (isActive)
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Day name
          SizedBox(
            width: 72,
            child: Text(
              daySchedule.dayName,
              style: AppTextStyles.titleSmall.copyWith(
                color: isToday ? AppColors.white : AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Slots
          Expanded(
            child: Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xxs,
              children: daySchedule.slots
                  .map((slot) => _SlotChip(
                        slot: slot,
                        isActive: slot.isActiveNow() && isToday,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SlotChip extends StatelessWidget {
  const _SlotChip({
    required this.slot,
    required this.isActive,
  });

  final ScheduleSlot slot;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.success.withValues(alpha: 0.12)
            : AppColors.surface,
        borderRadius: AppSpacing.borderRadiusSm,
        border: isActive
            ? Border.all(
                color: AppColors.success.withValues(alpha: 0.3),
              )
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.clock,
            size: 10,
            color: isActive ? AppColors.success : AppColors.textMuted,
          ),
          const SizedBox(width: 4),
          Text(
            '${slot.formattedStart} - ${slot.formattedEnd}',
            style: AppTextStyles.labelSmall.copyWith(
              fontSize: 10,
              color: isActive ? AppColors.success : AppColors.textMuted,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
