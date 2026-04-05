import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_stats/presentation/screens/exercise_stats_screen.dart';
import 'package:fio_fut/apps/client/features/exercise_stats/presentation/widgets/month_range_selector.dart';
import 'package:fio_fut/apps/client/features/exercise_stats/presentation/widgets/stats_chart_placeholder.dart';
import 'package:fio_fut/apps/client/features/exercise_stats/presentation/widgets/stats_metric_toggle.dart';
import 'package:fio_fut/apps/client/features/exercise_stats/presentation/widgets/stats_time_filter.dart';
import 'package:fio_fut/apps/client/features/exercise_stats/presentation/widgets/week_selector.dart';
import 'package:fio_fut/core/widgets/modal/exercise_picker_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../domain/providers/progress_provider.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  DateTime _monthStart = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _monthEnd = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(progressProvider.notifier).load();
    });
  }

  Future<void> _pickMonthRange() async {
    final start = await showDatePicker(
      context: context,
      initialDate: _monthStart,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary,
            surface: AppColors.background,
          ),
        ),
        child: child!,
      ),
    );
    if (start == null || !mounted) return;

    final end = await showDatePicker(
      context: context,
      initialDate: _monthEnd.isBefore(start) ? start : _monthEnd,
      firstDate: start,
      lastDate: DateTime.now().add(const Duration(days: 1)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary,
            surface: AppColors.background,
          ),
        ),
        child: child!,
      ),
    );
    if (end == null || !mounted) return;

    setState(() {
      _monthStart = start;
      _monthEnd = end;
    });
    ref.read(progressProvider.notifier).setDateRange(start, end);
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
    final state = ref.watch(progressProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: switch (state) {
          ProgressInitial() || ProgressLoading() => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ProgressError(message: final msg) => _ErrorView(
              message: msg,
              onRetry: () => ref.read(progressProvider.notifier).load(),
            ),
          final ProgressLoaded loaded => _buildLoaded(loaded),
        },
      ),
    );
  }

  Widget _buildLoaded(ProgressLoaded loaded) {
    final notifier = ref.read(progressProvider.notifier);
    final filteredData = notifier.filteredData(loaded);

    final isWeight = loaded.selectedMetric == 0;
    final chartTitle = isWeight ? 'Volumen de peso' : 'Distancia recorrida';
    final chartColor = isWeight ? AppColors.primary : AppColors.blue;
    final chartUnit = isWeight ? ' kg' : ' km';
    final isWeek = loaded.selectedFilter == 0;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md, AppSpacing.lg, AppSpacing.md, 0,
            ),
            child: Text('Progreso', style: AppTextStyles.h2),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              AppSpacing.verticalLg,

              // Summary cards
              Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      icon: LucideIcons.dumbbell,
                      label: 'Peso levantado',
                      value: '${_formatNumber(loaded.totalWeight)} kg',
                      accentColor: AppColors.primary,
                    ),
                  ),
                  AppSpacing.horizontalSm,
                  Expanded(
                    child: _SummaryCard(
                      icon: LucideIcons.mapPin,
                      label: 'Distancia total',
                      value: '${_formatNumber(loaded.totalDistance)} km',
                      accentColor: AppColors.blue,
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

              // Time filter
              StatsTimeFilter(
                selectedIndex: loaded.selectedFilter,
                onChanged: (i) {
                  notifier.setFilter(i);
                  // Reset range al cambiar filtro
                  if (i == 0) {
                    final now = DateTime.now();
                    final monday = now.subtract(Duration(days: now.weekday - 1));
                    final start = DateTime(monday.year, monday.month, monday.day);
                    notifier.setDateRange(start, start.add(const Duration(days: 6)));
                  } else {
                    setState(() {
                      _monthStart = DateTime(DateTime.now().year, DateTime.now().month, 1);
                      _monthEnd = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
                    });
                    notifier.setDateRange(_monthStart, _monthEnd);
                  }
                },
              ),

              AppSpacing.verticalSm,

              // Week selector o Month range
              if (isWeek)
                WeekSelector(
                  onWeekChanged: (week) {
                    notifier.setDateRange(week.start, week.end);
                  },
                )
              else
                Center(
                  child: MonthRangeSelector(
                    startDate: _monthStart,
                    endDate: _monthEnd,
                    onTap: _pickMonthRange,
                  ),
                ),

              AppSpacing.verticalMd,

              // Chart
              StatsChartPlaceholder(
                title: chartTitle,
                points: filteredData,
                lineColor: chartColor,
                unit: chartUnit,
                useWeekdayLabels: isWeek,
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
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
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
                        child: const Icon(LucideIcons.barChart3,
                            color: AppColors.primary, size: 20),
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
                      const Icon(LucideIcons.chevronRight,
                          color: AppColors.primary, size: 20),
                    ],
                  ),
                ),
              ),

              AppSpacing.verticalXxl,
            ]),
          ),
        ),
      ],
    );
  }

  String _formatNumber(double value) {
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}k';
    return value.toStringAsFixed(1);
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.accentColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color accentColor;

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
              color: accentColor.withValues(alpha: 0.15),
              borderRadius: AppSpacing.borderRadiusSm,
            ),
            child: Icon(icon, color: accentColor, size: 20),
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

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingAllLg,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.alertTriangle,
                color: AppColors.error, size: 48),
            AppSpacing.verticalMd,
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            ),
            AppSpacing.verticalLg,
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: AppSpacing.borderRadiusFull,
                ),
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
