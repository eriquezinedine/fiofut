import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_stats/presentation/screens/exercise_stats_screen.dart';
import 'package:fio_fut/apps/client/features/exercise_stats/presentation/widgets/stats_chart_placeholder.dart';
import 'package:fio_fut/apps/client/features/exercise_stats/presentation/widgets/stats_metric_toggle.dart';
import 'package:fio_fut/apps/client/features/progress/domain/providers/progress_provider.dart';
import 'package:fio_fut/apps/client/features/progress/presentation/widgets/selecter_date_custom.dart';
import 'package:fio_fut/core/widgets/modal/exercise_picker_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ProgressExerciseTab extends ConsumerStatefulWidget {
  const ProgressExerciseTab({super.key});

  @override
  ConsumerState<ProgressExerciseTab> createState() =>
      _ProgressExerciseTabState();
}

class _ProgressExerciseTabState extends ConsumerState<ProgressExerciseTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(progressProvider.notifier).load();
    });
  }

  Future<void> _openExercisePicker() async {
    final exercise = await ExercisePickerModal.show(
      context,
      buttonText: 'Ver estadísticas',
    );
    if (exercise == null || !mounted) return;
    context.pushNamed(
      ExerciseStatsScreen.name,
      pathParameters: {'id': exercise.id},
      extra: exercise.title,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final state = ref.watch(progressProvider);

    return switch (state) {
      ProgressInitial() || ProgressLoading() => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      ProgressError(message: final msg) => Center(
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
              onPressed: () => ref.read(progressProvider.notifier).load(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.black,
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
      final ProgressLoaded loaded => _buildLoaded(loaded),
    };
  }

  Widget _buildLoaded(ProgressLoaded loaded) {
    final notifier = ref.read(progressProvider.notifier);
    final filteredData = notifier.filteredData(loaded);
    final totals = notifier.filteredTotals(loaded);

    final isWeight = loaded.selectedMetric == 0;
    final chartTitle = isWeight ? 'Volumen de peso' : 'Distancia recorrida';
    final chartColor = isWeight ? AppColors.primary : AppColors.blue;
    final chartUnit = isWeight ? ' kg' : ' km';

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      children: [
        // Date selector
        SelecterDateCustom(
          onDateRangeChanged: (range) {
            notifier.setDateRange(range.start, range.end);
          },
        ),
        // Summary cards
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                icon: LucideIcons.dumbbell,
                label: 'Peso levantado',
                value: '${_fmt(totals.totalWeight)} kg',
                color: AppColors.primary,
              ),
            ),
            AppSpacing.horizontalSm,
            Expanded(
              child: _SummaryCard(
                icon: LucideIcons.mapPin,
                label: 'Distancia total',
                value: '${_fmt(totals.totalDistance)} km',
                color: AppColors.blue,
              ),
            ),
          ],
        ),
        AppSpacing.verticalLg,

        // Metric toggle
        StatsMetricToggle(
          selectedMetric: loaded.selectedMetric,
          onChanged: (i) => notifier.setMetric(i),
        ),
        AppSpacing.verticalMd,

        AppSpacing.verticalMd,

        // Chart
        StatsChartPlaceholder(
          title: chartTitle,
          points: filteredData,
          lineColor: chartColor,
          unit: chartUnit,
        ),

        AppSpacing.verticalLg,

        // Button: ver por ejercicio
        GestureDetector(
          onTap: _openExercisePicker,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: AppSpacing.borderRadiusMd,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: AppSpacing.borderRadiusSm,
                  ),
                  child: const Icon(
                    LucideIcons.barChart3,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ver por ejercicio',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Estadísticas detalladas por ejercicio',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  LucideIcons.chevronRight,
                  color: AppColors.primary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),

        AppSpacing.verticalXxl,
      ],
    );
  }

  String _fmt(double v) =>
      v >= 1000 ? '${(v / 1000).toStringAsFixed(1)}k' : v.toStringAsFixed(1);
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

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
              color: color.withValues(alpha: 0.15),
              borderRadius: AppSpacing.borderRadiusSm,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          AppSpacing.verticalSm,
          Text(
            value,
            style: AppTextStyles.h3.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.small.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
