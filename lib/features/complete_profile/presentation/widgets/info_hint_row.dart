import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Widget de texto informativo con icono de información.
/// Usado para mostrar hints o instrucciones al usuario.
class InfoHintRow extends StatelessWidget {
  const InfoHintRow({
    super.key,
    required this.text,
    this.icon = LucideIcons.info,
    this.iconSize = 14,
    this.color,
    this.alignment = Alignment.centerLeft,
  });

  /// Texto a mostrar
  final String text;

  /// Icono a mostrar (default: LucideIcons.info)
  final IconData icon;

  /// Tamaño del icono (default: 14)
  final double iconSize;

  /// Color del icono y texto (default: AppColors.textMuted)
  final Color? color;

  /// Alineación del widget (default: Alignment.centerLeft)
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.textMuted;

    return Align(
      alignment: alignment,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: effectiveColor,
          ),
          AppSpacing.horizontalXxs,
          Flexible(
            child: Text(
              text,
              style: AppTextStyles.small.copyWith(
                color: effectiveColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
