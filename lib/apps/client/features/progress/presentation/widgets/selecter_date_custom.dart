import 'package:app_ui/app_ui.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:fio_fut/core/widgets/modal/date_filter_modal.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SelecterDateCustom extends StatefulWidget {
  const SelecterDateCustom({
    super.key,
    this.onDateRangeChanged,
    this.initialDate,
  });

  final ValueChanged<({DateTime start, DateTime end})>? onDateRangeChanged;

  /// Si se pasa, el widget inicia en modo diario con esta fecha seleccionada.
  final DateTime? initialDate;

  @override
  State<SelecterDateCustom> createState() => _SelecterDateCustomState();
}

class _SelecterDateCustomState extends State<SelecterDateCustom> {
  DateFilterType _filterType = DateFilterType.daily;
  List<_TabItem> _tabs = [];
  int _selectedIndex = 0;
  int _loadedCount = 10;
  bool _isLoadingMore = false;
  final _scrollController = ScrollController();

  DateTime? _customStart;
  DateTime? _customEnd;

  static const _months = [
    'Ene',
    'Feb',
    'Mar',
    'Abr',
    'May',
    'Jun',
    'Jul',
    'Ago',
    'Sep',
    'Oct',
    'Nov',
    'Dic',
  ];

  @override
  void initState() {
    super.initState();
    _filterType = DateFilterType.daily;
    _buildTabs(scrollToEnd: widget.initialDate == null);
    _scrollController.addListener(_onScroll);

    // Si hay una fecha inicial, seleccionar ese día
    if (widget.initialDate != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _selectDateIfExists(widget.initialDate!);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _buildTabs({bool scrollToEnd = false}) {
    _tabs = switch (_filterType) {
      DateFilterType.daily => _buildDailyTabs(),
      DateFilterType.weekly => _buildWeeklyTabs(),
      DateFilterType.monthly => _buildMonthlyTabs(),
      DateFilterType.custom => _buildCustomTab(),
    };

    _selectedIndex = _filterType == DateFilterType.monthly
        ? DateTime.now().month - 1
        : _tabs.length - 1;

    if (scrollToEnd) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
        _notifySelected();
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => _notifySelected());
    }
  }

  void _notifySelected() {
    if (_selectedIndex < _tabs.length) {
      final tab = _tabs[_selectedIndex];
      widget.onDateRangeChanged?.call((start: tab.start, end: tab.end));
    }
  }

  void _onScroll() {
    if (_isLoadingMore) return;
    if (_scrollController.position.pixels > 50) return;
    if (_filterType != DateFilterType.daily &&
        _filterType != DateFilterType.weekly)
      return;
    _loadMore();
  }

