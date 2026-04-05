import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// PageView horizontal que muestra semanas navegables.
/// Cada página muestra el rango "DD Mmm - DD Mmm" de la semana.
class WeekSelector extends StatefulWidget {
  const WeekSelector({
    super.key,
    required this.onWeekChanged,
    this.weeksBack = 12,
  });

  final ValueChanged<({DateTime start, DateTime end})> onWeekChanged;
  final int weeksBack;

  @override
  State<WeekSelector> createState() => _WeekSelectorState();
}

class _WeekSelectorState extends State<WeekSelector> {
  late final PageController _controller;
  late final List<({DateTime start, DateTime end})> _weeks;
  late int _currentPage;

  static const _months = [
    'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
    'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
  ];

  @override
  void initState() {
    super.initState();
    _weeks = _buildWeeks();
    _currentPage = _weeks.length - 1;
    _controller = PageController(initialPage: _currentPage);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onWeekChanged(_weeks[_currentPage]);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<({DateTime start, DateTime end})> _buildWeeks() {
    final now = DateTime.now();
    // Lunes de esta semana
    final thisMonday = now.subtract(Duration(days: now.weekday - 1));
    final today = DateTime(thisMonday.year, thisMonday.month, thisMonday.day);

    return List.generate(widget.weeksBack, (i) {
      final offset = widget.weeksBack - 1 - i;
      final start = today.subtract(Duration(days: offset * 7));
      final end = start.add(const Duration(days: 6));
      return (start: start, end: end);
    });
  }

  String _formatRange(({DateTime start, DateTime end}) week) {
    final s = '${week.start.day} ${_months[week.start.month - 1]}';
    final e = '${week.end.day} ${_months[week.end.month - 1]}';
    return '$s - $e';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          // Left arrow
          GestureDetector(
            onTap: _currentPage > 0
                ? () => _controller.previousPage(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                    )
                : null,
            child: Icon(
              LucideIcons.chevronLeft,
              color: _currentPage > 0
                  ? AppColors.textPrimary
                  : AppColors.textMuted,
              size: 20,
            ),
          ),
          // PageView
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: _weeks.length,
              onPageChanged: (page) {
                setState(() => _currentPage = page);
                widget.onWeekChanged(_weeks[page]);
              },
              itemBuilder: (context, index) {
                final isCurrentWeek = index == _weeks.length - 1;
                return Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isCurrentWeek
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : AppColors.card,
                      borderRadius: BorderRadius.circular(100),
                      border: isCurrentWeek
                          ? Border.all(
                              color: AppColors.primary.withValues(alpha: 0.3),
                            )
                          : null,
                    ),
                    child: Text(
                      isCurrentWeek
                          ? 'Esta semana'
                          : _formatRange(_weeks[index]),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isCurrentWeek
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Right arrow
          GestureDetector(
            onTap: _currentPage < _weeks.length - 1
                ? () => _controller.nextPage(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                    )
                : null,
            child: Icon(
              LucideIcons.chevronRight,
              color: _currentPage < _weeks.length - 1
                  ? AppColors.textPrimary
                  : AppColors.textMuted,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
