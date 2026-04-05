import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../domain/providers/exercise_stats_provider.dart';
import '../widgets/stats_chart_placeholder.dart';
import '../widgets/stats_summary_card.dart';
import '../widgets/stats_time_filter.dart';

class ExerciseStatsScreen extends ConsumerStatefulWidget {
  const ExerciseStatsScreen({
    required this.exerciseId,
    required this.exerciseName,
    super.key,
  });

  static const String path = '/exercise-stats/:id';
  static const String name = 'exercise-stats';

  final String exerciseId;
  final String exerciseName;

  @override
  ConsumerState<ExerciseStatsScreen> createState() =>
      _ExerciseStatsScreenState();
}

class _ExerciseStatsScreenState extends ConsumerState<ExerciseStatsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(exerciseStatsProvider.notifier)
          .load(widget.exerciseId, widget.exerciseName);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(exerciseStatsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: switch (state) {
          ExerciseStatsInitial() || ExerciseStatsLoading() => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ExerciseStatsError(message: final msg) => _ErrorView(
              message: msg,
              onRetry: () => ref
                  .read(exerciseStatsProvider.notifier)
                  .load(widget.exerciseId, widget.exerciseName),
            ),
          final ExerciseStatsLoaded loaded => _LoadedBody(state: loaded),
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Loaded body
// ---------------------------------------------------------------------------

class _LoadedBody extends ConsumerWidget {
  const _LoadedBody({required this.state});
  final ExerciseStatsLoaded state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // --- Header ---
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xs,
              AppSpacing.sm,
              AppSpacing.md,
              0,
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => GoRouter.of(context).pop(),
                  icon: const Icon(
                    LucideIcons.arrowLeft,
                    color: AppColors.textPrimary,
                  ),
                ),
                AppSpacing.horizontalXs,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.exerciseName,
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Estadisticas del ejercicio',
                        style: AppTextStyles.small.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              AppSpacing.verticalLg,

              // --- Summary cards ---
              Row(
                children: [
                  Expanded(
                    child: StatsSummaryCard(
                      icon: LucideIcons.dumbbell,
                      label: 'Peso maximo',
                      value: '${state.maxWeight.toStringAsFixed(1)} kg',
                      accentColor: AppColors.primary,
                    ),
                  ),
                  AppSpacing.horizontalSm,
                  Expanded(
                    child: StatsSummaryCard(
                      icon: LucideIcons.repeat,
                      label: 'Reps promedio',
                      value: state.avgReps.toStringAsFixed(1),
                      accentColor: AppColors.blue,
                    ),
                  ),
                  AppSpacing.horizontalSm,
                  Expanded(
                    child: StatsSummaryCard(
                      icon: LucideIcons.checkCircle,
                      label: 'Sets totales',
                      value: '${state.totalSets}',
                      accentColor: AppColors.purple,
                    ),
                  ),
                ],
              ),

              AppSpacing.verticalLg,

              // --- Time filter ---
              StatsTimeFilter(
                selectedIndex: state.selectedFilter,
                onChanged: (i) =>
                    ref.read(exerciseStatsProvider.notifier).setFilter(i),
              ),

              AppSpacing.verticalLg,

              // --- Weight chart ---
              StatsChartPlaceholder(
                title: 'Progresion de peso',
                points: state.weightHistory,
                lineColor: AppColors.primary,
                unit: ' kg',
              ),

              AppSpacing.verticalMd,

              // --- Reps chart ---
              StatsChartPlaceholder(
                title: 'Progresion de repeticiones',
                points: state.repsHistory,
                lineColor: AppColors.blue,
                unit: ' reps',
              ),

              AppSpacing.verticalXxl,
            ]),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Error
// ---------------------------------------------------------------------------

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
              style:
                  AppTextStyles.body.copyWith(color: AppColors.textSecondary),
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
