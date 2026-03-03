part of 'serie_exercise_widget.dart';

class SireBody extends ConsumerWidget {
  const SireBody({
    super.key,
    required this.scheduleId,
    this.repiteType = RepiteType.byKg,
    this.isStarted = false,
    this.currentSerieId,
    this.onRegisterSerie,
  });

  final String scheduleId;
  final RepiteType repiteType;
  final bool isStarted;
  final String? currentSerieId;
  final VoidCallback? onRegisterSerie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(serieDetailProvider(scheduleId));
    final isRetryOnly = repiteType == RepiteType.retryOnly;
    final middleHeader = switch (repiteType) {
      RepiteType.byKg => 'Repeticiones',
      RepiteType.byKm => 'Mins : Segs',
      RepiteType.retryOnly => 'Repeticiones',
    };

    final series = switch (state) {
      SerieDetailLoaded(:final workout) => workout.series,
      _ => <SerieSet>[],
    };

    // Find the last completed serie id (only that one can be untoggled)
    String? lastCompletedId;
    if (isStarted) {
      for (var i = series.length - 1; i >= 0; i--) {
        if (series[i].isCompleted) {
          lastCompletedId = series[i].id;
          break;
        }
      }
    }

    return Column(
      children: [
        _SerieHeaders(middleHeader: middleHeader, showKg: !isRetryOnly),
        for (final serie in series)
          ItemSerieWidget(
            scheduleId: scheduleId,
            repiteType: repiteType,
            serie: serie,
            isStarted: isStarted,
            currentSerieId: currentSerieId,
            lastCompletedId: lastCompletedId,
            onRegisterSerie: onRegisterSerie,
            canDelete: series.length > 1,
            onDelete: () => ref
                .read(serieDetailProvider(scheduleId).notifier)
                .removeSerie(serie.id),
          ),
      ],
    );
  }
}
