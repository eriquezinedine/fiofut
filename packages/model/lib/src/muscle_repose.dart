import 'package:model/model.dart';

class MuscleRepose {
  final Muscle muscle;
  final int percentage;

  const MuscleRepose({
    required this.muscle,
    required this.percentage,
  });

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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MuscleRepose &&
          muscle == other.muscle &&
          percentage == other.percentage;

  @override
  int get hashCode => Object.hash(muscle, percentage);
}
