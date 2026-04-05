import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_stats/presentation/widgets/stats_chart_placeholder.dart';
import 'package:fio_fut/apps/client/features/progress/domain/providers/food_stats_provider.dart';
import 'package:fio_fut/apps/client/features/progress/presentation/widgets/selecter_date_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ProgressFoodTab extends ConsumerStatefulWidget {
  const ProgressFoodTab({super.key});

  @override
  ConsumerState<ProgressFoodTab> createState() => _ProgressFoodTabState();
}

class _ProgressFoodTabState extends ConsumerState<ProgressFoodTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(foodStatsProvider.notifier).load();
    });
  }

  static const _nutrientLabels = ['Calorías', 'Proteínas', 'Carbs', 'Grasas'];
  static const _nutrientUnits = [' kcal', ' g', ' g', ' g'];
  static const _nutrientColors = [
    AppColors.orange,
    AppColors.error,
    AppColors.blue,
    AppColors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final state = ref.watch(foodStatsProvider);

    return switch (state) {
      FoodStatsInitial() || FoodStatsLoading() => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      FoodStatsError(message: final msg) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              LucideIcons.alertTriangle,
              color: AppColors.error,
              size: 48,
            ),
            AppSpacing.verticalMd,
            Text(
              msg,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            AppSpacing.verticalLg,
            ElevatedButton(
              onPressed: () => ref.read(foodStatsProvider.notifier).load(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.black,
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
      final FoodStatsLoaded loaded => _buildLoaded(loaded),
    };
  }

  Widget _buildLoaded(FoodStatsLoaded loaded) {
    final notifier = ref.read(foodStatsProvider.notifier);
    final filteredData = notifier.filteredData(loaded);
    final avgs = notifier.filteredAverages(loaded);
    final nutrient = loaded.selectedNutrient;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      children: [
        // Date selector
        SelecterDateCustom(
          onDateRangeChanged: (range) {
            notifier.setDateRange(range.start, range.end);
          },
        ),
        AppSpacing.verticalMd,
        // Summary cards
        IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: _DailySummaryCard(
                  calories: avgs.avgCalories,
                  protein: avgs.avgProtein,
                  carbs: avgs.avgCarbs,
                  fat: avgs.avgFat,
                ),
              ),
              AppSpacing.horizontalSm,
              Expanded(
                child: _CalorieDistributionCard(
                  protein: avgs.avgProtein,
                  carbs: avgs.avgCarbs,
                  fat: avgs.avgFat,
                ),
              ),
            ],
          ),
        ),

        AppSpacing.verticalMd,

        // Nutrient tabs
        _NutrientTabs(
          selected: nutrient,
          onChanged: (i) => notifier.setNutrient(i),
        ),

        AppSpacing.verticalMd,

        // Chart
        StatsChartPlaceholder(
          title: _nutrientLabels[nutrient],
          points: filteredData,
          lineColor: _nutrientColors[nutrient],
          unit: _nutrientUnits[nutrient],
        ),

        AppSpacing.verticalXxl,
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Promedio Diario Card
// ---------------------------------------------------------------------------

class _DailySummaryCard extends StatelessWidget {
  const _DailySummaryCard({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.orange.withValues(alpha: 0.15),
              borderRadius: AppSpacing.borderRadiusSm,
            ),
            child: const Icon(
              LucideIcons.flame,
              color: AppColors.orange,
              size: 20,
            ),
          ),
          AppSpacing.verticalSm,
          Text(
            '${calories.toInt()} kcal',
            style: AppTextStyles.h3.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Promedio Diario',
            style: AppTextStyles.small.copyWith(color: AppColors.textSecondary),
          ),
          AppSpacing.verticalSm,
          Row(
            children: [
              _MiniNutrient(
                value: '${protein.toInt()}g',
                color: AppColors.error,
              ),
              const SizedBox(width: 8),
              _MiniNutrient(value: '${carbs.toInt()}g', color: AppColors.blue),
              const SizedBox(width: 8),
              _MiniNutrient(value: '${fat.toInt()}g', color: AppColors.purple),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniNutrient extends StatelessWidget {
  const _MiniNutrient({required this.value, required this.color});
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 3),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Distribución Card
// ---------------------------------------------------------------------------

class _CalorieDistributionCard extends StatelessWidget {
  const _CalorieDistributionCard({
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  final double protein;
  final double carbs;
  final double fat;

  @override
  Widget build(BuildContext context) {
    final total = protein * 4 + carbs * 4 + fat * 9;
    final protP = total > 0 ? (protein * 4 / total * 100).round() : 0;
    final carbP = total > 0 ? (carbs * 4 / total * 100).round() : 0;
    final fatP = total > 0 ? (fat * 9 / total * 100).round() : 0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Distribución',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.verticalSm,
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 8,
              child: Row(
                children: [
                  if (protP > 0)
                    Expanded(
                      flex: protP,
                      child: const ColoredBox(color: AppColors.error),
                    ),
                  if (carbP > 0)
                    Expanded(
                      flex: carbP,
                      child: const ColoredBox(color: AppColors.blue),
                    ),
                  if (fatP > 0)
                    Expanded(
                      flex: fatP,
                      child: const ColoredBox(color: AppColors.purple),
                    ),
                  if (total == 0)
                    const Expanded(child: ColoredBox(color: AppColors.surface)),
                ],
              ),
            ),
          ),
          AppSpacing.verticalSm,
          _LegendRow(
            label: 'Proteínas',
            percent: '$protP%',
            color: AppColors.error,
          ),
          const SizedBox(height: 4),
          _LegendRow(
            label: 'Carbohidratos',
            percent: '$carbP%',
            color: AppColors.blue,
          ),
          const SizedBox(height: 4),
          _LegendRow(
            label: 'Grasas',
            percent: '$fatP%',
            color: AppColors.purple,
          ),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.label,
    required this.percent,
    required this.color,
  });
  final String label;
  final String percent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ),
        Text(
          percent,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Nutrient Tabs
// ---------------------------------------------------------------------------

class _NutrientTabs extends StatelessWidget {
  const _NutrientTabs({required this.selected, required this.onChanged});
  final int selected;
  final ValueChanged<int> onChanged;

  static const _labels = ['Calorías', 'Proteínas', 'Carbs', 'Grasas'];
  static const _colors = [
    AppColors.orange,
    AppColors.error,
    AppColors.blue,
    AppColors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_labels.length, (i) {
          final isSelected = i == selected;
          final color = _colors[i];
          return Padding(
            padding: EdgeInsets.only(right: i < _labels.length - 1 ? 8 : 0),
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? color.withValues(alpha: 0.15)
                      : AppColors.card,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: isSelected
                        ? color.withValues(alpha: 0.5)
                        : AppColors.border,
                    width: isSelected ? 1.5 : 0.5,
                  ),
                ),
                child: Text(
                  _labels[i],
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isSelected ? color : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
