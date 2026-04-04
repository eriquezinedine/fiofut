import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// Error state widget for the week calendar.
class WeekCalendarError extends StatelessWidget {
  const WeekCalendarError({required this.message, super.key});

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
