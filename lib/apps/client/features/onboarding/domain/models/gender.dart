import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// Represents the user's gender for personalized fitness recommendations.
enum Gender {
  /// Male
  male,

  /// Female
  female,

  /// Other/Non-binary
  other;

  /// Returns a human-readable label for the gender.
  String get label => switch (this) {
        Gender.male => 'Male',
        Gender.female => 'Female',
        Gender.other => 'Other',
      };

  /// Returns the color associated with this gender.
  Color getColor() => switch (this) {
        Gender.male => AppColors.blue,
        Gender.female => AppColors.pink,
        Gender.other => AppColors.green,
      };
}
