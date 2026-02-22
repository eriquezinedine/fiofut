part of 'serie_exercise_widget.dart';

class SireBody extends ConsumerWidget {
  const SireBody({
    super.key,
    this.repiteType = RepiteType.byKg,
    this.groupType = SerieGroupType.effective,
    this.isStarted = false,
    this.currentSerieId,
    this.onRegisterSerie,
  });

  final RepiteType repiteType;
  final SerieGroupType groupType;
  final bool isStarted;
  final String? currentSerieId;
  final VoidCallback? onRegisterSerie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(serieDetailProvider(groupType));
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
            repiteType: repiteType,
            serie: serie,
            groupType: groupType,
            isStarted: isStarted,
            currentSerieId: currentSerieId,
            lastCompletedId: lastCompletedId,
            onRegisterSerie: onRegisterSerie,
            canDelete: series.length > 1,
            onDelete: () => ref
                .read(serieDetailProvider(groupType).notifier)
                .removeSerie(serie.id),
          ),
      ],
    );
  }
}
