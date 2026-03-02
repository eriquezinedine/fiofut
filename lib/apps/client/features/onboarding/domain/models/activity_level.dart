import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Represents the user's current physical activity level.
enum ActivityLevel {
  sedentary,
  lightlyActive,
  moderatelyActive,
  veryActive;

  String get label => switch (this) {
        ActivityLevel.sedentary => 'Sedentario',
        ActivityLevel.lightlyActive => 'Ligeramente activo',
        ActivityLevel.moderatelyActive => 'Moderadamente activo',
        ActivityLevel.veryActive => 'Muy activo',
      };

  String get subtitle => switch (this) {
        ActivityLevel.sedentary =>
          'Paso la mayor parte del día sentado',
        ActivityLevel.lightlyActive =>
          'Ejercicio ligero 1-3 días por semana',
        ActivityLevel.moderatelyActive =>
          'Ejercicio moderado 3-5 días por semana',
        ActivityLevel.veryActive =>
          'Ejercicio intenso 6-7 días por semana',
      };

  Color getColor() => switch (this) {
        ActivityLevel.sedentary => AppColors.red,
        ActivityLevel.lightlyActive => AppColors.orange,
        ActivityLevel.moderatelyActive => AppColors.blue,
        ActivityLevel.veryActive => AppColors.green,
      };

  IconData getIcon() => switch (this) {
        ActivityLevel.sedentary => LucideIcons.sofa,
        ActivityLevel.lightlyActive => LucideIcons.footprints,
        ActivityLevel.moderatelyActive => LucideIcons.bike,
        ActivityLevel.veryActive => LucideIcons.flame,
      };
}
