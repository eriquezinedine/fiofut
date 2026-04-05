import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise.dart';
import 'package:fio_fut/apps/client/features/progress/presentation/widgets/selecter_date_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../domain/providers/exercise_stats_provider.dart';
import '../widgets/stats_chart_placeholder.dart';
import '../widgets/stats_summary_card.dart';

class ExerciseStatsScreen extends ConsumerStatefulWidget {
  const ExerciseStatsScreen({
    required this.exerciseId,
    required this.exerciseName,
    this.selectedDate,
    this.metricType = MetricType.strength,
    super.key,
  });

  static const String path = '/exercise-stats/:id';
  static const String name = 'exercise-stats';

  final String exerciseId;
  final String exerciseName;
  final DateTime? selectedDate;
  final MetricType metricType;

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
          final ExerciseStatsLoaded loaded => _LoadedBody(
              state: loaded,
              selectedDate: widget.selectedDate,
              metricType: widget.metricType,
            ),
        },
      ),
    );
  }
}

class _LoadedBody extends ConsumerWidget {
  const _LoadedBody({
    required this.state,
    this.selectedDate,
    this.metricType = MetricType.strength,
  });
  final ExerciseStatsLoaded state;
  final DateTime? selectedDate;
  final MetricType metricType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(exerciseStatsProvider.notifier);
    final globalSummary = notifier.globalSummary();

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Header
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
                  child: Text(
                    state.exerciseName,
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
              AppSpacing.verticalMd,

              // ── Sección: Promedio ──
              Text(
                'Promedio general',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
              AppSpacing.verticalSm,

              IntrinsicHeight(
                child: Row(
                  children: [
                    // strength: peso máximo | reps: - | cardio: distancia
                    if (metricType == MetricType.strength)
                      Expanded(
                        child: StatsSummaryCard(
                          icon: LucideIcons.dumbbell,
                          label: 'Peso máximo',
                          value:
                              '${globalSummary.maxWeight.toStringAsFixed(1)} kg',
                          accentColor: AppColors.primary,
                        ),
                      ),
                    if (metricType == MetricType.cardio)
                      Expanded(
                        child: StatsSummaryCard(
                          icon: LucideIcons.mapPin,
                          label: 'Distancia máx',
                          value:
                              '${globalSummary.maxWeight.toStringAsFixed(1)} km',
                          accentColor: AppColors.primary,
                        ),
                      ),
                    if (metricType != MetricType.cardio) ...[
                      if (metricType == MetricType.strength)
                        AppSpacing.horizontalSm,
                      Expanded(
                        child: StatsSummaryCard(
                          icon: LucideIcons.repeat,
                          label: 'Reps promedio',
                          value: globalSummary.avgReps.toStringAsFixed(1),
                          accentColor: AppColors.blue,
                        ),
                      ),
                    ],
                    AppSpacing.horizontalSm,
                    Expanded(
                      child: StatsSummaryCard(
                        icon: LucideIcons.checkCircle,
                        label: 'Sets totales',
                        value: '${globalSummary.totalSets}',
                        accentColor: AppColors.purple,
                      ),
                    ),
                  ],
                ),
              ),

              AppSpacing.verticalLg,

              // ── Sección: Estadísticas ──
              Text(
                'Estadísticas',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
              AppSpacing.verticalSm,

              SelecterDateCustom(
                initialDate: selectedDate,
                onDateRangeChanged: (range) {
                  notifier.setDateRange(range.start, range.end);
                },
              ),

              AppSpacing.verticalLg,

              // Charts según MetricType
              // strength: peso + reps
              // reps: solo reps
              // cardio: solo distancia
              if (metricType == MetricType.strength ||
                  metricType == MetricType.cardio) ...[
                StatsChartPlaceholder(
                  title: metricType == MetricType.cardio
                      ? 'Progresión de distancia'
                      : 'Progresión de peso',
                  points: state.weightHistory,
                  lineColor: AppColors.primary,
                  unit: metricType == MetricType.cardio ? ' km' : ' kg',
                ),
                AppSpacing.verticalMd,
              ],

              if (metricType == MetricType.strength ||
                  metricType == MetricType.reps)
                StatsChartPlaceholder(
                  title: 'Progresión de repeticiones',
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
            const Icon(
              LucideIcons.alertTriangle,
              color: AppColors.error,
              size: 48,
            ),
            AppSpacing.verticalMd,
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
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
