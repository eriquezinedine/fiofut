import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/home/domain/models/models.dart';
import 'package:flutter/material.dart';

import 'activity_dots.dart';

/// Individual day item widget for the week calendar.
class WeekDayItem extends StatelessWidget {
  const WeekDayItem({
    required this.weekDay,
    required this.onTap,
    super.key,
  });

  final WeekDay weekDay;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = weekDay.isSelected;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.card : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              weekDay.dayName,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.white : AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${weekDay.dayNumber}',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? AppColors.white : AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 6),
            ActivityDots(weekDay: weekDay),
          ],
        ),
      ),
    );
  }
}
