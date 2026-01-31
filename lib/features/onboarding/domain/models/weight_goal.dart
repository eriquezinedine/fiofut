import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// Represents the user's weight goal for the fitness program.
enum WeightGoal {
  /// User wants to lose weight
  lose,

  /// User wants to maintain current weight
  maintain,

  /// User wants to gain weight/muscle
  gain;

  /// Returns a human-readable label for the weight goal.
  String get label => switch (this) {
        WeightGoal.lose => 'Lose Weight',
        WeightGoal.maintain => 'Maintain Weight',
        WeightGoal.gain => 'Gain Weight',
      };
}

extension WeightGoalX on WeightGoal {
  Color getColor(){
      return switch (this) {
        WeightGoal.lose => AppColors.red,
        WeightGoal.gain => AppColors.green,
        WeightGoal.maintain => AppColors.blue,
      };
  }
}