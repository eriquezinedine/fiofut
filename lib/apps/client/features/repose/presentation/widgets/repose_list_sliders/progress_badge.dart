import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// Pill-shaped badge showing a percentage value.
class ProgressBadge extends StatelessWidget {
  const ProgressBadge({
    required this.text,
    required this.color,
    super.key,
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: AppSpacing.borderRadiusFull,
      ),
      child: Center(
        widthFactor: 1,
        child: Text(
          text,
          style: AppTextStyles.titleSmall.copyWith(
            letterSpacing: -0.28,
            color: color,
          ),
        ),
      ),
    );
  }
}
