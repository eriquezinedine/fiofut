part of 'serie_exercise_widget.dart';

class _SerieNumberCell extends StatelessWidget {
  const _SerieNumberCell({
    required this.number,
    required this.isCompleted,
    this.isStarted = false,
    this.isCurrent = false,
    this.setType = SetType.normal,
    this.onTap,
  });

  final int number;
  final bool isCompleted;
  final bool isStarted;
  final bool isCurrent;
  final SetType setType;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color textColor;

    if (!isStarted) {
      bg = !isCompleted ? AppColors.white : AppColors.backgroundSecondary;
      textColor = !isCompleted ? AppColors.background : AppColors.white;
    } else if (isCompleted) {
      bg = AppColors.primary;
      textColor = AppColors.black;
    } else if (isCurrent) {
      bg = AppColors.white;
      textColor = AppColors.background;
    } else {
      bg = AppColors.card;
      textColor = AppColors.white;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: _buildTypeContent(textColor),
      ),
    );
  }

  Widget _buildTypeContent(Color defaultTextColor) {
    return switch (setType) {
      SetType.normal => Text(
          '$number',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium.copyWith(
            color: defaultTextColor,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.32,
            height: 1.25,
          ),
        ),
      SetType.warmup => Text(
          'C',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.orange,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.32,
            height: 1.25,
          ),
        ),
      SetType.dropset => Text(
          'D',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.error,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.32,
            height: 1.25,
          ),
        ),
    };
  }
}
