import 'dart:ui';

import 'package:app_ui/app_ui.dart';
import 'package:model/model.dart';

class MuscleRepose {
  final Muscle muscle;
  final int percentage;

  const MuscleRepose({
    required this.muscle,
    required this.percentage,
  });

  Color get percentageColor {
    if (percentage <= 33) return AppColors.error;
    if (percentage <= 66) return AppColors.warning;
    return AppColors.success;
  }

  static List<MuscleRepose> data = [
    MuscleRepose(
      muscle: const Muscle(
        id: '1',
        name: 'Back',
        isMain: true,
        muscleGroup: MuscleGroup.back,
      ),
      percentage: 7,
    ),
    MuscleRepose(
      muscle: const Muscle(
        id: '2',
        name: 'Triceps',
        isMain: true,
        muscleGroup: MuscleGroup.triceps,
      ),
      percentage: 100,
    ),
    MuscleRepose(
      muscle: const Muscle(
        id: '3',
        name: 'Quadriceps',
        isMain: true,
        muscleGroup: MuscleGroup.quadriceps,
      ),
      percentage: 40,
    ),
  ];

  factory MuscleRepose.fromJson(Map<String, dynamic> json) {
    return MuscleRepose(
      muscle: Muscle.fromJson(json['muscle'] as Map<String, dynamic>),
      percentage: json['percentage'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'muscle': muscle.toJson(),
      'percentage': percentage,
    };
  }

  MuscleRepose copyWith({
    Muscle? muscle,
    int? percentage,
  }) {
    return MuscleRepose(
      muscle: muscle ?? this.muscle,
      percentage: percentage ?? this.percentage,
    );
  }
}
