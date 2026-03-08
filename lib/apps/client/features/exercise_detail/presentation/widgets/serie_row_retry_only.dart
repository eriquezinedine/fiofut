part of 'serie_exercise_widget.dart';

class _SerieRowRetryOnly extends ConsumerStatefulWidget {
  const _SerieRowRetryOnly({
    required this.scheduleId,
    required this.serie,
    required this.isCompleted,
    this.isStarted = false,
    this.isCurrent = false,
    this.onNumberCellTap,
    this.onCheckCellTap,
  });

  final String scheduleId;
  final SerieSet serie;
  final bool isCompleted;
  final bool isStarted;
  final bool isCurrent;
  final VoidCallback? onNumberCellTap;
  final VoidCallback? onCheckCellTap;

  @override
  ConsumerState<_SerieRowRetryOnly> createState() =>
      _SerieRowRetryOnlyState();
}

class _SerieRowRetryOnlyState extends ConsumerState<_SerieRowRetryOnly> {
  @override
  Widget build(BuildContext context) {
    final serie = widget.serie;
    final isCompleted = widget.isCompleted;
    final notifier = ref.read(serieDetailProvider(widget.scheduleId).notifier);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0)
          .add(EdgeInsets.only(top: !isCompleted ? 12 : 4, bottom: 8)),
      child: Row(
        children: [
          _SerieNumberCell(
            number: serie.number,
            isCompleted: isCompleted,
            isStarted: widget.isStarted,
            isCurrent: widget.isCurrent,
            setType: serie.setType,
            onTap: widget.onNumberCellTap,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _CellContainer(
              isCompleted: isCompleted,
              isStarted: widget.isStarted,
              isCurrent: widget.isCurrent,
              child: SerieTextField(
                key: ValueKey('${serie.id}_reps'),
                initialValue: serie.reps?.toString(),
                hint: '0',
                isCompleted: isCompleted,
                isStarted: widget.isStarted,
                isCurrent: widget.isCurrent,
                onChanged: (v) {
                  final reps = int.tryParse(v);
                  if (reps != null) notifier.updateReps(serie.id, reps);
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          _SerieCheckCell(
            isCompleted: isCompleted,
            isStarted: widget.isStarted,
            isCurrent: widget.isCurrent,
            onTap: widget.onCheckCellTap,
          ),
        ],
      ),
    );
  }
}
