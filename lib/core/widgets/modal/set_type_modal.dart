import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/domain/models/serie_set.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

enum SetTypeAction { normal, warmup, dropset, delete }

class SetTypeModal extends StatelessWidget {
  const SetTypeModal._();

  static Future<SetTypeAction?> show(BuildContext context) {
    return showModalBottomSheet<SetTypeAction>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SetTypeModal._(),
    );
  }

  /// Maps a SetTypeAction to the corresponding SetType (null for delete).
  static SetType? toSetType(SetTypeAction action) {
    return switch (action) {
      SetTypeAction.normal => SetType.normal,
      SetTypeAction.warmup => SetType.warmup,
      SetTypeAction.dropset => SetType.dropset,
      SetTypeAction.delete => null,
    };
  }

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
                  child: Text(
                    'Tipo de serie',
                    style: AppTextStyles.h2,
                  ),
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
          // Options
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg - 4,
            ),
            child: Column(
              children: [
                _OptionTile(
                  icon: LucideIcons.dumbbell,
                  iconColor: AppColors.textPrimary,
                  title: 'Serie normal',
                  subtitle: 'Serie estándar de entrenamiento',
                  onTap: () => Navigator.pop(context, SetTypeAction.normal),
                ),
                const SizedBox(height: AppSpacing.sm),
                _OptionTile(
                  icon: LucideIcons.flame,
                  iconColor: AppColors.orange,
                  title: 'Serie calentamiento',
                  subtitle: 'Preparación antes de la carga',
                  onTap: () => Navigator.pop(context, SetTypeAction.warmup),
                ),
                const SizedBox(height: AppSpacing.sm),
                _OptionTile(
                  icon: LucideIcons.arrowDown,
                  iconColor: AppColors.error,
                  title: 'Dropset',
                  subtitle: 'Reducción de peso sin descanso',
                  onTap: () => Navigator.pop(context, SetTypeAction.dropset),
                ),
                const SizedBox(height: AppSpacing.sm),
                _OptionTile(
                  icon: LucideIcons.trash2,
                  iconColor: AppColors.error,
                  title: 'Eliminar serie',
                  subtitle: 'Quitar esta serie del ejercicio',
                  onTap: () => Navigator.pop(context, SetTypeAction.delete),
                  isDanger: true,
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).viewPadding.bottom + AppSpacing.lg,
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDanger = false,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDanger;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xs,
          AppSpacing.xs,
          AppSpacing.md,
          AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isDanger
              ? AppColors.error.withValues(alpha: 0.08)
              : AppColors.card,
          borderRadius: AppSpacing.borderRadiusXl,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: AppSpacing.borderRadiusMd,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 22,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDanger ? AppColors.error : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: isDanger
                          ? AppColors.error.withValues(alpha: 0.7)
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              LucideIcons.chevronRight,
              color: isDanger ? AppColors.error : AppColors.textMuted,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
