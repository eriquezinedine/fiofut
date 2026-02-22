part of 'serie_exercise_widget.dart';

class _SerieRowRetryOnly extends ConsumerWidget {
  const _SerieRowRetryOnly({
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
              child: SerieTextField(
                key: ValueKey('${serie.id}_reps'),
                initialValue: serie.reps?.toString(),
                hint: '0',
                isActive: isActive,
                isStarted: isStarted,
                isCurrent: isCurrent,
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
