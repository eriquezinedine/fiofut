import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Boton principal para continuar en el onboarding
class OnboardingContinueButton extends StatelessWidget {
  const OnboardingContinueButton({
    super.key,
    required this.onPressed,
    this.text = 'Continuar',
    this.isEnabled = true,
    this.backgroundColor,
  });

  final VoidCallback? onPressed;
  final String text;
  final bool isEnabled;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.green,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.surface,
          disabledForegroundColor: AppColors.textMuted,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Text(
          text,
          style: AppTextStyles.button.copyWith(
            color: isEnabled ? AppColors.black : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}

/// Boton circular de navegacion (flecha)
class OnboardingNavButton extends StatelessWidget {
  const OnboardingNavButton({
    super.key,
    required this.onPressed,
    this.isEnabled = true,
    this.backgroundColor,
  });

  final VoidCallback? onPressed;
  final bool isEnabled;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return CustomGestureDetector(
      onTap: isEnabled ? onPressed : null,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: isEnabled ? (backgroundColor ?? AppColors.green) : AppColors.surface,
          shape: BoxShape.circle,
        ),
        child: Icon(
          LucideIcons.arrowRight,
          color: isEnabled ? AppColors.white : AppColors.textMuted,
          size: 24,
        ),
      ),
    );
  }
}

/// Boton secundario para acciones alternativas en el onboarding
class OnboardingSecondaryButton extends StatelessWidget {
  const OnboardingSecondaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.isEnabled = true,
  });

  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.card,
          disabledForegroundColor: AppColors.textMuted,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: isEnabled ? AppColors.white : AppColors.textMuted,
                size: 20,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: AppTextStyles.button.copyWith(
                color: isEnabled ? AppColors.white : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Card de opcion seleccionable
class OnboardingOptionCard extends StatelessWidget {
  const OnboardingOptionCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.isSelected = false,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CustomGestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                size: 24,
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.textMuted,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      color: AppColors.black,
                      size: 16,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
