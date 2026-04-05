import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Boton para seleccionar rango de fechas del mes.
/// Por defecto: dia 1 hasta el ultimo dia del mes actual.
class MonthRangeSelector extends StatelessWidget {
  const MonthRangeSelector({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onTap,
  });

  final DateTime startDate;
  final DateTime endDate;
  final VoidCallback onTap;

  static const _months = [
    'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
    'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
  ];

  String _format(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')} ${_months[d.month - 1]}';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
