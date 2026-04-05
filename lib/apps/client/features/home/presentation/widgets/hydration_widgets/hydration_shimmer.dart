import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class HydrationShimmer extends StatelessWidget {
  const HydrationShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Circle shimmer
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.card,
              ),
            ),
            const SizedBox(height: 16),
            const AppShimmerBox(width: 140, height: 18),

            const SizedBox(height: 32),

            // "Añadir agua" title
            const Align(
              alignment: Alignment.centerLeft,
              child: AppShimmerBox(width: 120, height: 20),
            ),
            const SizedBox(height: 16),

            // 3 glass buttons
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // "Cantidad personalizada" title
            const Align(
              alignment: Alignment.centerLeft,
              child: AppShimmerBox(width: 180, height: 20),
            ),
            const SizedBox(height: 12),

            // Input shimmer
            const AppShimmerBox(
              width: double.infinity,
              height: 56,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),

            const SizedBox(height: 32),

            // "Historial" title
            const Align(
              alignment: Alignment.centerLeft,
              child: AppShimmerBox(width: 100, height: 20),
            ),
            const SizedBox(height: 12),

            // History records
            const AppShimmerBox(
              width: double.infinity,
              height: 52,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            const SizedBox(height: 8),
            const AppShimmerBox(
              width: double.infinity,
              height: 52,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            const SizedBox(height: 8),
            const AppShimmerBox(
              width: double.infinity,
              height: 52,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ],
        ),
      ),
    );
  }
}