  void _loadMore() {
    _isLoadingMore = true;
    final oldLength = _tabs.length;
    final oldScrollMax = _scrollController.position.maxScrollExtent;
    final oldPixels = _scrollController.position.pixels;

    _loadedCount += 10;
    _tabs = _filterType == DateFilterType.daily
        ? _buildDailyTabs()
        : _buildWeeklyTabs();
    _selectedIndex += _tabs.length - oldLength;

    setState(() {});

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final newScrollMax = _scrollController.position.maxScrollExtent;
        final addedExtent = newScrollMax - oldScrollMax;
        _scrollController.jumpTo(oldPixels + addedExtent);
      }
      _isLoadingMore = false;
    });
  }

  void _selectIndex(int index) {
    setState(() => _selectedIndex = index);
    _notifySelected();
  }

  /// Busca la fecha en los tabs y la selecciona. Scroll a esa posición.
  void _selectDateIfExists(DateTime date) {
    final target = DateTime(date.year, date.month, date.day);
    for (var i = 0; i < _tabs.length; i++) {
      final tabDate = DateTime(
        _tabs[i].start.year,
        _tabs[i].start.month,
        _tabs[i].start.day,
      );
      if (tabDate == target) {
        setState(() => _selectedIndex = i);
        _notifySelected();
        // Scroll a la posición del item
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            final estimatedOffset = i * 80.0;
            _scrollController.animateTo(
              estimatedOffset.clamp(
                0,
                _scrollController.position.maxScrollExtent,
              ),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
        return;
      }
    }
  }

  // ── Builders ──────────────────────────────────────────────────

  List<_TabItem> _buildDailyTabs() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return List.generate(_loadedCount, (i) {
      final offset = _loadedCount - 1 - i;
      final date = today.subtract(Duration(days: offset));
      final label =
          '${date.day.toString().padLeft(2, '0')} ${_months[date.month - 1]}';
      return _TabItem(label: label, start: date, end: date);
    });
  }

  List<_TabItem> _buildWeeklyTabs() {
    final now = DateTime.now();
    final thisMonday = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));

    return List.generate(_loadedCount, (i) {
      final offset = _loadedCount - 1 - i;
      final start = thisMonday.subtract(Duration(days: offset * 7));
      final end = start.add(const Duration(days: 6));
      final label = offset == 0
          ? 'Esta sem'
          : '${start.day} ${_months[start.month - 1]} - ${end.day} ${_months[end.month - 1]}';
      return _TabItem(label: label, start: start, end: end);
    });
  }

  List<_TabItem> _buildMonthlyTabs() {
    final now = DateTime.now();
    return List.generate(12, (i) {
      final month = i + 1;
      final start = DateTime(now.year, month, 1);
      final end = DateTime(now.year, month + 1, 0);
      return _TabItem(label: _months[i], start: start, end: end);
    });
  }

  List<_TabItem> _buildCustomTab() {
    if (_customStart == null || _customEnd == null) {
      final now = DateTime.now();
      return [_TabItem(label: 'Seleccionar rango', start: now, end: now)];
    }
    final s = _customStart!;
    final e = _customEnd!;
    final label =
        '${s.day} ${_months[s.month - 1]} - ${e.day} ${_months[e.month - 1]}';
    return [_TabItem(label: label, start: s, end: e)];
  }

  // ── Modal ─────────────────────────────────────────────────────

  Future<void> _openFilterModal() async {
    final result = await DateFilterModal.show(
      context,
      currentType: _filterType,
    );
    if (result == null || !mounted) return;

    if (result.type == DateFilterType.custom) {
      // Modal se cerró, ahora abrir el calendar dialog
      final dates = await showCalendarDatePicker2Dialog(
        context: context,
        config: CalendarDatePicker2WithActionButtonsConfig(
          calendarType: CalendarDatePicker2Type.range,
          firstDate: DateTime(2024),
          lastDate: DateTime.now(),
          selectedDayHighlightColor: AppColors.primary,
          selectedRangeHighlightColor: AppColors.primary.withValues(
            alpha: 0.15,
          ),
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
          lastMonthIcon: const Icon(
            LucideIcons.chevronLeft,
            color: AppColors.textPrimary,
            size: 18,
          ),
          nextMonthIcon: const Icon(
            LucideIcons.chevronRight,
            color: AppColors.textPrimary,
            size: 18,
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
        value: [_customStart, _customEnd],
      );

      if (dates == null || dates.isEmpty || !mounted) return;

      setState(() {
        _filterType = DateFilterType.custom;
        _customStart = dates.first;
        _customEnd = dates.length > 1 ? dates.last : dates.first;
        _loadedCount = 10;
        _buildTabs(scrollToEnd: true);
      });
    } else {
      setState(() {
        _filterType = result.type;
        _loadedCount = 10;
        _buildTabs(scrollToEnd: true);
      });
    }
  }

  // ── UI ────────────────────────────────────────────────────────

  Color get _iconColor => switch (_filterType) {
    DateFilterType.daily => AppColors.primary,
    DateFilterType.weekly => AppColors.blue,
    DateFilterType.monthly => AppColors.orange,
    DateFilterType.custom => AppColors.purple,
  };

  Widget _buildChip(_TabItem tab, bool isSelected) {
    return GestureDetector(
      onTap: () => _selectIndex(_tabs.indexOf(tab)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        alignment: Alignment.center,
        child: Text(
          tab.label,
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.black : AppColors.textMuted,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 34,
            child: _filterType == DateFilterType.custom && _tabs.length == 1
                ? Center(
                    child: SizedBox(
                      width: 160,
                      child: _buildChip(_tabs.first, true),
                    ),
                  )
                : ListView.separated(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: _tabs.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 6),
                    itemBuilder: (context, index) {
                      return _buildChip(_tabs[index], index == _selectedIndex);
                    },
                  ),
          ),
        ),
        Padding(
          padding: AppSpacing.xs.horizontal,
          child: DecoratedBox(
            decoration: BoxDecoration(color: AppColors.textDimmed),
            child: const SizedBox(width: 1.5, height: 18),
          ),
        ),
        CustomGestureDetector(
          onTap: _openFilterModal,
          child: Icon(LucideIcons.calendarClock, color: _iconColor, size: 24),
        ),
      ],
    );
  }
}

class _TabItem {
  const _TabItem({required this.label, required this.start, required this.end});

  final String label;
  final DateTime start;
  final DateTime end;
}
