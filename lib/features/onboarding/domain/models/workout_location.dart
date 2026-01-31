/// Represents where the user prefers to workout.
enum WorkoutLocation {
  /// User prefers to workout at home
  home,

  /// User prefers to workout at a gym
  gym,

  /// User is flexible and can workout at both locations
  both;

  /// Returns a human-readable label for the workout location.
  String get label => switch (this) {
        WorkoutLocation.home => 'At Home',
        WorkoutLocation.gym => 'At Gym',
        WorkoutLocation.both => 'Both',
      };
}
