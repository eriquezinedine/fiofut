import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// Widget de mensaje de error con opción de cerrar.
/// Muestra un mensaje de error con icono y botón para dismissar.
class ErrorMessageBox extends StatelessWidget {
  const ErrorMessageBox({
    super.key,
    required this.message,
    this.onDismiss,
    this.margin,
  });

  /// Mensaje de error a mostrar
  final String message;

  /// Callback cuando se cierra el mensaje (opcional)
  final VoidCallback? onDismiss;

  /// Margen del contenedor
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.paddingAllSm,
      margin: margin ?? const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: AppSpacing.iconSm,
          ),
          AppSpacing.horizontalSm,
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
          if (onDismiss != null)
            GestureDetector(
              onTap: onDismiss,
              child: const Icon(
                Icons.close,
                color: AppColors.error,
                size: 18,
              ),
            ),
        ],
      ),
    );
  }
}
