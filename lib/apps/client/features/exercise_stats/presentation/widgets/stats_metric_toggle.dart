import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Metric toggle: "Peso (kg)" and "Distancia (km)".
///
/// [selectedMetric]: 0 = Peso, 1 = Distancia.
class StatsMetricToggle extends StatelessWidget {
  const StatsMetricToggle({
    required this.selectedMetric,
    required this.onChanged,
    super.key,
  });

  final int selectedMetric;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MetricButton(
            icon: LucideIcons.dumbbell,
            label: 'Peso (kg)',
            isSelected: selectedMetric == 0,
            activeColor: AppColors.primary,
            onTap: () => onChanged(0),
          ),
        ),
        AppSpacing.horizontalSm,
        Expanded(
          child: _MetricButton(
            icon: LucideIcons.mapPin,
            label: 'Distancia (km)',
            isSelected: selectedMetric == 1,
            activeColor: AppColors.blue,
            onTap: () => onChanged(1),
          ),
        ),
      ],
    );
  }
}

class _MetricButton extends StatelessWidget {
  const _MetricButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.activeColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final Color activeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withValues(alpha: 0.12)
              : AppColors.card,
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(
            color: isSelected ? activeColor : AppColors.border,
            width: isSelected ? 1.5 : 0.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? activeColor : AppColors.textMuted,
            ),
            AppSpacing.horizontalXs,
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: isSelected ? activeColor : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
