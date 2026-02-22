part of 'serie_exercise_widget.dart';

class _SerieRowByKm extends ConsumerWidget {
  const _SerieRowByKm({
    required this.serie,
    required this.isActive,
    required this.groupType,
    this.isStarted = false,
    this.isCurrent = false,
    this.isLastCompleted = false,
    this.onRegisterSerie,
  });

  final SerieSet serie;
  final bool isActive;
  final SerieGroupType groupType;
  final bool isStarted;
  final bool isCurrent;
  final bool isLastCompleted;
  final VoidCallback? onRegisterSerie;

  Color get _separatorColor {
    if (!isStarted) {
      return isActive ? AppColors.background : AppColors.white;
    }
    if (!isActive) return AppColors.black;
    if (isCurrent) return AppColors.background;
    return AppColors.white;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(serieDetailProvider(groupType).notifier);

    VoidCallback? numberCellTap;
    if (isCurrent) {
      numberCellTap = onRegisterSerie;
    } else if (isLastCompleted) {
      numberCellTap = () => notifier.toggleSerieCompleted(serie.id);
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
            onTap: numberCellTap,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _CellContainer(
              isActive: isActive,
              isStarted: isStarted,
              isCurrent: isCurrent,
              child: Row(
                children: [
                  Expanded(
                    child: SerieTextField(
                      key: ValueKey('${serie.id}_mins'),
                      initialValue: serie.mins?.toString(),
                      hint: '00',
                      isActive: isActive,
                      isStarted: isStarted,
                      isCurrent: isCurrent,
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
                      isActive: isActive,
                      isStarted: isStarted,
                      isCurrent: isCurrent,
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
              isActive: isActive,
              isStarted: isStarted,
              isCurrent: isCurrent,
              child: SerieTextField(
                key: ValueKey('${serie.id}_kg'),
                initialValue: serie.kg != null
                    ? (serie.kg == serie.kg!.roundToDouble()
                        ? serie.kg!.toInt().toString()
                        : serie.kg.toString())
                    : null,
                hint: '0',
                isActive: isActive,
                isStarted: isStarted,
                isCurrent: isCurrent,
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
