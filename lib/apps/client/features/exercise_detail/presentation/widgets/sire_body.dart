part of 'serie_exercise_widget.dart';

class SireBody extends ConsumerStatefulWidget {
  const SireBody({
    super.key,
    required this.scheduleId,
    this.repiteType = MetricType.strength,
    this.currentSerieId,
    this.onRegisterSerie,
    this.name,
    this.series = const [],
    this.muscleGroup,
    this.secondaryMuscles = const [],
  });

  final String scheduleId;
  final MetricType repiteType;
  final String? currentSerieId;
  final VoidCallback? onRegisterSerie;
  final String? name;
  final List<ExerciseSetData> series;
  final MuscleGroup? muscleGroup;
  final List<MuscleGroup> secondaryMuscles;

  @override
  ConsumerState<SireBody> createState() => _SireBodyState();
}

class _SireBodyState extends ConsumerState<SireBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(serieDetailProvider(widget.scheduleId).notifier).initFromSeries(
            scheduleId: widget.scheduleId,
            repiteType: widget.repiteType,
            series: widget.series,
            muscleGroup: widget.muscleGroup,
            secondaryMuscles: widget.secondaryMuscles,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(serieDetailProvider(widget.scheduleId));
    final isRetryOnly = widget.repiteType == MetricType.strength;
    final middleHeader = switch (widget.repiteType) {
      MetricType.strength => 'Repeticiones',
      MetricType.cardio => 'Mins : Segs',
      MetricType.reps => 'Repeticiones',
    };

    final series = switch (state) {
      SerieDetailLoaded(:final series) => series,
      _ => widget.series,
    };

    return Column(
      children: [
        _SerieHeaders(middleHeader: middleHeader, showKg: isRetryOnly),
        for (var i = 0; i < series.length; i++)
          ItemSerieWidget(
            scheduleId: widget.scheduleId,
            repiteType: widget.repiteType,
            serie: series[i],
            index: i,
            currentSerieId: widget.currentSerieId,
            onRegisterSerie: widget.onRegisterSerie,
            canDelete: series.length > 1,
            onDelete: () => ref
                .read(serieDetailProvider(widget.scheduleId).notifier)
                .removeSerie(series[i].id),
          ),
      ],
    );
  }
}
