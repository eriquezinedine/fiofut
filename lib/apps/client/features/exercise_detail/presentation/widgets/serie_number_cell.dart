part of 'serie_exercise_widget.dart';

class _SerieNumberCell extends StatelessWidget {
  const _SerieNumberCell({
    required this.index,
    required this.isCompleted,
    this.isCurrent = false,
    this.setType = SetType.normal,
    this.onTap,
  });

  final int index;
  final bool isCompleted;
  final bool isCurrent;
  final SetType setType;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final style = SerieCellStyle.resolve(
      isCompleted: isCompleted,
      isCurrent: isCurrent,
    );

    final label = switch (setType) {
      SetType.normal => '${index + 1}',
      SetType.warmup => 'C',
      SetType.dropset => 'D',
    };

    // Cuando está completado y no es normal, el texto es negro sobre color del tipo
    final textStyle = isCompleted && setType != SetType.normal
        ? AppTextStyles.caption.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.32,
            height: 1.25,
          )
        : style.numberTextStyle(setType);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 35,
        height: 35,
        decoration: isCompleted
            ? style.numberDecoration(setType)
            : style.decoration,
        alignment: Alignment.center,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: textStyle,
        ),
      ),
    );
  }
}
