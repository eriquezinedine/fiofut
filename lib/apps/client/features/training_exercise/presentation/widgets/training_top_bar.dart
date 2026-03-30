import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class TrainingTopBar extends StatelessWidget {
  const TrainingTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TapScaleAnimation(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: AppSpacing.xs.all,
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.6),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.chevronLeft,
              color: AppColors.textPrimary,
              size: 22,
            ),
          ),
        ),
        AnimatedInfoIcon(
          icon: LucideIcons.info,
          onTap: () => showInfoDialog(context),
        ),
      ],
    );
  }

  static void showInfoDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.md),
        ),
        title: Text(
          'Información',
          style: AppTextStyles.h3.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Aquí encontrarás tu rutina de entrenamiento diario. '
          'Presiona "Iniciar Entrenamiento" para comenzar.',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Entendido',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
