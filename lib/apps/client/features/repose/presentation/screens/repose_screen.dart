import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/repose/domain/providers/all_muscles_repose_provider.dart';
import 'package:fio_fut/apps/client/features/repose/domain/providers/repose_stats_provider.dart';
import 'package:fio_fut/apps/client/features/repose/presentation/screens/repose_slider_screen.dart';
import 'package:fio_fut/apps/client/features/repose/presentation/widgets/muscle_back_front_view.dart';
import 'package:fio_fut/apps/client/features/repose/presentation/widgets/repose_screen_widgets/most_used_muscles_section.dart';
import 'package:fio_fut/apps/client/features/repose/presentation/widgets/repose_screen_widgets/repose_stats_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ReposeScreen extends ConsumerWidget {
  static const String name = 'repose';
  static const String path = '/repose';

  const ReposeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(reposeStatsProvider);
    final allMuscles = ref.watch(allMusclesReposeProvider).asList;

    // Top 5 musculos mas desgastados
    final sortedMuscles = [...allMuscles]
      ..sort((a, b) => a.percentage.compareTo(b.percentage));
    final top5 = sortedMuscles.take(5).toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recuperación Muscular', style: AppTextStyles.h3),
              GestureDetector(
                onTap: () => context.pushNamed(ReposeSliderScreen.name),
                child: Text(
                  'Editar',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20).copyWith(top: 0),
        children: [
          const SizedBox(height: 16),
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final bodyWidth = ((constraints.maxWidth - 8) / 2) - 24;
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: MuscleBackFrontView(bodyWidth: bodyWidth),
                    );
                  },
                ),
              ),
              ReposeStatsSection(
                averagePercent: '${stats.averagePercent}%',
                musclesRecovering: '${stats.musclesRecovering}',
                mostWornMuscle: '${stats.mostWornName} ${stats.mostWornPercent}%',
              ),
            ],
          ),
          MostUsedMusclesSection(muscles: top5),
        ],
      ),
    );
  }
}
