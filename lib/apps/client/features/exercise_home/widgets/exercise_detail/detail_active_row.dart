import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise.dart';

enum _RowState { pending, current, completed }

class DetailActiveRow extends StatelessWidget {
  const DetailActiveRow({
    required this.index,
    required this.reps,
    required this.metricType,
    this.weightKg,
    this.time,
    this.isCurrent = false,
    this.isCompleted = false,
    super.key,
  });

  final int index;
  final int reps;
  final MetricType metricType;
  final int? weightKg;
  final Duration? time;
  final bool isCurrent;
  final bool isCompleted;

  _RowState get _state {
    if (isCompleted) return _RowState.completed;
    if (isCurrent) return _RowState.current;
    return _RowState.pending;
  }

  @override
  Widget build(BuildContext context) {
    final isActive = _state != _RowState.pending;
    final bg = isActive ? AppColors.primary : AppColors.card;
    final textColor = isActive ? AppColors.black : AppColors.white;

    return Row(
      spacing: AppSpacing.xs,
      children: [
        // Serie indicator
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.card,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: isCompleted
              ? const Icon(LucideIcons.check, color: AppColors.black, size: 18)
              : Text(
                  '${index + 1}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isCurrent ? AppColors.black : AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),

        // Reps field
        if (metricType != MetricType.cardio)
          Expanded(
            child: _ValueCell(
              value: '$reps',
              isActive: isActive,
              bg: bg,
              textColor: textColor,
            ),
          ),

        // Time field (time case)
        if (metricType == MetricType.cardio)
          Expanded(
            child: _ValueCell(
              value: _formatDuration(time),
              isActive: isActive,
              bg: bg,
              textColor: textColor,
            ),
          ),

        // Kg field (weight & time cases)
        if (metricType == MetricType.strength || metricType == MetricType.cardio)
          Expanded(
            child: _ValueCell(
              value: weightKg != null ? '$weightKg' : '0',
              isActive: isActive,
              bg: bg,
              textColor: textColor,
            ),
          ),
      ],
    );
  }

  String _formatDuration(Duration? d) {
    if (d == null) return '00:00';
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

class _ValueCell extends StatelessWidget {
  const _ValueCell({
    required this.value,
    required this.isActive,
    required this.bg,
    required this.textColor,
  });

  final String value;
  final bool isActive;
  final Color bg;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Text(
        value,
        style: AppTextStyles.bodyMedium.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
