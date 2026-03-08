part of 'serie_exercise_widget.dart';

class _SerieRowByKm extends ConsumerStatefulWidget {
  const _SerieRowByKm({
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
  ConsumerState<_SerieRowByKm> createState() => _SerieRowByKmState();
}

class _SerieRowByKmState extends ConsumerState<_SerieRowByKm> {
  Color get _separatorColor {
    if (!widget.isStarted) {
      return !widget.isCompleted ? AppColors.background : AppColors.white;
    }
    if (widget.isCompleted) return AppColors.black;
    if (widget.isCurrent) return AppColors.background;
    return AppColors.white;
  }

  @override
  Widget build(BuildContext context) {
    final serie = widget.serie;
    final isCompleted = widget.isCompleted;
    final notifier = ref.read(serieDetailProvider(widget.scheduleId).notifier);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20)
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
              child: Row(
                children: [
                  Expanded(
                    child: SerieTextField(
                      key: ValueKey('${serie.id}_mins'),
                      initialValue: serie.mins?.toString().padLeft(2, '0'),
                      hint: '00',
                      isCompleted: isCompleted,
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
                      initialValue: serie.segs?.toString().padLeft(2, '0'),
                      hint: '00',
                      isCompleted: isCompleted,
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
              isCompleted: isCompleted,
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
                isCompleted: isCompleted,
                isStarted: widget.isStarted,
                isCurrent: widget.isCurrent,
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
            isStarted: widget.isStarted,
            isCurrent: widget.isCurrent,
            onTap: widget.onCheckCellTap,
          ),
        ],
      ),
    );
  }
}
