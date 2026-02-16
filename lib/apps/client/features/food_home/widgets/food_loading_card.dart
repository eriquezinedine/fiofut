import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// Shimmer card matching MealItemCard dimensions while food is being processed.
class FoodLoadingCard extends StatelessWidget {
  const FoodLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Image placeholder
            AppShimmerBox(
              width: 80,
              height: 80,
              borderRadius: BorderRadius.circular(12),
            ),
            const SizedBox(width: 12),
            // Content placeholders
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppShimmerBox(
                    width: 140,
                    height: 16,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 10),
                  AppShimmerBox(
                    width: 100,
                    height: 14,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      AppShimmerBox(
                        width: 40,
                        height: 12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(width: 12),
                      AppShimmerBox(
                        width: 40,
                        height: 12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(width: 12),
                      AppShimmerBox(
                        width: 40,
                        height: 12,
                        borderRadius: BorderRadius.circular(4),
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
}
