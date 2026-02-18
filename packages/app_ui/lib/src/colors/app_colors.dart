import 'package:flutter/material.dart';

/// Colores de la aplicacion - FioFut (Dark Theme)
///
/// Paleta de colores basada en el Style Guide - FioFut
/// Aplicacion de fitness y nutricion con tema oscuro
abstract final class AppColors {
  // ============================================================
  // BASE COLORS - Valores fijos de la paleta
  // ============================================================

  /// Lima / Neon
  static const Color lime = Color(0xFFCDFF00);

  /// Rojo Principal
  static const Color red = Color(0xFFE53935);
  /// Rojo Principal
  static const Color favorite = Color(0xFFFE6A6B);

  /// Rojo Brillante
  static const Color redBright = Color(0xFFEF4444);

  /// Rojo Coral
  static const Color redCoral = Color(0xFFFF6B6B);

  /// Azul
  static const Color blue = Color(0xFF3B82F6);

  /// Verde
  static const Color green = Color(0xFF22C55E);

  /// Purpura
  static const Color purple = Color(0xFF8B5CF6);

  /// Naranja
  static const Color orange = Color(0xFFF59E0B);

  /// Rosa
  static const Color pink = Color(0xFFEC4899);

  /// Teal
  static const Color teal = Color(0xFF14B8A6);

  // ============================================================
  // SEMANTIC COLORS - Colores con proposito especifico
  // (Cambiar aqui para actualizar toda la app)
  // ============================================================

  // ---------- Brand ----------
  /// Color primario de la marca
  static const Color primary = green;

  /// Color secundario de la marca
  static const Color secondary = red;

  // ---------- Backgrounds ----------
  /// Background principal de la app
  static const Color background = Color(0xFF0A0A0A);

  /// Background secundario
  static const Color backgroundSecondary = Color(0xFF1A1A1A);

  /// Color de las cards
  static const Color card = Color(0xFF1A1A1A);

  /// Surface principal
  static const Color surface = Color(0xFF333333);

  /// Surface alternativo
  static const Color surfaceAlt = Color(0xFF2A2A2A);

  // ---------- Text ----------
  /// Texto de titulos (blanco)
  static const Color titleColor = Color(0xFFFFFFFF);

  /// Texto principal del body
  static const Color textPrimary = Color(0xFFFFFFFF);

  /// Texto secundario
  static const Color textSecondary = Color(0xFF9CA3AF);

  /// Texto muted/hint
  static const Color textMuted = Color(0xFF6B7280);

  static const Color textDescription = Color(0xff9da2ae);

  /// Texto dimmed (mas oscuro que muted)
  static const Color textDimmed = Color(0xFF4B5563);

  // ---------- Status ----------
  /// Success/Exito
  static const Color success = green;

  /// Error
  static const Color error = redBright;

  /// Warning/Advertencia
  static const Color warning = orange;

  /// Info
  static const Color info = blue;

  // ---------- Roles ----------
  /// Usuario
  static const Color roleUser = red;

  /// Entrenador
  static const Color roleTrainer = blue;

  /// Admin
  static const Color roleAdmin = purple;

  // ============================================================
  // GREY SCALE
  // ============================================================

  /// Gris alternativo
  static const Color greyAlt = Color(0xFF71717A);

  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // ============================================================
  // BORDER & DIVIDER
  // ============================================================

  /// Color de bordes
  static const Color border = Color(0xFF333333);

  /// Color de dividers
  static const Color divider = Color(0xFF333333);

  // ============================================================
  // SHADOW & OVERLAY
  // ============================================================

  static const Color shadow = Color(0x40000000);
  static const Color overlay = Color(0x80000000);

  // ============================================================
  // HELPERS
  // ============================================================

  static const Color transparent = Colors.transparent;
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // ============================================================
  // GRADIENTS
  // ============================================================

  /// Primary Gradient (Lima neon)
  static const List<Color> primaryGradient = [
    Color(0xFFCDFF00),
    Color(0xFFA8D600),
  ];

  /// Secondary Gradient (Rojo)
  static const List<Color> secondaryGradient = [
    Color(0xFFE53935),
    Color(0xFFB71C1C),
  ];

  /// Success Gradient
  static const List<Color> successGradient = [
    Color(0xFF22C55E),
    Color(0xFF16A34A),
  ];

  /// Blue Gradient
  static const List<Color> blueGradient = [
    Color(0xFF3B82F6),
    Color(0xFF2563EB),
  ];

  /// Blue Gradient
  static const List<Color> blackGradient = [
    Color(0xFF000000),
    Color(0xFF2563EB),
  ];
}
