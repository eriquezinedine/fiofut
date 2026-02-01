import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/features/home/domain/models/models.dart';
import 'package:fio_fut/features/home/domain/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Height constants for the week calendar.
const double _kWeekCalendarHeight = 88;

/// Sliver week calendar that pins to the top during scroll.
/// Uses [SliverPersistentHeader] with [PageView.builder] for optimal performance.
class SliverWeekCalendar extends ConsumerStatefulWidget {
  const SliverWeekCalendar({
    this.pinned = true,
    super.key,
  });

  /// Whether the header should remain pinned at the top.
  final bool pinned;

  @override
  ConsumerState<SliverWeekCalendar> createState() => _SliverWeekCalendarState();
}

class _SliverWeekCalendarState extends ConsumerState<SliverWeekCalendar> {
  late PageController _pageController;

  /// Large number to simulate infinite scroll in both directions.
  static const int _initialPage = 10000;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    final pageIndex = index - _initialPage;
    final weekStart =
        ref.read(weekProvider.notifier).getWeekStartForPage(pageIndex);
    ref.read(weekProvider.notifier).updateCurrentWeek(weekStart);
  }

  @override
  Widget build(BuildContext context) {
    final weekState = ref.watch(weekProvider);

    return SliverPersistentHeader(
      pinned: widget.pinned,
      delegate: _WeekCalendarDelegate(
        pageController: _pageController,
        onPageChanged: _onPageChanged,
        weekState: weekState,
      ),
    );
  }
}

/// Delegate for the week calendar sliver header.
class _WeekCalendarDelegate extends SliverPersistentHeaderDelegate {
  const _WeekCalendarDelegate({
    required this.pageController,
    required this.onPageChanged,
    required this.weekState,
  });

  final PageController pageController;
  final ValueChanged<int> onPageChanged;
  final WeekState weekState;

  static const int _initialPage = 10000;

  @override
  double get minExtent => _kWeekCalendarHeight;

  @override
  double get maxExtent => _kWeekCalendarHeight;

  @override
  bool shouldRebuild(covariant _WeekCalendarDelegate oldDelegate) {
    return weekState != oldDelegate.weekState;
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: _kWeekCalendarHeight,
      color: AppColors.background,
      child: switch (weekState) {
        WeekInitial() || WeekLoading() => const _WeekCalendarLoading(),
        WeekLoaded() => _buildPageView(),
        WeekError(:final message) => _WeekCalendarError(message: message),
      },
    );
  }

  Widget _buildPageView() {
    return PageView.builder(
      controller: pageController,
      onPageChanged: onPageChanged,
      itemBuilder: (context, index) {
        final pageIndex = index - _initialPage;
        return _WeekPage(pageIndex: pageIndex);
      },
    );
  }
}

/// Single week page showing 7 days.
class _WeekPage extends ConsumerWidget {
  const _WeekPage({required this.pageIndex});

  final int pageIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch state to rebuild on selection change
    ref.watch(weekProvider);

    final notifier = ref.read(weekProvider.notifier);
    final weekStart = notifier.getWeekStartForPage(pageIndex);
    final weekDays = notifier.getWeekDays(weekStart);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (final day in weekDays)
            _WeekDayItem(
              weekDay: day,
              onTap: () => notifier.selectDay(day.date),
            ),
        ],
      ),
    );
  }
}

/// Individual day item widget.
class _WeekDayItem extends StatelessWidget {
  const _WeekDayItem({
    required this.weekDay,
    required this.onTap,
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
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 12,
        ),
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
            _ActivityDots(weekDay: weekDay),
          ],
        ),
      ),
    );
  }
}

/// Activity indicator dots.
class _ActivityDots extends StatelessWidget {
  const _ActivityDots({required this.weekDay});

  final WeekDay weekDay;

  @override
  Widget build(BuildContext context) {
    final hasMeals = weekDay.hasMeals;
    final hasExercise = weekDay.hasExercise;

    if (!hasMeals && !hasExercise) {
      return const SizedBox(height: 6);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasMeals)
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
        if (hasMeals && hasExercise) const SizedBox(width: 4),
        if (hasExercise)
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.blue,
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }
}

/// Loading skeleton for week calendar.
class _WeekCalendarLoading extends StatelessWidget {
  const _WeekCalendarLoading();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          7,
          (index) => Container(
            width: 40,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.card.withAlpha(128),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}

/// Error state widget.
class _WeekCalendarError extends StatelessWidget {
  const _WeekCalendarError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Error: $message',
        style: const TextStyle(
          color: AppColors.textMuted,
          fontSize: 14,
        ),
      ),
    );
  }
}
