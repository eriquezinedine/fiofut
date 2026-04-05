import 'package:app_ui/app_ui.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Botón que muestra el rango de fechas seleccionado.
/// Al hacer tap abre un bottom sheet con CalendarDatePicker2 en modo rango.
class MonthRangeSelector extends StatelessWidget {
  const MonthRangeSelector({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onRangeChanged,
  });

  final DateTime startDate;
  final DateTime endDate;
  final ValueChanged<({DateTime start, DateTime end})> onRangeChanged;

  static const _months = [
    'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
    'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
  ];

  String _format(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')} ${_months[d.month - 1]}';

  Future<void> _openRangePicker(BuildContext context) async {
    final results = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.range,
        firstDate: DateTime(2024),
        lastDate: DateTime.now(),
        selectedDayHighlightColor: AppColors.primary,
        selectedRangeHighlightColor: AppColors.primary.withValues(alpha: 0.15),
        dayTextStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textPrimary,
        ),
        weekdayLabelTextStyle: AppTextStyles.caption.copyWith(
          color: AppColors.textMuted,
          fontWeight: FontWeight.w600,
        ),
        controlsTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        selectedDayTextStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.black,
          fontWeight: FontWeight.w700,
        ),
        todayTextStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
        disabledDayTextStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textMuted.withValues(alpha: 0.4),
        ),
        cancelButtonTextStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textSecondary,
        ),
        okButtonTextStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
      dialogBackgroundColor: AppColors.backgroundSecondary,
      dialogSize: const Size(325, 400),
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      value: [startDate, endDate],
    );

    if (results == null || results.isEmpty) return;

    final start = results.first;
    final end = results.length > 1 ? results.last : results.first;
    if (start == null) return;

    onRangeChanged((start: start, end: end ?? start));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openRangePicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.calendarDays,
                color: AppColors.primary, size: 16),
            const SizedBox(width: 8),
            Text(
              '${_format(startDate)} - ${_format(endDate)}',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(LucideIcons.chevronDown,
                color: AppColors.textMuted, size: 14),
          ],
        ),
      ),
    );
  }
}
