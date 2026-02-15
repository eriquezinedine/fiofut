import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DeleteIngredientModal extends StatelessWidget {
  const DeleteIngredientModal._({
    required this.ingredientName,
  });

  final String ingredientName;

  /// Muestra el modal de confirmacion para eliminar un ingrediente.
  ///
  /// Retorna `true` si el usuario confirma la eliminacion, `null` si cancela.
  /// Nota: esto elimina el detalle (detail_food_ingredient), NO el ingrediente de la DB.
  static Future<bool?> show(
    BuildContext context, {
    required String ingredientName,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DeleteIngredientModal._(
        ingredientName: ingredientName,
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
          _buildWarningCard(),
          const SizedBox(height: AppSpacing.lg),
          _buildButtons(context),
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
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            LucideIcons.trash2,
            color: AppColors.error,
            size: 28,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Eliminar comida', style: AppTextStyles.h3),
      ],
    );
  }

  Widget _buildWarningCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppSpacing.borderRadiusLg,
      ),
      child: Column(
        children: [
          Text(
            'Estas seguro de eliminar',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            '"$ingredientName"',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.error,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            'de esta comida?',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: AppSpacing.buttonHeightLg,
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
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.pop(context, true),
            child: Container(
              height: AppSpacing.buttonHeightLg,
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: AppSpacing.borderRadiusLg,
              ),
              alignment: Alignment.center,
              child: Text(
                'Eliminar',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
