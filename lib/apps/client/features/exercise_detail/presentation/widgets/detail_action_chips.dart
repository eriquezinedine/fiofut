import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/core/widgets/modal/exercise_instruction_modal.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise.dart';

class DetailActionChips extends StatelessWidget {
  const DetailActionChips({
    required this.exercise,
    required this.duration,
    super.key,
  });

  final Exercise exercise;
  final Duration duration;

  String get _durationLabel {
    final m = duration.inMinutes.toString().padLeft(2, '0');
    final s = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: AppSpacing.xs,
          children: [
            _Chip(
              icon: LucideIcons.timer,
              label: _durationLabel,
            ),
            _Chip(
              icon: LucideIcons.playCircle,
              label: 'Instrucciones',
              onTap: () => ExerciseInstructionModal.show(
                context,
                exercise: exercise,
              ),
            ),
            _Chip(
              icon: LucideIcons.barChart2,
              label: 'Analíticas',
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CustomGestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xxs + 2,
        ),
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.xxs,
          children: [
            Icon(icon, color: AppColors.white, size: 14),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
