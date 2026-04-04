import 'dart:ui';

extension ColorOpacityExtension on Color {
  /// Retorna el color con la opacidad indicada (0.0 a 1.0).
  ///
  /// Uso: `AppColors.backgroundSecondary.o(0.6)`
  Color o(double value) => Color.fromARGB(
        (value.clamp(0.0, 1.0) * 255).round(),
        (r * 255.0).round() & 0xff,
        (g * 255.0).round() & 0xff,
        (b * 255.0).round() & 0xff,
      );
}
