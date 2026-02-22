part of 'serie_exercise_widget.dart';

class _SerieNumberCell extends StatelessWidget {
  const _SerieNumberCell({
    required this.number,
    required this.isActive,
    this.isStarted = false,
    this.isCurrent = false,
    this.onTap,
  });

  final int number;
  final bool isActive;
  final bool isStarted;
  final bool isCurrent;
  final VoidCallback? onTap;

  bool get _isCompleted => !isActive;

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color textColor;

    if (!isStarted) {
      bg = isActive ? AppColors.white : AppColors.backgroundSecondary;
      textColor = isActive ? AppColors.background : AppColors.white;
    } else if (_isCompleted) {
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
        child: isStarted && _isCompleted
            ? Icon(LucideIcons.check, color: AppColors.black, size: 18)
            : Text(
                '$number',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.32,
                  height: 1.25,
                ),
              ),
      ),
    );
  }
}
