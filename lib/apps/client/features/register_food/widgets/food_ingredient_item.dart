import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

import '../domain/food_category_extension.dart';
import '../domain/providers/food_provider_detail.dart';

class FoodIngredientItem extends StatelessWidget {
  const FoodIngredientItem({
    super.key,
    required this.ingredient,
    this.onTap,
  });

  final RecognizedIngredient ingredient;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = ingredient.category.categoryColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: AppSpacing.borderRadiusMd,
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: AppSpacing.borderRadiusSm,
                ),
                child: Icon(
                  ingredient.category.categoryIcon,
                  color: color,
                  size: 18,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            ingredient.name,
                            style:
                                AppTextStyles.bodyMedium.copyWith(fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '${ingredient.quantity.toStringAsFixed(0)} ${ingredient.unitAbbreviation}',
                          style: AppTextStyles.small.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _MiniChip(
                          text:
                              '${ingredient.totalCalories.toStringAsFixed(0)} kcal',
                          color: AppColors.orange,
                        ),
                        const SizedBox(width: 6),
                        _MiniChip(
                          text:
                              '${ingredient.totalProtein.toStringAsFixed(1)}g P',
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        _MiniChip(
                          text:
                              '${ingredient.totalCarbohydrates.toStringAsFixed(1)}g C',
                          color: AppColors.info,
                        ),
                        const SizedBox(width: 6),
                        _MiniChip(
                          text:
                              '${ingredient.totalFat.toStringAsFixed(1)}g G',
                          color: AppColors.warning,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  const _MiniChip({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
