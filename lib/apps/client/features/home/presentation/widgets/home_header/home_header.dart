import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'day_fire_home.dart';
import 'sync_status_indicator.dart';

/// Home header widget (normal, no Sliver).
class HomeHeader extends StatelessWidget {
  const HomeHeader({required this.streak, super.key});

  final int streak;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.apple, color: AppColors.white, size: 28),
              const SizedBox(width: 8),
              Text(
                'FioFit',
                style: AppTextStyles.h2.copyWith(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          Row(
            children: [
              SyncStatusIndicator(isSynced: false),
              const SizedBox(width: 8),
              DayFireHome(streak: streak),
            ],
          ),
        ],
      ),
    );
  }
}
