import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class SliderWeight extends StatelessWidget {
  const SliderWeight({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.isKg,
  });

  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final bool isKg;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 160,
          child: CustomRuler(
            minRange: min,
            maxRange: max,
            initialValue: value.clamp(min, max),
            lineSpacing: 0.5,
            pixelSpacing: 12,
            rulerHeight: 160,
            decimalPlaces: 1,
            pointerColor: AppColors.green,
            pointerThickness: 3,
            pointerLength: 0,
            majorBarColor: AppColors.textMuted,
            mediumBarColor: AppColors.textMuted.withValues(alpha: 0.6),
            minorBarColor: AppColors.textMuted.withValues(alpha: 0.3),
            labelColor: AppColors.textMuted,
            alignmentPosition: AlignmentPosition.top,
            barAlignment: BarAlignment.end,
            majorInterval: 10,
            mediumInterval: 5,
            enableSnapping: true,
            labelStyle: AppTextStyles.small.copyWith(
              color: AppColors.textMuted,
            ),
            onChange: onChanged,
          ),
        ),
        const SizedBox(height: 8),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text(
        //       '${min.toInt()} ${isKg ? 'kg' : 'lb'}',
        //       style: AppTextStyles.small.copyWith(
        //         color: AppColors.textMuted,
        //       ),
        //     ),
        //     Text(
        //       '${max.toInt()} ${isKg ? 'kg' : 'lb'}',
        //       style: AppTextStyles.small.copyWith(
        //         color: AppColors.textMuted,
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
