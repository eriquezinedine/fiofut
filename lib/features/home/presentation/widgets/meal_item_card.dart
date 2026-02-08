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
          crossAxisAlignment: CrossAxisAlignment.center,
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
                        icon: LucideIcons.beef,
                        iconColor: AppColors.redBright,
                        value: '${mealItem.protein}g',
                      ),
                      const SizedBox(width: 12),
                      _MacroBadge(
                        icon: LucideIcons.wheat,
                        iconColor: AppColors.orange,
                        value: '${mealItem.carbs}g',
                      ),
                      const SizedBox(width: 12),
                      _MacroBadge(
                        icon: LucideIcons.droplet,
                        iconColor: AppColors.blue,
                        value: '${mealItem.fat}g',
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
      color: AppColors.surfaceAlt,
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
      // Completed badge - green/lime
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.checkCircle,
            color: AppColors.primary,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            'Completado',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
        ],
      );
    } else {
      // Pending badge - grey with time
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LucideIcons.clock4,
            color: AppColors.textMuted,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            mealItem.time ?? '',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
            ),
          ),
        ],
      );
    }
  }
}

/// Macro badge with icon.
class _MacroBadge extends StatelessWidget {
  const _MacroBadge({
    required this.icon,
    required this.iconColor,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 14,
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}
