import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../colors/app_colors.dart';
import '../typography/app_text_styles.dart';
import '../spacing/app_spacing.dart';

/// Tema de la aplicación - FioFut
///
/// Configuración completa de ThemeData para modo oscuro.
/// Esta app solo tiene tema oscuro.
abstract final class AppTheme {
  // ============== Dark Theme (Only Theme) ==============
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: _colorScheme,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: _appBarTheme,
        cardTheme: _cardTheme,
        elevatedButtonTheme: _elevatedButtonTheme,
        outlinedButtonTheme: _outlinedButtonTheme,
        textButtonTheme: _textButtonTheme,
        inputDecorationTheme: _inputDecorationTheme,
        floatingActionButtonTheme: _floatingActionButtonTheme,
        bottomNavigationBarTheme: _bottomNavigationBarTheme,
        navigationBarTheme: _navigationBarTheme,
        dividerTheme: _dividerTheme,
        chipTheme: _chipTheme,
        dialogTheme: _dialogTheme,
        bottomSheetTheme: _bottomSheetTheme,
        snackBarTheme: _snackBarTheme,
        textTheme: _textTheme,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        primaryIconTheme: const IconThemeData(color: AppColors.primary),
        fontFamily: AppTextStyles.fontFamily,
      );

  // ============== Color Scheme ==============
  static const ColorScheme _colorScheme = ColorScheme.dark(
    primary: AppColors.primary,
    primaryContainer: AppColors.surfaceAlt,
    secondary: AppColors.secondary,
    secondaryContainer: AppColors.card,
    tertiary: AppColors.teal,
    tertiaryContainer: AppColors.surface,
    surface: AppColors.card,
    error: AppColors.error,
    errorContainer: Color(0xFF93000A),
    onPrimary: AppColors.black,
    onSecondary: AppColors.white,
    onSurface: AppColors.textPrimary,
    onError: AppColors.white,
    outline: AppColors.border,
    shadow: AppColors.shadow,
  );

  // ============== AppBar Theme ==============
  static const AppBarTheme _appBarTheme = AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: true,
    backgroundColor: AppColors.background,
    foregroundColor: AppColors.textPrimary,
    iconTheme: IconThemeData(color: AppColors.textPrimary),
    titleTextStyle: AppTextStyles.titleMedium,
    systemOverlayStyle: SystemUiOverlayStyle.light,
  );

  // ============== Card Theme ==============
  static CardThemeData get _cardTheme => CardThemeData(
        elevation: AppSpacing.elevationNone,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusMd,
        ),
        color: AppColors.card,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
      );

  // ============== Elevated Button Theme ==============
  static ElevatedButtonThemeData get _elevatedButtonTheme =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.black,
          elevation: 0,
          padding: AppSpacing.buttonPadding,
          minimumSize: const Size(double.infinity, AppSpacing.buttonHeightMd),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusSm,
          ),
          textStyle: AppTextStyles.button,
        ),
      );

  // ============== Outlined Button Theme ==============
  static OutlinedButtonThemeData get _outlinedButtonTheme =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          padding: AppSpacing.buttonPadding,
          minimumSize: const Size(double.infinity, AppSpacing.buttonHeightMd),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusSm,
          ),
          textStyle: AppTextStyles.button.copyWith(color: AppColors.primary),
        ),
      );

  // ============== Text Button Theme ==============
  static TextButtonThemeData get _textButtonTheme => TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: AppSpacing.buttonPadding,
          textStyle: AppTextStyles.button.copyWith(color: AppColors.primary),
        ),
      );

  // ============== Input Decoration Theme ==============
  static InputDecorationTheme get _inputDecorationTheme =>
      InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceAlt,
        contentPadding: AppSpacing.inputPadding,
        border: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusSm,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusSm,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusSm,
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusSm,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusSm,
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        hintStyle: AppTextStyles.bodyDefault.copyWith(color: AppColors.textMuted),
        labelStyle: AppTextStyles.bodyDefault.copyWith(color: AppColors.textPrimary),
        errorStyle: AppTextStyles.caption.copyWith(color: AppColors.error),
      );

  // ============== FAB Theme ==============
  static FloatingActionButtonThemeData get _floatingActionButtonTheme =>
      FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.black,
        elevation: AppSpacing.elevationMd,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusMd,
        ),
      );

  // ============== Bottom Navigation Bar Theme ==============
  static BottomNavigationBarThemeData get _bottomNavigationBarTheme =>
      BottomNavigationBarThemeData(
        backgroundColor: AppColors.card,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: AppTextStyles.small.copyWith(color: AppColors.primary),
        unselectedLabelStyle: AppTextStyles.small,
      );

  // ============== Navigation Bar Theme (Material 3) ==============
  static NavigationBarThemeData get _navigationBarTheme =>
      NavigationBarThemeData(
        backgroundColor: AppColors.card,
        indicatorColor: AppColors.primary.withValues(alpha: 0.2),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTextStyles.small.copyWith(color: AppColors.primary);
          }
          return AppTextStyles.small.copyWith(color: AppColors.textSecondary);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary);
          }
          return const IconThemeData(color: AppColors.textSecondary);
        }),
      );

  // ============== Divider Theme ==============
  static const DividerThemeData _dividerTheme = DividerThemeData(
    color: AppColors.divider,
    thickness: 1,
    space: 1,
  );

  // ============== Chip Theme ==============
  static ChipThemeData get _chipTheme => ChipThemeData(
        backgroundColor: AppColors.surfaceAlt,
        selectedColor: AppColors.primary,
        disabledColor: AppColors.surface,
        labelStyle: AppTextStyles.labelMedium.copyWith(color: AppColors.textPrimary),
        padding: AppSpacing.paddingHorizontalSm,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusFull,
        ),
      );

  // ============== Dialog Theme ==============
  static DialogThemeData get _dialogTheme => DialogThemeData(
        backgroundColor: AppColors.card,
        elevation: AppSpacing.elevationLg,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusLg,
        ),
        titleTextStyle: AppTextStyles.h3,
        contentTextStyle: AppTextStyles.bodyDefault.copyWith(color: AppColors.textPrimary),
      );

  // ============== Bottom Sheet Theme ==============
  static BottomSheetThemeData get _bottomSheetTheme => BottomSheetThemeData(
        backgroundColor: AppColors.card,
        elevation: AppSpacing.elevationLg,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusLg),
          ),
        ),
        dragHandleColor: AppColors.surface,
        dragHandleSize: const Size(40, 4),
      );

  // ============== SnackBar Theme ==============
  static SnackBarThemeData get _snackBarTheme => SnackBarThemeData(
        backgroundColor: AppColors.surface,
        contentTextStyle: AppTextStyles.bodyDefault.copyWith(color: AppColors.textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusSm,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: AppSpacing.elevationMd,
      );

  // ============== Text Theme ==============
  static TextTheme get _textTheme => TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        displaySmall: AppTextStyles.displaySmall,
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        headlineSmall: AppTextStyles.headlineSmall,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        titleSmall: AppTextStyles.titleSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyDefault,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      );
}
