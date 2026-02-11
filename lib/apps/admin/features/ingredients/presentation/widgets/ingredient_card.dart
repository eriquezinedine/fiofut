import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../domain/models/ingredient.dart';

class IngredientCard extends StatelessWidget {
  const IngredientCard({
    required this.ingredient,
    required this.onTap,
    required this.onDelete,
    super.key,
  });

  final Ingredient ingredient;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                LucideIcons.egg,
                color: AppColors.textMuted,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ingredient.name,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    ingredient.unit.displayName,
                    style: AppTextStyles.small.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _NutrientTag(
                        label: '${ingredient.calories.toStringAsFixed(0)} kcal',
                        color: AppColors.orange,
                      ),
                      const SizedBox(width: 6),
                      _NutrientTag(
                        label: '${ingredient.protein.toStringAsFixed(0)}g P',
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      _NutrientTag(
                        label: '${ingredient.carbohydrates.toStringAsFixed(0)}g C',
                        color: AppColors.info,
                      ),
                      const SizedBox(width: 6),
                      _NutrientTag(
                        label: '${ingredient.fat.toStringAsFixed(0)}g G',
                        color: AppColors.warning,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onDelete,
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  LucideIcons.trash2,
                  color: AppColors.textMuted,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NutrientTag extends StatelessWidget {
  const _NutrientTag({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}
