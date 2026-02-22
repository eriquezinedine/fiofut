import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ReposeStatCard extends StatelessWidget {
  const ReposeStatCard({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: AppSpacing.borderRadiusXl,
      ),
      child: Padding(
        padding: AppSpacing.paddingAllMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                letterSpacing: -0.32,
                height: 1.25,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              subtitle,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textDescription,
                letterSpacing: -0.28,
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
