import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../domain/providers/food_provider_detail.dart';

class FoodNutritionCard extends StatelessWidget {
  const FoodNutritionCard({super.key, required this.result});

  final FoodRecognitionResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppSpacing.borderRadiusXl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumen nutricional',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _NutrientBox(
                icon: LucideIcons.flame,
                value: result.totalCalories.toStringAsFixed(0),
                label: 'kcal',
                color: AppColors.orange,
              ),
              const SizedBox(width: AppSpacing.sm),
              _NutrientBox(
                icon: LucideIcons.beef,
                value: '${result.totalProtein.toStringAsFixed(1)}g',
                label: 'Proteina',
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.sm),
              _NutrientBox(
                icon: LucideIcons.wheat,
                value: '${result.totalCarbohydrates.toStringAsFixed(1)}g',
                label: 'Carbos',
                color: AppColors.info,
              ),
              const SizedBox(width: AppSpacing.sm),
              _NutrientBox(
                icon: LucideIcons.droplet,
                value: '${result.totalFat.toStringAsFixed(1)}g',
                label: 'Grasas',
                color: AppColors.warning,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NutrientBox extends StatelessWidget {
  const _NutrientBox({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: AppSpacing.borderRadiusMd,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xxxs),
          Text(
            label,
            style:
                AppTextStyles.small.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
