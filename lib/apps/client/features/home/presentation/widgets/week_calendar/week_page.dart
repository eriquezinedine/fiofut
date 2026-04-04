import 'package:fio_fut/apps/client/features/home/domain/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'week_day_item.dart';

/// Single week page showing 7 days in a horizontal row.
class WeekPage extends ConsumerWidget {
  const WeekPage({required this.pageIndex, super.key});

  final int pageIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            WeekDayItem(
              weekDay: day,
              onTap: () => notifier.selectDay(day.date),
            ),
        ],
      ),
    );
  }
}
