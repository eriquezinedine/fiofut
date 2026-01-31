import 'package:flutter/material.dart';
import '../colors/app_colors.dart';
import '../spacing/app_spacing.dart';
import 'app_button.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    super.key,
    this.title = 'Algo salió mal',
    this.message,
    this.onRetry,
    this.icon = Icons.error_outline,
  });

  final String title;
  final String? message;
  final VoidCallback? onRetry;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: AppColors.error,
            ),
            AppSpacing.verticalLg,
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              AppSpacing.verticalSm,
              Text(
                message!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              AppSpacing.verticalXl,
              AppButton(
                text: 'Reintentar',
                onPressed: onRetry,
                fullWidth: false,
                icon: Icons.refresh,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class AppErrorBanner extends StatelessWidget {
  const AppErrorBanner({
    super.key,
    required this.message,
    this.onDismiss,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onDismiss;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.15),
        borderRadius: AppSpacing.borderRadiusSm,
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: 24,
          ),
          AppSpacing.horizontalSm,
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.error,
                  ),
            ),
          ),
          if (onRetry != null)
            IconButton(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, color: AppColors.error),
              visualDensity: VisualDensity.compact,
            ),
          if (onDismiss != null)
            IconButton(
              onPressed: onDismiss,
              icon: const Icon(Icons.close, color: AppColors.error),
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  }
}

class AppSuccessBanner extends StatelessWidget {
  const AppSuccessBanner({
    super.key,
    required this.message,
    this.onDismiss,
  });

  final String message;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.15),
        borderRadius: AppSpacing.borderRadiusSm,
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: AppColors.success,
            size: 24,
          ),
          AppSpacing.horizontalSm,
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.success,
                  ),
            ),
          ),
          if (onDismiss != null)
            IconButton(
              onPressed: onDismiss,
              icon: const Icon(Icons.close, color: AppColors.success),
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  }
}
