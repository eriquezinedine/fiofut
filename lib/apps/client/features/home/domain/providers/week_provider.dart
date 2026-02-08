import 'package:fio_fut/apps/client/features/home/domain/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'week_state.dart';

/// Provider for the week calendar state.
final weekProvider = NotifierProvider<WeekNotifier, WeekState>(
  WeekNotifier.new,
);

/// Notifier that manages the week calendar state.
class WeekNotifier extends Notifier<WeekState> {
  /// Cache of weeks by their start date (Monday).
  final Map<DateTime, List<WeekDay>> _weeksCache = {};

  /// Reference date for calculating page indices.
  late final DateTime _referenceMonday;

  @override
  WeekState build() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    _referenceMonday = _getMondayOfWeek(today);

    return WeekLoaded(
      selectedDate: today,
      currentWeekStart: _referenceMonday,
    );
  }

  /// Gets the Monday of the week containing [date].
  DateTime _getMondayOfWeek(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return DateTime(date.year, date.month, date.day - daysFromMonday);
  }

  /// Gets week days for a specific week starting from [weekStart].
  /// Uses cache for performance.
  List<WeekDay> getWeekDays(DateTime weekStart) {
    final monday = _getMondayOfWeek(weekStart);
    final cacheKey = DateTime(monday.year, monday.month, monday.day);

    if (_weeksCache.containsKey(cacheKey)) {
      return _updateSelection(_weeksCache[cacheKey]!);
    }

    final days = _generateWeekDays(monday);
    _weeksCache[cacheKey] = days;

    // Limit cache size to prevent memory issues
    if (_weeksCache.length > 20) {
      final keysToRemove = _weeksCache.keys.take(5).toList();
      for (final key in keysToRemove) {
        _weeksCache.remove(key);
      }
    }

    return _updateSelection(days);
  }

  List<WeekDay> _generateWeekDays(DateTime monday) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return List.generate(7, (index) {
      final date = monday.add(Duration(days: index));
      final dateOnly = DateTime(date.year, date.month, date.day);
      final isToday = dateOnly == today;

      return WeekDay(
        date: dateOnly,
        dayName: _getDayName(date.weekday),
        dayNumber: date.day,
        isSelected: false,
        isToday: isToday,
        hasMeals: false,
        hasExercise: false,
      );
    });
  }

  List<WeekDay> _updateSelection(List<WeekDay> days) {
    if (state is! WeekLoaded) return days;
    final selectedDate = (state as WeekLoaded).selectedDate;

    return days.map((day) {
      final dayDate = DateTime(day.date.year, day.date.month, day.date.day);
      final selected = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      );
      return day.copyWith(isSelected: dayDate == selected);
    }).toList();
  }

  String _getDayName(int weekday) {
    const dayNames = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    return dayNames[weekday - 1];
  }

  /// Calculates the week start date for a given page index.
  /// Page 0 is the reference week (current week at initialization).
  DateTime getWeekStartForPage(int pageIndex) {
    return _referenceMonday.add(Duration(days: pageIndex * 7));
  }

  /// Gets the page index for a given date.
  int getPageIndexForDate(DateTime date) {
    final monday = _getMondayOfWeek(date);
    final difference = monday.difference(_referenceMonday).inDays;
    return difference ~/ 7;
  }

  /// Selects a specific day in the week calendar.
  void selectDay(DateTime date) {
    if (state is! WeekLoaded) return;

    final selectedDate = DateTime(date.year, date.month, date.day);
    final currentState = state as WeekLoaded;

    state = currentState.copyWith(
      selectedDate: selectedDate,
      currentWeekStart: _getMondayOfWeek(selectedDate),
    );

    // Invalidate cache to update selection
    _weeksCache.clear();
  }

  /// Updates the current week being viewed.
  void updateCurrentWeek(DateTime weekStart) {
    if (state is! WeekLoaded) return;
    final currentState = state as WeekLoaded;

    state = currentState.copyWith(
      currentWeekStart: _getMondayOfWeek(weekStart),
    );
  }

  /// Updates the activity indicators for a specific day.
  void updateDayActivity({
    required DateTime date,
    bool? hasMeals,
    bool? hasExercise,
  }) {
    final monday = _getMondayOfWeek(date);
    final cacheKey = DateTime(monday.year, monday.month, monday.day);

    if (_weeksCache.containsKey(cacheKey)) {
      final days = _weeksCache[cacheKey]!;
      final targetDate = DateTime(date.year, date.month, date.day);

      _weeksCache[cacheKey] = days.map((day) {
        final dayDate = DateTime(day.date.year, day.date.month, day.date.day);
        if (dayDate == targetDate) {
          return day.copyWith(
            hasMeals: hasMeals ?? day.hasMeals,
            hasExercise: hasExercise ?? day.hasExercise,
          );
        }
        return day;
      }).toList();
    }
  }

  /// Clears the weeks cache.
  void clearCache() {
    _weeksCache.clear();
  }
}
