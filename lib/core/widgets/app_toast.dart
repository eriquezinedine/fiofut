import 'dart:ui';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:zentoast/zentoast.dart';

/// Reusable blur toast used across the app.
class AppToast {
  const AppToast._();

  static void error(BuildContext context, String message) {
    _show(
      context,
      message: message,
      color: AppColors.error,
      icon: Icons.warning_amber_rounded,
      category: ToastCategory.error,
    );
  }

  static void success(BuildContext context, String message) {
    _show(
      context,
      message: message,
      color: AppColors.primary,
      icon: Icons.check_circle_rounded,
      category: ToastCategory.success,
    );
  }

  static void _show(
    BuildContext context, {
    required String message,
    required Color color,
    required IconData icon,
    required ToastCategory category,
  }) {
    Toast(
      height: 40,
      category: category,
      builder: (toast) => Material(
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: color, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    message,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).show(context);
  }
}
