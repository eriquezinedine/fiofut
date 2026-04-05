import 'package:app_ui/app_ui.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

enum DateFilterType { daily, weekly, monthly, custom }

class DateFilterResult {
  const DateFilterResult({
    required this.type,
    this.customStart,
    this.customEnd,
  });

  final DateFilterType type;
  final DateTime? customStart;
  final DateTime? customEnd;
}

class DateFilterModal extends StatefulWidget {
  const DateFilterModal._({required this.currentType});

  final DateFilterType currentType;

  static Future<DateFilterResult?> show(
    BuildContext context, {
    DateFilterType currentType = DateFilterType.daily,
  }) {
    return showModalBottomSheet<DateFilterResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DateFilterModal._(currentType: currentType),
    );
  }

  @override
  State<DateFilterModal> createState() => _DateFilterModalState();
}

class _DateFilterModalState extends State<DateFilterModal> {
  late DateFilterType _selected;
  DateTime? _customStart;
  DateTime? _customEnd;

  @override
  void initState() {
    super.initState();
    _selected = widget.currentType;
  }

  Future<void> _pickCustomRange() async {
    final results = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.range,
        firstDate: DateTime(2024),
        lastDate: DateTime.now(),
        selectedDayHighlightColor: AppColors.primary,
        selectedRangeHighlightColor:
            AppColors.primary.withValues(alpha: 0.15),
        dayBorderRadius: BorderRadius.circular(8),
        dayTextStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textPrimary,
        ),
        yearTextStyle: AppTextStyles.bodySmall.copyWith(
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
        selectedRangeDayTextStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        todayTextStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
        disabledDayTextStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.textMuted.withValues(alpha: 0.4),
        ),
        lastMonthIcon: const Icon(LucideIcons.chevronLeft,
            color: AppColors.textPrimary, size: 18),
        nextMonthIcon: const Icon(LucideIcons.chevronRight,
            color: AppColors.textPrimary, size: 18),
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
      value: [_customStart, _customEnd],
    );

    if (results == null || results.isEmpty || !mounted) return;

    setState(() {
      _customStart = results.first;
      _customEnd = results.length > 1 ? results.last : results.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.md),
            child: Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text('Filtrar por', style: AppTextStyles.h2),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(LucideIcons.x,
                      color: AppColors.textPrimary, size: 24),
                ),
              ],
            ),
          ),
          // Options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              children: [
                _Option(
                  icon: LucideIcons.calendar,
                  title: 'Diario',
                  subtitle: 'Ver por cada día',
                  isSelected: _selected == DateFilterType.daily,
                  onTap: () => setState(() {
                    _selected = DateFilterType.daily;

                  }),
                ),
                const SizedBox(height: AppSpacing.sm),
                _Option(
                  icon: LucideIcons.calendarDays,
                  title: 'Semanal',
                  subtitle: 'Ver por semana (Lun - Dom)',
                  isSelected: _selected == DateFilterType.weekly,
                  onTap: () => setState(() {
                    _selected = DateFilterType.weekly;

                  }),
                ),
                const SizedBox(height: AppSpacing.sm),
                _Option(
                  icon: LucideIcons.calendarRange,
                  title: 'Mensual',
                  subtitle: 'Ver los 12 meses del año',
                  isSelected: _selected == DateFilterType.monthly,
                  onTap: () => setState(() {
                    _selected = DateFilterType.monthly;

                  }),
                ),
                const SizedBox(height: AppSpacing.sm),
                _Option(
                  icon: LucideIcons.calendarClock,
                  title: 'Rango personalizado',
                  subtitle: 'Selecciona un rango de fechas',
                  isSelected: _selected == DateFilterType.custom,
                  onTap: () => setState(() {
                    _selected = DateFilterType.custom;
                  }),
                ),
              ],
            ),
          ),
          // Button
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              MediaQuery.of(context).viewPadding.bottom + AppSpacing.lg,
            ),
            child: AppButton(
              text: 'Aplicar',
              onPressed: _canConfirm
                  ? () => Navigator.pop(
                        context,
                        DateFilterResult(
                          type: _selected,
                          customStart: _customStart,
                          customEnd: _customEnd,
                        ),
                      )
                  : null,
              fullWidth: true,
            ),
          ),
        ],
      ),
    );
  }

  bool get _canConfirm => true;

  static const _months = [
    'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
    'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
  ];

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')} ${_months[d.month - 1]}';
}

class _Option extends StatelessWidget {
  const _Option({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xs,
          AppSpacing.xs,
          AppSpacing.md,
          AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: AppSpacing.borderRadiusXl,
          border: isSelected
              ? Border.all(color: AppColors.primary.withValues(alpha: 0.5))
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.2)
                    : AppColors.surface,
                borderRadius: AppSpacing.borderRadiusMd,
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.textMuted,
                size: 22,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : AppColors.card,
                border: isSelected
                    ? null
                    : Border.all(color: AppColors.surface),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 12, color: AppColors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
