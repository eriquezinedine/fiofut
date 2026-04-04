part of 'serie_exercise_widget.dart';

class _SerieRowByKm extends ConsumerWidget {
  const _SerieRowByKm({
    required this.scheduleId,
    required this.serie,
    required this.index,
    required this.isCompleted,
    this.isCurrent = false,
    this.onNumberCellTap,
    this.onCheckCellTap,
  });

  final String scheduleId;
  final ExerciseSetData serie;
  final int index;
  final bool isCompleted;
  final bool isCurrent;
  final VoidCallback? onNumberCellTap;
  final VoidCallback? onCheckCellTap;

  String _formatKm(double? km) {
    if (km == null) return '0';
    return km == km.roundToDouble() ? km.toInt().toString() : km.toString();
  }

  Future<void> _openModal(BuildContext context, WidgetRef ref) async {
    final result = await EditSerieValueModal.show(
      context,
      metricType: MetricType.cardio,
      exerciseName: scheduleId,
      serieLabel: '${serie.setNumber}',
      initialMinutes: serie.minutes,
      initialSeconds: serie.seconds,
      initialDistance: serie.weight,
    );
    if (result == null) return;
    ref.read(serieDetailProvider(scheduleId).notifier).updateSerieValues(serie.id, result);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = SerieCellStyle.resolve(
      isCompleted: isCompleted,
      isCurrent: isCurrent,
    );

    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Row(
        children: [
          _SerieNumberCell(
            index: index,
            isCompleted: isCompleted,
            isCurrent: isCurrent,
            setType: serie.setType,
            onTap: onNumberCellTap,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () => _openModal(context, ref),
              child: _CellContainer(
                isCompleted: isCompleted,
                isCurrent: isCurrent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      (serie.minutes ?? 0).toString().padLeft(2, '0'),
                      style: style.valueTextStyle,
                    ),
                    Text(':', style: style.valueTextStyle),
                    Text(
                      (serie.seconds ?? 0).toString().padLeft(2, '0'),
                      style: style.valueTextStyle,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () => _openModal(context, ref),
              child: _CellContainer(
                isCompleted: isCompleted,
                isCurrent: isCurrent,
                child: Text(
                  _formatKm(serie.weight),
                  textAlign: TextAlign.center,
                  style: style.valueTextStyle,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _SerieCheckCell(
            isCompleted: isCompleted,
            isCurrent: isCurrent,
            onTap: onCheckCellTap,
          ),
        ],
      ),
    );
  }
}
