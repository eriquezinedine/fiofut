import 'package:flutter/material.dart';
import '../colors/app_colors.dart';

/// Estilos de texto de la aplicación - FioFut
///
/// Tipografía basada en el Style Guide:
/// - Inter: Fuente principal para toda la aplicación
abstract final class AppTextStyles {
  // Font family
  static const String fontFamily = 'Inter';

  // ============== Display Styles ==============

  /// Display XL - Inter Bold 80px (for large number displays like weight/height)
  static const TextStyle displayXL = TextStyle(
    fontFamily: fontFamily,
    fontSize: 80,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.0,
  );

  // ============== Heading Styles ==============

  /// Heading 1 - Inter Bold 48px
  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  /// Heading 2 - Inter Bold 28px
  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.29,
  );

  /// Heading 3 - Inter SemiBold 20px
  static const TextStyle h3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // ============== Body Styles ==============

  /// Body - Inter Regular 16px
  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  /// Body Medium - Inter Medium 16px
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  /// Caption - Inter Regular 14px
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.43,
  );

  /// Small - Inter Medium 12px
  static const TextStyle small = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textMuted,
    height: 1.33,
  );

  // ============== Material Design Mapping ==============

  /// Display Large (mapped to h1)
  static const TextStyle displayLarge = h1;

  /// Display Medium (mapped to h2)
  static const TextStyle displayMedium = h2;

  /// Display Small (mapped to h3)
  static const TextStyle displaySmall = h3;

  /// Headline Large (mapped to h1)
  static const TextStyle headlineLarge = h1;

  /// Headline Medium (mapped to h2)
  static const TextStyle headlineMedium = h2;

  /// Headline Small (mapped to h3)
  static const TextStyle headlineSmall = h3;

  /// Title Large - Inter SemiBold 22px
  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.27,
  );

  /// Title Medium - Inter SemiBold 18px
  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.33,
  );

  /// Title Small - Inter SemiBold 14px
  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.43,
  );

  /// Body Large (mapped to body)
  static const TextStyle bodyLarge = body;

  /// Body Default - Inter Regular 14px
  static const TextStyle bodyDefault = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.43,
  );

  /// Body Small (mapped to caption)
  static const TextStyle bodySmall = caption;

  /// Label Large - Inter Medium 14px
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.43,
  );

  /// Label Medium - Inter Medium 12px
  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.33,
  );

  /// Label Small - Inter Medium 11px
  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.45,
  );

  // ============== Input Styles ==============

  /// Input - Inter Regular 15px (for text fields)
  static const TextStyle input = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  /// Input Hint - Inter Regular 15px (for placeholders)
  static const TextStyle inputHint = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.4,
  );

  // ============== Button Styles ==============

  /// Button - Inter SemiBold 16px
  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
    height: 1.5,
  );

  /// Button Small - Inter SemiBold 14px
  static const TextStyle buttonSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
    height: 1.43,
  );

  // ============== Overline ==============
  static const TextStyle overline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
    color: AppColors.textSecondary,
    height: 1.6,
  );
}
