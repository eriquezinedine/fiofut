import 'package:fio_fut/apps/client/features/repose/domain/providers/all_muscles_repose_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Stats calculados desde el estado global de reposo.
final reposeStatsProvider = Provider<ReposeStats>((ref) {
  final muscles = ref.watch(allMusclesReposeProvider).asList;
  if (muscles.isEmpty) return const ReposeStats.empty();

  final total = muscles.fold<int>(0, (sum, m) => sum + m.percentage);
  final average = total ~/ muscles.length;

  final recovering = muscles.where((m) => m.percentage < 100).length;

  final mostWorn = muscles.reduce(
    (a, b) => a.percentage <= b.percentage ? a : b,
  );

  return ReposeStats(
    averagePercent: average,
    musclesRecovering: recovering,
    mostWornName: mostWorn.muscle.name,
    mostWornPercent: mostWorn.percentage,
  );
});

class ReposeStats {
  const ReposeStats({
    required this.averagePercent,
    required this.musclesRecovering,
    required this.mostWornName,
    required this.mostWornPercent,
  });

  const ReposeStats.empty()
      : averagePercent = 100,
        musclesRecovering = 0,
        mostWornName = '-',
        mostWornPercent = 100;

  final int averagePercent;
  final int musclesRecovering;
  final String mostWornName;
  final int mostWornPercent;
}
