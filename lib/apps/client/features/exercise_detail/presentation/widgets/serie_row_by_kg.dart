part of 'serie_exercise_widget.dart';

class _SerieRowByKg extends ConsumerStatefulWidget {
  const _SerieRowByKg({
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
    final isActive = widget.isActive;
    final isStarted = widget.isStarted;
    final isCurrent = widget.isCurrent;
    final notifier = ref.read(serieDetailProvider(widget.scheduleId).notifier);

    VoidCallback? numberCellTap;
    if (!isStarted) {
      numberCellTap = _onNumberCellTap;
    } else if (widget.isCurrent) {
      numberCellTap = widget.onRegisterSerie;
    } else if (widget.isLastCompleted) {
      numberCellTap = () {
        final ok = notifier.toggleSerieCompleted(serie.id);
        if (!ok) AppToast.error(context, 'Completa las repeticiones y peso');
      };
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20)
          .add(EdgeInsets.only(top: isActive ? 12 : 4, bottom: 8)),
      child: Row(
        children: [
          _SerieNumberCell(
            number: serie.number,
            isActive: isActive,
            isStarted: isStarted,
            isCurrent: isCurrent,
            setType: serie.setType,
            onTap: numberCellTap,
          ),
            const SizedBox(width: 16),
            Expanded(
              child: _CellContainer(
                isActive: isActive,
                isStarted: isStarted,
                isCurrent: isCurrent,
                child: SerieTextField(
                  key: ValueKey('${serie.id}_reps'),
                  initialValue: serie.reps?.toString(),
                  hint: '0',
                  isActive: isActive,
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
                isActive: isActive,
                isStarted: isStarted,
                isCurrent: isCurrent,
                child: SerieTextField(
                  key: ValueKey('${serie.id}_kg'),
                  initialValue: _formatKg(serie.kg),
                  hint: '0',
                  isActive: isActive,
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
          ],
        ),
    );
  }
}
