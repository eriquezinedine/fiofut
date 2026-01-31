import 'package:flutter/material.dart';
import '../colors/app_colors.dart';
import '../spacing/app_spacing.dart';
import '../typography/app_text_styles.dart';

enum AppButtonType { primary, secondary, outlined, text }
enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.fullWidth = true,
  });

  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final AppButtonSize size;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;
  final IconPosition iconPosition;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final buttonHeight = _getButtonHeight();
    final textStyle = _getTextStyle();
    final isEnabled = !isDisabled && !isLoading && onPressed != null;

    Widget child = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                type == AppButtonType.primary
                    ? AppColors.black
                    : AppColors.primary,
              ),
            ),
          )
        : _buildContent(textStyle);

    switch (type) {
      case AppButtonType.primary:
        return SizedBox(
          width: fullWidth ? double.infinity : null,
          height: buttonHeight,
          child: ElevatedButton(
            onPressed: isEnabled ? onPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.black,
              disabledBackgroundColor: AppColors.surface,
              disabledForegroundColor: AppColors.textMuted,
            ),
            child: child,
          ),
        );

      case AppButtonType.secondary:
        return SizedBox(
          width: fullWidth ? double.infinity : null,
          height: buttonHeight,
          child: ElevatedButton(
            onPressed: isEnabled ? onPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: AppColors.white,
              disabledBackgroundColor: AppColors.surface,
              disabledForegroundColor: AppColors.textMuted,
            ),
            child: child,
          ),
        );

      case AppButtonType.outlined:
        return SizedBox(
          width: fullWidth ? double.infinity : null,
          height: buttonHeight,
          child: OutlinedButton(
            onPressed: isEnabled ? onPressed : null,
            child: child,
          ),
        );

      case AppButtonType.text:
        return TextButton(
          onPressed: isEnabled ? onPressed : null,
          child: child,
        );
    }
  }

  Widget _buildContent(TextStyle textStyle) {
    if (icon == null) {
      return Text(text, style: textStyle);
    }

    final iconWidget = Icon(icon, size: _getIconSize());
    final textWidget = Text(text, style: textStyle);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: iconPosition == IconPosition.left
          ? [iconWidget, AppSpacing.horizontalXs, textWidget]
          : [textWidget, AppSpacing.horizontalXs, iconWidget],
    );
  }

  double _getButtonHeight() {
    switch (size) {
      case AppButtonSize.small:
        return AppSpacing.buttonHeightSm;
      case AppButtonSize.medium:
        return AppSpacing.buttonHeightMd;
      case AppButtonSize.large:
        return AppSpacing.buttonHeightLg;
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case AppButtonSize.small:
        return AppTextStyles.buttonSmall;
      case AppButtonSize.medium:
      case AppButtonSize.large:
        return AppTextStyles.button;
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return AppSpacing.iconSm;
      case AppButtonSize.medium:
        return AppSpacing.iconMd;
      case AppButtonSize.large:
        return AppSpacing.iconLg;
    }
  }
}

enum IconPosition { left, right }
