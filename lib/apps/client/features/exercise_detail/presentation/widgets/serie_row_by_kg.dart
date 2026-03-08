part of 'serie_exercise_widget.dart';

class _SerieRowByKg extends ConsumerStatefulWidget {
  const _SerieRowByKg({
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
  ConsumerState<_SerieRowByKg> createState() => _SerieRowByKgState();
}

class _SerieRowByKgState extends ConsumerState<_SerieRowByKg> {
  final _kgFocusNode = FocusNode();

  @override
  void dispose() {
    _kgFocusNode.dispose();
    super.dispose();
  }

  String? _formatKg(double? kg) {
    if (kg == null) return null;
    return kg == kg.roundToDouble() ? kg.toInt().toString() : kg.toString();
  }

  @override
  Widget build(BuildContext context) {
    final serie = widget.serie;
    final isCompleted = widget.isCompleted;
    final isStarted = widget.isStarted;
    final isCurrent = widget.isCurrent;
    final notifier = ref.read(serieDetailProvider(widget.scheduleId).notifier);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0)
          .add(EdgeInsets.only(top: !isCompleted ? 12 : 4, bottom: 8)),
      child: Row(
        children: [
          _SerieNumberCell(
            number: serie.number,
            isCompleted: isCompleted,
            isStarted: isStarted,
            isCurrent: isCurrent,
            setType: serie.setType,
            onTap: widget.onNumberCellTap,
          ),
            const SizedBox(width: 16),
            Expanded(
              child: _CellContainer(
                isCompleted: isCompleted,
                isStarted: isStarted,
                isCurrent: isCurrent,
                child: SerieTextField(
                  key: ValueKey('${serie.id}_reps'),
                  initialValue: serie.reps?.toString(),
                  hint: '0',
                  isCompleted: isCompleted,
                  isStarted: isStarted,
                  isCurrent: isCurrent,
                  nextFocusNode: _kgFocusNode,
                  autoAdvanceMs: 300,
                  onChanged: (v) {
                    final reps = int.tryParse(v);
                    if (reps != null) notifier.updateReps(serie.id, reps);
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _CellContainer(
                isCompleted: isCompleted,
                isStarted: isStarted,
                isCurrent: isCurrent,
                child: SerieTextField(
                  key: ValueKey('${serie.id}_kg'),
                  initialValue: _formatKg(serie.kg),
                  hint: '0',
                  isCompleted: isCompleted,
                  isStarted: isStarted,
                  isCurrent: isCurrent,
                  focusNode: _kgFocusNode,
                  onChanged: (v) {
                    final kg = double.tryParse(v);
                    if (kg != null) notifier.updateKg(serie.id, kg);
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            _SerieCheckCell(
              isCompleted: isCompleted,
              isStarted: isStarted,
              isCurrent: isCurrent,
              onTap: widget.onCheckCellTap,
            ),
          ],
        ),
    );
  }
}
