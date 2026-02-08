import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// Widget de icono con fondo decorativo.
/// Usado para mostrar iconos destacados en pantallas.
class IconBox extends StatelessWidget {
  const IconBox({
    super.key,
    required this.icon,
    this.size = 100,
    this.iconSize = 52,
    this.backgroundColor,
    this.iconColor,
    this.borderRadius = 28,
  });

  /// Icono a mostrar
  final IconData icon;

  /// Tamaño del contenedor (default: 100)
  final double size;

  /// Tamaño del icono (default: 52)
  final double iconSize;

  /// Color de fondo (default: AppColors.primary con 15% opacidad)
  final Color? backgroundColor;

  /// Color del icono (default: AppColors.primary)
  final Color? iconColor;

  /// Radio del borde (default: 28)
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(
        child: Icon(
          icon,
          size: iconSize,
          color: iconColor ?? AppColors.primary,
        ),
      ),
    );
  }
}
