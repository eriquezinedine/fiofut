import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class RegisterFoodModal extends StatelessWidget {
  const RegisterFoodModal._({
    required this.onTakePhoto,
    required this.onSearchFood,
  });

  final VoidCallback? onTakePhoto;
  final VoidCallback? onSearchFood;

  static Future<void> show(
    BuildContext context, {
    VoidCallback? onTakePhoto,
    VoidCallback? onSearchFood,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RegisterFoodModal._(
        onTakePhoto: onTakePhoto,
        onSearchFood: onSearchFood,
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
            icon: LucideIcons.camera,
            iconColor: AppColors.primary,
            title: 'Tomar Foto',
            subtitle: 'Escanea tu comida con la cámara',
            onTap: onTakePhoto,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildOption(
            context,
            icon: LucideIcons.search,
            iconColor: AppColors.purple,
            title: 'Buscar Alimento',
            subtitle: 'Busca en nuestra base de datos',
            onTap: onSearchFood,
          ),
          // const SizedBox(height: AppSpacing.lg),
          // _buildCancelButton(context),
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
        Text('Registrar Comida', style: AppTextStyles.h3),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Elige cómo quieres registrar tu comida',
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

  Widget _buildCancelButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: AppSpacing.borderRadiusLg,
          border: Border.all(color: AppColors.surfaceAlt),
        ),
        alignment: Alignment.center,
        child: Text(
          'Cancelar',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
