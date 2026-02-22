import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

import 'repose_stat_card.dart';

class ReposeStatsSection extends StatelessWidget {
  const ReposeStatsSection({
    super.key,
    required this.averagePercent,
    required this.musclesRecovering,
    required this.mostWornMuscle,
  });

  final String averagePercent;
  final String musclesRecovering;
  final String mostWornMuscle;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
        ReposeStatCard(
          title: averagePercent,
          subtitle: 'Promedio',
        ),
        const SizedBox(height: AppSpacing.xs),
        ReposeStatCard(
          title: musclesRecovering,
          subtitle: 'En recuperación',
        ),
        const SizedBox(height: AppSpacing.xs),
        ReposeStatCard(
          title: mostWornMuscle,
          subtitle: 'Mas desgastado',
        ),
        SizedBox(height: 32)
        ],
      ),
    );
  }
}
