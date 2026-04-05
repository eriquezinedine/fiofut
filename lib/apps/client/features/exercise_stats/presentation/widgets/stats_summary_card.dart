import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class StatsSummaryCard extends StatelessWidget {
  const StatsSummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    this.accentColor = AppColors.primary,
    super.key,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              borderRadius: AppSpacing.borderRadiusSm,
            ),
            child: Icon(icon, color: accentColor, size: 18),
          ),
          AppSpacing.verticalSm,
          Text(
            value,
            style: AppTextStyles.h3.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.small.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
