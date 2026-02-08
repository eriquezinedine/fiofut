import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class SliderHeight extends StatelessWidget {
  const SliderHeight({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.isCm,
  });

  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final bool isCm;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = constraints.maxHeight;

        // Ajustar parámetros según la unidad
        final lineSpacing = isCm ? 1.0 : 0.1;
        final pixelSpacing = isCm ? 8.0 : 20.0;
        final decimalPlaces = isCm ? 0 : 1;
        final majorInterval = 10;
        final mediumInterval = 5;

        return SizedBox(
          width: double.infinity,
          height: availableHeight,
          child: CustomRuler(
            minRange: min,
            maxRange: max,
            initialValue: value.clamp(min, max),
            orientation: RulerOrientation.vertical,
            lineSpacing: lineSpacing,
            pixelSpacing: pixelSpacing,
            rulerHeight: availableHeight,
            decimalPlaces: decimalPlaces,
            pointerColor: AppColors.green,
            pointerThickness: 3,
            pointerLength: 0,
            majorBarColor: AppColors.textMuted,
            mediumBarColor: AppColors.textMuted.withValues(alpha: 0.6),
            minorBarColor: AppColors.textMuted.withValues(alpha: 0.3),
            labelColor: AppColors.textMuted,
            alignmentPosition: AlignmentPosition.left,
            barAlignment: BarAlignment.end,
            majorInterval: majorInterval,
            mediumInterval: mediumInterval,
            enableSnapping: true,
            verticalPointerPositionFactor: 5,
            labelStyle: AppTextStyles.small.copyWith(
              color: AppColors.textMuted,
            ),
            onChange: onChanged,
          ),
        );
      },
    );
  }
}
