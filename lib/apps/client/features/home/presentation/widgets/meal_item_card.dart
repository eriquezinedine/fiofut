import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/home/domain/models/models.dart';
import 'package:fio_fut/core/widgets/status_widget.dart';
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
          border: Border.all(
            width: 1.5,
            color: mealItem.isCompleted?  AppColors.primary :AppColors.card 
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 80,
                  height: double.infinity,
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
                            fontSize: 16,
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
                    const SizedBox(height: 6),
                                          _buildStatusBadge(),
          
                  ],
                ),
              ),
            ],
          ),
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
    return StatusWidget(isCompleted: mealItem.isCompleted,);
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
