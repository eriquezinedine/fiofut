import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// Widget de label para campos de formulario.
/// Muestra un label alineado a la izquierda con estilo consistente.
class FieldLabel extends StatelessWidget {
  const FieldLabel({
    super.key,
    required this.text,
    this.padding,
    this.style,
  });

  /// Texto del label
  final String text;

  /// Padding del contenedor (default: bottom xs)
  final EdgeInsetsGeometry? padding;

  /// Estilo del texto (opcional)
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: padding ?? const EdgeInsets.only(bottom: AppSpacing.xs),
        child: Text(
          text,
          style: style ??
              AppTextStyles.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ),
    );
  }
}
