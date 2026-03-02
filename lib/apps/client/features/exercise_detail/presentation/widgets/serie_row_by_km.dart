part of 'serie_exercise_widget.dart';

class _SerieRowByKm extends ConsumerStatefulWidget {
  const _SerieRowByKm({
    required this.serie,
    required this.isActive,
    this.isStarted = false,
    this.isCurrent = false,
    this.isLastCompleted = false,
    this.onRegisterSerie,
  });

  final SerieSet serie;
  final bool isActive;
  final bool isStarted;
  final bool isCurrent;
  final bool isLastCompleted;
  final VoidCallback? onRegisterSerie;

  @override
  ConsumerState<_SerieRowByKm> createState() => _SerieRowByKmState();
}

class _SerieRowByKmState extends ConsumerState<_SerieRowByKm> {
  Color get _separatorColor {
    if (!widget.isStarted) {
      return widget.isActive ? AppColors.background : AppColors.white;
    }
    if (!widget.isActive) return AppColors.black;
    if (widget.isCurrent) return AppColors.background;
    return AppColors.white;
  }

  Future<void> _onNumberCellTap() async {
    if (!widget.isStarted) {
      final action = await SetTypeModal.show(context);
      if (action == null || !mounted) return;

      final notifier = ref.read(serieDetailProvider.notifier);
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
    final notifier = ref.read(serieDetailProvider.notifier);

    VoidCallback? numberCellTap;
    if (!widget.isStarted) {
      numberCellTap = _onNumberCellTap;
    } else if (widget.isCurrent) {
      numberCellTap = widget.onRegisterSerie;
    } else if (widget.isLastCompleted) {
      numberCellTap = () => notifier.toggleSerieCompleted(serie.id);
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20)
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
              child: Row(
                children: [
                  Expanded(
                    child: SerieTextField(
                      key: ValueKey('${serie.id}_mins'),
                      initialValue: serie.mins?.toString(),
                      hint: '00',
                      isActive: widget.isActive,
                      isStarted: widget.isStarted,
                      isCurrent: widget.isCurrent,
                      maxLength: 2,
                      onChanged: (v) {
                        final mins = int.tryParse(v);
                        if (mins != null) {
                          notifier.updateMins(serie.id, mins);
                        }
                      },
                    ),
                  ),
                  Text(
                    ':',
                    style: AppTextStyles.h3.copyWith(
                      color: _separatorColor,
                      fontSize: 20,
                      letterSpacing: -0.4,
                      height: 1.25,
                    ),
                  ),
                  Expanded(
                    child: SerieTextField(
                      key: ValueKey('${serie.id}_segs'),
                      initialValue: serie.segs?.toString(),
                      hint: '00',
                      isActive: widget.isActive,
                      isStarted: widget.isStarted,
                      isCurrent: widget.isCurrent,
                      maxLength: 2,
                      onChanged: (v) {
                        final segs = int.tryParse(v);
                        if (segs != null) {
                          notifier.updateSegs(serie.id, segs);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _CellContainer(
              isActive: widget.isActive,
              isStarted: widget.isStarted,
              isCurrent: widget.isCurrent,
              child: SerieTextField(
                key: ValueKey('${serie.id}_kg'),
                initialValue: serie.kg != null
                    ? (serie.kg == serie.kg!.roundToDouble()
                        ? serie.kg!.toInt().toString()
                        : serie.kg.toString())
                    : null,
                hint: '0',
                isActive: widget.isActive,
                isStarted: widget.isStarted,
                isCurrent: widget.isCurrent,
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
