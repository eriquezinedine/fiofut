import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Represents the user's preferred daily training duration.
enum TrainingDuration {
  thirty,
  fortyFive,
  sixty,
  ninety;

  String get label => switch (this) {
        TrainingDuration.thirty => '30 min',
        TrainingDuration.fortyFive => '45 min',
        TrainingDuration.sixty => '60 min',
        TrainingDuration.ninety => '90+ min',
      };

  String get subtitle => switch (this) {
        TrainingDuration.thirty =>
          'Ideal para principiantes o días ocupados',
        TrainingDuration.fortyFive =>
          'Sesión equilibrada y efectiva',
        TrainingDuration.sixty =>
          'Entrenamiento completo y detallado',
        TrainingDuration.ninety =>
          'Para los más dedicados y avanzados',
      };

  Color getColor() => switch (this) {
        TrainingDuration.thirty => AppColors.green,
        TrainingDuration.fortyFive => AppColors.blue,
        TrainingDuration.sixty => AppColors.purple,
        TrainingDuration.ninety => AppColors.red,
      };

  IconData getIcon() => switch (this) {
        TrainingDuration.thirty => LucideIcons.clock3,
        TrainingDuration.fortyFive => LucideIcons.timer,
        TrainingDuration.sixty => LucideIcons.hourglass,
        TrainingDuration.ninety => LucideIcons.zap,
      };
}
