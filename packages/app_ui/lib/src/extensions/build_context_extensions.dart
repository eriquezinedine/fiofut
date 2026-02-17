import 'package:flutter/material.dart';
import '../colors/app_colors.dart';

extension BuildContextExtensions on BuildContext {
  // ============== Theme ==============
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
  bool get isDarkMode => theme.brightness == Brightness.dark;

  // ============== Media Query ==============
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  EdgeInsets get padding => mediaQuery.padding;
  EdgeInsets get viewInsets => mediaQuery.viewInsets;
  double get topPadding => padding.top;
  double get bottomPadding => padding.bottom;
  bool get isKeyboardOpen => viewInsets.bottom > 0;

  // ============== Responsive Breakpoints ==============
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;
  bool get isDesktop => screenWidth >= 1200;

  // ============== Navigation ==============
  NavigatorState get navigator => Navigator.of(this);

  // void pop<T>([T? result]) => navigator.pop(result);

  Future<T?> push<T>(Widget page) => navigator.push<T>(
        MaterialPageRoute(builder: (_) => page),
      );

  Future<T?> pushReplacement<T>(Widget page) => navigator.pushReplacement<T, T>(
        MaterialPageRoute(builder: (_) => page),
      );

  Future<T?> pushAndRemoveUntil<T>(Widget page, {bool Function(Route<dynamic>)? predicate}) =>
      navigator.pushAndRemoveUntil<T>(
        MaterialPageRoute(builder: (_) => page),
        predicate ?? (route) => false,
      );

  // ============== Snackbar ==============
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    Color? backgroundColor,
  }) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
        backgroundColor: backgroundColor,
      ),
    );
  }

  void showSuccessSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: AppColors.success,
    );
  }

  void showErrorSnackBar(String message, {VoidCallback? onRetry}) {
    showSnackBar(
      message,
      backgroundColor: AppColors.error,
      action: onRetry != null
          ? SnackBarAction(
              label: 'Reintentar',
              textColor: AppColors.error,
              onPressed: onRetry,
            )
          : null,
    );
  }

  // ============== Dialog ==============
  Future<T?> showAppDialog<T>({
    required Widget child,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: this,
      barrierDismissible: barrierDismissible,
      builder: (_) => child,
    );
  }

  // Future<bool?> showConfirmDialog({
  //   required String title,
  //   required String message,
  //   String confirmText = 'Confirmar',
  //   String cancelText = 'Cancelar',
  //   bool isDangerous = false,
  // }) {
  //   return showAppDialog<bool>(
  //     child: AlertDialog(
  //       title: Text(title),
  //       content: Text(message),
  //       actions: [
  //         TextButton(
  //           onPressed: () => pop(false),
  //           child: Text(cancelText),
  //         ),
  //         TextButton(
  //           onPressed: () => pop(true),
  //           style: isDangerous
  //               ? TextButton.styleFrom(foregroundColor: AppColors.error)
  //               : null,
  //           child: Text(confirmText),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // ============== Bottom Sheet ==============
  Future<T?> showAppBottomSheet<T>({
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    bool isScrollControlled = false,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: isScrollControlled,
      builder: (_) => child,
    );
  }

  // ============== Focus ==============
  void unfocus() => FocusScope.of(this).unfocus();
  void requestFocus(FocusNode node) => FocusScope.of(this).requestFocus(node);
}
