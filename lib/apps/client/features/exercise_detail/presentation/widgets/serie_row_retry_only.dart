part of 'serie_exercise_widget.dart';

class _SerieRowRetryOnly extends ConsumerStatefulWidget {
  const _SerieRowRetryOnly({
    required this.scheduleId,
    required this.serie,
    required this.isActive,
    this.isStarted = false,
    this.isCurrent = false,
    this.isLastCompleted = false,
    this.onRegisterSerie,
  });

  final String scheduleId;
  final SerieSet serie;
  final bool isActive;
  final bool isStarted;
  final bool isCurrent;
  final bool isLastCompleted;
  final VoidCallback? onRegisterSerie;

  @override
  ConsumerState<_SerieRowRetryOnly> createState() =>
      _SerieRowRetryOnlyState();
}

class _SerieRowRetryOnlyState extends ConsumerState<_SerieRowRetryOnly> {
  Future<void> _onNumberCellTap() async {
    if (!widget.isStarted) {
      final action = await SetTypeModal.show(context);
      if (action == null || !mounted) return;

      final notifier = ref.read(serieDetailProvider(widget.scheduleId).notifier);
      if (action == SetTypeAction.delete) {
        notifier.removeSerie(widget.serie.id);
      } else {
        final type = SetTypeModal.toSetType(action);
        if (type != null) notifier.updateSetType(widget.serie.id, type);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final serie = widget.serie;
    final notifier = ref.read(serieDetailProvider(widget.scheduleId).notifier);

    VoidCallback? numberCellTap;
    if (!widget.isStarted) {
      numberCellTap = _onNumberCellTap;
    } else if (widget.isCurrent) {
      numberCellTap = widget.onRegisterSerie;
    } else if (widget.isLastCompleted) {
      numberCellTap = () {
        final ok = notifier.toggleSerieCompleted(serie.id);
        if (!ok) AppToast.error(context, 'Completa las repeticiones');
      };
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0)
          .add(EdgeInsets.only(top: widget.isActive ? 12 : 4, bottom: 8)),
      child: Row(
        children: [
          _SerieNumberCell(
            number: serie.number,
            isActive: widget.isActive,
            isStarted: widget.isStarted,
            isCurrent: widget.isCurrent,
            setType: serie.setType,
            onTap: numberCellTap,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _CellContainer(
              isActive: widget.isActive,
              isStarted: widget.isStarted,
              isCurrent: widget.isCurrent,
              child: SerieTextField(
                key: ValueKey('${serie.id}_reps'),
                initialValue: serie.reps?.toString(),
                hint: '0',
                isActive: widget.isActive,
                isStarted: widget.isStarted,
                isCurrent: widget.isCurrent,
                onChanged: (v) {
                  final reps = int.tryParse(v);
                  if (reps != null) notifier.updateReps(serie.id, reps);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
