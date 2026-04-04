import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/home/domain/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'week_calendar_delegate.dart';
import 'week_page.dart';

/// Non-sliver week calendar widget with horizontal PageView.
class WeekCalendarWidget extends ConsumerStatefulWidget {
  const WeekCalendarWidget({super.key});

  @override
  ConsumerState<WeekCalendarWidget> createState() => _WeekCalendarWidgetState();
}

class _WeekCalendarWidgetState extends ConsumerState<WeekCalendarWidget> {
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

  @override
  Widget build(BuildContext context) {
    final weekState = ref.watch(weekProvider);

    if (weekState is! WeekLoaded) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        final pageIndex = index - _initialPage;
        final weekStart =
            ref.read(weekProvider.notifier).getWeekStartForPage(pageIndex);
        ref.read(weekProvider.notifier).updateCurrentWeek(weekStart);
      },
      itemBuilder: (context, index) {
        final pageIndex = index - _initialPage;
        return WeekPage(pageIndex: pageIndex);
      },
    );
  }
}
