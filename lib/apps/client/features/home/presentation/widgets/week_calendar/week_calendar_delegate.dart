import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/home/domain/providers/providers.dart';
import 'package:flutter/material.dart';

import 'week_calendar_error.dart';
import 'week_calendar_loading.dart';
import 'week_page.dart';

/// Height constant for the week calendar.
const double kWeekCalendarHeight = 88;

/// Delegate for the week calendar sliver header.
class WeekCalendarDelegate extends SliverPersistentHeaderDelegate {
  const WeekCalendarDelegate({
    required this.pageController,
    required this.onPageChanged,
    required this.weekState,
  });

  final PageController pageController;
  final ValueChanged<int> onPageChanged;
  final WeekState weekState;

  static const int initialPage = 10000;

  @override
  double get minExtent => kWeekCalendarHeight;

  @override
  double get maxExtent => kWeekCalendarHeight;

  @override
  bool shouldRebuild(covariant WeekCalendarDelegate oldDelegate) {
    return weekState != oldDelegate.weekState;
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: kWeekCalendarHeight,
      color: AppColors.background,
      child: switch (weekState) {
        WeekInitial() || WeekLoading() => const WeekCalendarLoading(),
        WeekLoaded() => PageView.builder(
            controller: pageController,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              final pageIndex = index - initialPage;
              return WeekPage(pageIndex: pageIndex);
            },
          ),
        WeekError(:final message) => WeekCalendarError(message: message),
      },
    );
  }
}
