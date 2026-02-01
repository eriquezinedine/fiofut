import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/features/home/domain/models/models.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Card widget for displaying a meal or exercise item matching the design.
class MealItemCard extends StatelessWidget {
  const MealItemCard({
    required this.mealItem,
    this.onTap,
    super.key,
  });

  final MealItem mealItem;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 80,
                height: 80,
                child: mealItem.imageUrl.isNotEmpty
                    ? Image.network(
                        mealItem.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildPlaceholder(),
                      )
                    : _buildPlaceholder(),
              ),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and status badge row
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          mealItem.name,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Status badge
                      _buildStatusBadge(),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Calories row
                  Row(
                    children: [
                      const Icon(
                        LucideIcons.flame,
                        color: AppColors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${mealItem.calories} calorías',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Macros row
                  Row(
                    children: [
                      _MacroBadge(
                        value: '${mealItem.protein}g',
                        color: AppColors.green,
                      ),
                      const SizedBox(width: 12),
                      _MacroBadge(
                        value: '${mealItem.carbs}g',
                        color: AppColors.orange,
                      ),
                      const SizedBox(width: 12),
                      _MacroBadge(
                        value: '${mealItem.fat}g',
                        color: AppColors.purple,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.border,
      child: Center(
        child: Icon(
          mealItem.type == MealItemType.meal
              ? LucideIcons.utensils
              : LucideIcons.activity,
          color: AppColors.textMuted,
          size: 32,
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    if (mealItem.isCompleted) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.green.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.checkCircle,
              color: AppColors.green,
              size: 14,
            ),
            const SizedBox(width: 4),
            Text(
              'Completado',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.green,
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.orange.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.clock,
              color: AppColors.orange,
              size: 14,
            ),
            const SizedBox(width: 4),
            Text(
              'Pendiente',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.orange,
              ),
            ),
          ],
        ),
      );
    }
  }
}

class _MacroBadge extends StatelessWidget {
  const _MacroBadge({
    required this.value,
    required this.color,
  });

  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
