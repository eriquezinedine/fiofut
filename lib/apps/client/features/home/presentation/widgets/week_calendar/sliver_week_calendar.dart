import 'package:fio_fut/apps/client/features/home/domain/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'week_calendar_delegate.dart';

/// Sliver week calendar that pins to the top during scroll.
/// Uses [SliverPersistentHeader] with [PageView.builder] for optimal performance.
class SliverWeekCalendar extends ConsumerStatefulWidget {
  const SliverWeekCalendar({
    this.pinned = true,
    super.key,
  });

  final bool pinned;

  @override
  ConsumerState<SliverWeekCalendar> createState() => _SliverWeekCalendarState();
}

class _SliverWeekCalendarState extends ConsumerState<SliverWeekCalendar> {
  late PageController _pageController;

  static const int _initialPage = WeekCalendarDelegate.initialPage;

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
      delegate: WeekCalendarDelegate(
        pageController: _pageController,
        onPageChanged: _onPageChanged,
        weekState: weekState,
      ),
    );
  }
}
