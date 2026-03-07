import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ConfirmSheet extends StatelessWidget {
  const ConfirmSheet({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.confirmText,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String confirmText;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.md),
            child: Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg - 4,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(title, style: AppTextStyles.h2),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    LucideIcons.x,
                    color: AppColors.textPrimary,
                    size: AppSpacing.iconMd,
                  ),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg - 4,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: AppSpacing.borderRadiusXl,
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: AppSpacing.borderRadiusMd,
                    ),
                    child: Icon(
                      icon,
                      color: AppColors.primary,
                      size: AppSpacing.iconMd,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      subtitle,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg - 4,
              AppSpacing.md,
              AppSpacing.lg - 4,
              AppSpacing.lg,
            ),
            child: Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'Cancelar',
                    onPressed: () => Navigator.pop(context, false),
                    fullWidth: true,
                    type: AppButtonType.secondary,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AppButton(
                    text: confirmText,
                    onPressed: () => Navigator.pop(context, true),
                    fullWidth: true,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).viewPadding.bottom + AppSpacing.xs,
          ),
        ],
      ),
    );
  }
}
