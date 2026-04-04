import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// Loading skeleton for the week calendar.
class WeekCalendarLoading extends StatelessWidget {
  const WeekCalendarLoading({super.key});

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
