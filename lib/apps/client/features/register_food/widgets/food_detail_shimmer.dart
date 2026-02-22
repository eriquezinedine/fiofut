import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class FoodAnalyzingState extends StatelessWidget {
  const FoodAnalyzingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: AppSpacing.cardPadding,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: AppSpacing.borderRadiusLg,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Analizando tu comida con IA...',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const FoodContentShimmer(),
      ],
    );
  }
}

class FoodContentShimmer extends StatelessWidget {
  const FoodContentShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppShimmerBox(width: 220, height: 24),
          const SizedBox(height: AppSpacing.xs),
          const AppShimmerBox(width: 80, height: 22),
          const SizedBox(height: AppSpacing.sm),
          const AppShimmerBox(width: double.infinity, height: 16),
          const SizedBox(height: AppSpacing.xs),
          const AppShimmerBox(width: 260, height: 16),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: AppSpacing.cardPadding,
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: AppSpacing.borderRadiusXl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppShimmerBox(width: 160, height: 20),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(4, (_) => const _NutrientShimmer()),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const AppShimmerBox(width: 140, height: 20),
          const SizedBox(height: AppSpacing.sm),
          ...List.generate(3, (_) => const _IngredientShimmer()),
        ],
      ),
    );
  }
}

class _NutrientShimmer extends StatelessWidget {
  const _NutrientShimmer();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        AppShimmerBox(
          width: 48,
          height: 48,
          borderRadius:
              BorderRadius.all(Radius.circular(AppSpacing.radiusMd)),
        ),
        SizedBox(height: AppSpacing.xs),
        AppShimmerBox(width: 40, height: 14),
        SizedBox(height: AppSpacing.xxxs),
        AppShimmerBox(width: 48, height: 12),
      ],
    );
  }
}

class _IngredientShimmer extends StatelessWidget {
  const _IngredientShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: AppSpacing.borderRadiusMd,
        ),
        child: const Row(
          children: [
            AppShimmerBox(
              width: 36,
              height: 36,
              borderRadius:
                  BorderRadius.all(Radius.circular(AppSpacing.radiusSm)),
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppShimmerBox(width: 140, height: 14),
                  SizedBox(height: 6),
                  AppShimmerBox(width: 200, height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
