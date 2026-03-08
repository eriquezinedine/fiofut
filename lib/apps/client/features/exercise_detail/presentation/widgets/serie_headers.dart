part of 'serie_exercise_widget.dart';

class _SerieHeaders extends StatelessWidget {
  const _SerieHeaders({
    required this.middleHeader,
    this.showKg = true,
  });

  final String middleHeader;
  final bool showKg;

  @override
  Widget build(BuildContext context) {
    final headerStyle = AppTextStyles.caption.copyWith(
      fontWeight: FontWeight.w500,
      color: AppColors.textDescription,
      letterSpacing: -0.28,
      height: 1.25,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0)
          .add(const EdgeInsets.only(top: 8, bottom: 4)),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            child: Text(
              'Serie',
              textAlign: TextAlign.center,
              style: headerStyle,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              middleHeader,
              textAlign: TextAlign.center,
              style: headerStyle,
            ),
          ),
          if (showKg) ...[
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Kg Añadidos',
                textAlign: TextAlign.center,
                style: headerStyle,
              ),
            ),
          ],
          // Columna vacía para el check (sin título)
          const SizedBox(width: 12),
          const SizedBox(width: 44),
        ],
      ),
    );
  }
}
