import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../exercise_home/domain/model/exercise_schedule_item.dart';

class SerieTableHeaders extends StatelessWidget {
  const SerieTableHeaders({
    super.key,
    required this.middleHeader,
    this.showKg = true,
  });

  final String middleHeader;
  final bool showKg;

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyles.caption.copyWith(
      fontWeight: FontWeight.w500,
      color: AppColors.textDescription,
    );

    return Row(
      children: [
        SizedBox(
          width: 40,
          child: Text('Serie', textAlign: TextAlign.center, style: style),
        ),
        const SizedBox(width: 8),
        Expanded(
          child:
              Text(middleHeader, textAlign: TextAlign.center, style: style),
        ),
        if (showKg) ...[
          const SizedBox(width: 8),
          Expanded(
            child: Text('Kg', textAlign: TextAlign.center, style: style),
          ),
        ],
      ],
    );
  }
}

class SerieTableRow extends StatelessWidget {
  const SerieTableRow({
    super.key,
    required this.set,
    required this.isCardio,
    required this.showKg,
  });

  final ExerciseSetData set;
  final bool isCardio;
  final bool showKg;

  @override
  Widget build(BuildContext context) {
    final completed = set.isCompleted;
    final bgColor =
        completed ? AppColors.primary : AppColors.backgroundSecondary;
    final textColor = completed ? AppColors.black : AppColors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: completed
                ? Icon(LucideIcons.check, color: AppColors.black, size: 16)
                : Text(
                    '${set.setNumber}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                isCardio ? _formatTime() : '${set.repetitions ?? 0}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          if (showKg) ...[
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  _formatKg(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime() {
    final mins = set.minutes ?? 0;
    final secs = set.seconds ?? 0;
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }

  String _formatKg() {
    final kg = set.weight ?? 0;
    return kg == kg.roundToDouble() ? kg.toInt().toString() : kg.toString();
  }
}
