import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class IngredientOptionsModal extends StatelessWidget {
  const IngredientOptionsModal._({
    required this.ingredientName,
    required this.onEdit,
    required this.onDelete,
  });

  final String ingredientName;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  static Future<void> show(
    BuildContext context, {
    required String ingredientName,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => IngredientOptionsModal._(
        ingredientName: ingredientName,
        onEdit: onEdit,
        onDelete: onDelete,
      ),
    );
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
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xs,
        AppSpacing.lg,
        0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDragHandle(),
          const SizedBox(height: AppSpacing.md),
          _buildHeader(),
          const SizedBox(height: AppSpacing.lg),
          _buildOption(
            context,
            icon: LucideIcons.pencil,
            iconColor: AppColors.info,
            title: 'Editar cantidad',
            subtitle: 'Modificar la cantidad del ingrediente',
            onTap: onEdit,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildOption(
            context,
            icon: LucideIcons.trash2,
            iconColor: AppColors.error,
            title: 'Eliminar ingrediente',
            subtitle: 'Quitar de esta comida',
            onTap: onDelete,
          ),
          SizedBox(
            height: MediaQuery.of(context).viewPadding.bottom + AppSpacing.md,
          ),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(ingredientName, style: AppTextStyles.h3),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Selecciona una accion',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap?.call();
      },
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg - 4),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: AppSpacing.borderRadiusXl,
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.08),
                borderRadius: AppSpacing.borderRadiusLg,
              ),
              child: Icon(icon, color: iconColor, size: 26),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxxs),
                  Text(
                    subtitle,
                    style: AppTextStyles.small.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              LucideIcons.chevronRight,
              color: AppColors.textMuted,
              size: AppSpacing.iconSm,
            ),
          ],
        ),
      ),
    );
  }
}
