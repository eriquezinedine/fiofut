import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Indicates whether local data is synced with the backend.
///
/// - [isSynced] `true`: shows a green check icon (all data uploaded).
/// - [isSynced] `false`: shows an orange cloud-off icon (pending uploads).
class SyncStatusIndicator extends StatelessWidget {
  const SyncStatusIndicator({required this.isSynced, super.key});

  final bool isSynced;

  @override
  Widget build(BuildContext context) {
    final color = isSynced ? AppColors.primary : AppColors.orange;
    final icon = isSynced ? LucideIcons.cloud : LucideIcons.cloudOff;
    final label = isSynced ? 'Synced' : 'Pending';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.body.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
