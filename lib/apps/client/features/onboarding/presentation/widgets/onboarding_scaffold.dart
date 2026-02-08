import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Scaffold base para todas las pantallas de onboarding
class OnboardingScaffold extends StatelessWidget {
  const OnboardingScaffold({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.progress,
    this.showBackButton = true,
    this.showSkipButton = false,
    this.onBack,
    this.onSkip,
    this.bottomSection,
    this.centerContent = false,
    this.scrollable = true,
  });

  final Widget child;
  final String? title;
  final String? subtitle;
  final double? progress;
  final bool showBackButton;
  final bool showSkipButton;
  final VoidCallback? onBack;
  final VoidCallback? onSkip;
  final Widget? bottomSection;
  final bool centerContent;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header con progress bar
            _buildHeader(context),
            // Content
            Expanded(
              child: scrollable
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _buildContent(),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _buildContent(),
                    ),
            ),
            // Bottom section
            if (bottomSection != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 34),
                child: bottomSection!,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment:
          centerContent ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          const SizedBox(height: 16),
          Text(
            title!,
            style: AppTextStyles.h2.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: centerContent ? TextAlign.center : null,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: centerContent ? 300 : null,
              child: Text(
                subtitle!,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                ),
                textAlign: centerContent ? TextAlign.center : null,
              ),
            ),
          ],
          const SizedBox(height: 16),
        ],
        if (scrollable) child else Expanded(child: child),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          if (showBackButton)
            CustomGestureDetector(
              onTap: onBack,
              child: const Icon(
                LucideIcons.arrowLeft,
                color: AppColors.textPrimary,
                size: 24,
              ),
            )
          else
            const SizedBox(width: 24),
          const SizedBox(width: 16),
          if (progress != null)
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress!.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            )
          else
            const Expanded(child: SizedBox()),
          if (showSkipButton) ...[
            const SizedBox(width: 16),
            CustomGestureDetector(
              onTap: onSkip,
              child: Text(
                'Saltar',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.green,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
