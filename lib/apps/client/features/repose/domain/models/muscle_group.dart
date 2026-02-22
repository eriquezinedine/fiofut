import 'package:flutter/material.dart';

enum MuscleGroup {
  // Head & Neck
  head('Cabeza', Color(0xFFFFB74D)),
  neck('Cuello', Color(0xFFFF8A65)),

  // Upper Body - Front
  chestLeft('Pecho Izq', Color(0xFFEF5350)),
  chestRight('Pecho Der', Color(0xFFE53935)),
  shoulderLeft('Hombro Izq', Color(0xFF42A5F5)),
  shoulderRight('Hombro Der', Color(0xFF1E88E5)),
  bicepLeft('Biceps Izq', Color(0xFF66BB6A)),
  bicepRight('Biceps Der', Color(0xFF43A047)),
  forearmLeft('Antebrazo Izq', Color(0xFF26A69A)),
  forearmRight('Antebrazo Der', Color(0xFF00897B)),

  // Core
  abs('Abdominales', Color(0xFFAB47BC)),
  obliqueLeft('Oblicuo Izq', Color(0xFFEC407A)),
  obliqueRight('Oblicuo Der', Color(0xFFD81B60)),

  // Lower Body - Front
  quadLeft('Cuadriceps Izq', Color(0xFFFFA726)),
  quadRight('Cuadriceps Der', Color(0xFFF57C00)),
  calfLeft('Gemelo Izq', Color(0xFF8D6E63)),
  calfRight('Gemelo Der', Color(0xFF6D4C41)),

  // Upper Body - Back
  upperBack('Espalda Alta', Color(0xFF5C6BC0)),
  lowerBack('Espalda Baja', Color(0xFF7E57C2)),
  tricepLeft('Triceps Izq', Color(0xFF29B6F6)),
  tricepRight('Triceps Der', Color(0xFF0288D1)),

  // Lower Body - Back
  gluteLeft('Gluteo Izq', Color(0xFFFF7043)),
  gluteRight('Gluteo Der', Color(0xFFF4511E)),
  hamstringLeft('Isquiotibial Izq', Color(0xFFFFCA28)),
  hamstringRight('Isquiotibial Der', Color(0xFFFBC02D));

  const MuscleGroup(this.label, this.defaultColor);

  final String label;
  final Color defaultColor;

  static List<MuscleGroup> get frontMuscles => [
        head, neck,
        shoulderLeft, shoulderRight,
        chestLeft, chestRight,
        bicepLeft, bicepRight,
        forearmLeft, forearmRight,
        abs, obliqueLeft, obliqueRight,
        quadLeft, quadRight,
        calfLeft, calfRight,
      ];

  static List<MuscleGroup> get backMuscles => [
        head, neck,
        shoulderLeft, shoulderRight,
        upperBack, lowerBack,
        tricepLeft, tricepRight,
        forearmLeft, forearmRight,
        gluteLeft, gluteRight,
        hamstringLeft, hamstringRight,
        calfLeft, calfRight,
      ];
}
