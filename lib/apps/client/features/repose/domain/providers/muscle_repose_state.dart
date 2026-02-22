part of 'muscle_repose_provider.dart';

/// State for a single muscle group's repose progress.
@immutable
class MuscleReposeState {
  const MuscleReposeState({
    required this.muscle,
    required this.progress,
    required this.totalMinutes,
    this.sliderEnabled = true,
  });

  final MuscleGroup muscle;

  /// Progress from 0.0 to 1.0.
  final double progress;

  /// Total rest time in minutes for this muscle.
  final int totalMinutes;

  /// When false the knob is hidden and the bar is not interactive.
  final bool sliderEnabled;

  /// Red (0-10%), Orange (11-99%), Green (100%).
  Color get progressColor {
    if (progress <= 0.10) return AppColors.error;
    if (progress >= 1.0) return AppColors.primary;
    return AppColors.orange;
  }

  int get remainingMinutes => ((1.0 - progress) * totalMinutes).round();

  String get remainingText {
    final totalHours = totalMinutes ~/ 60;
    final totalMins = totalMinutes % 60;

    if (progress >= 1.0) {
      if (totalHours > 0 && totalMins > 0) {
        return '${totalHours}h ${totalMins}m totales';
      }
      if (totalHours > 0) return '${totalHours}h totales';
      return '${totalMins}m totales';
    }

    final remHours = remainingMinutes ~/ 60;
    final remMins = remainingMinutes % 60;
    if (remHours > 0 && remMins > 0) return '${remHours}h ${remMins}m restantes';
    if (remHours > 0) return '${remHours}h restantes';
    return '${remMins}m restantes';
  }

  String get progressText => '${(progress * 100).round()}%';

  MuscleReposeState copyWith({
    MuscleGroup? muscle,
    double? progress,
    int? totalMinutes,
    bool? sliderEnabled,
  }) {
    return MuscleReposeState(
      muscle: muscle ?? this.muscle,
      progress: progress ?? this.progress,
      totalMinutes: totalMinutes ?? this.totalMinutes,
      sliderEnabled: sliderEnabled ?? this.sliderEnabled,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MuscleReposeState) return false;
    return other.muscle == muscle &&
        other.progress == progress &&
        other.totalMinutes == totalMinutes &&
        other.sliderEnabled == sliderEnabled;
  }

  @override
  int get hashCode => Object.hash(muscle, progress, totalMinutes, sliderEnabled);
}
