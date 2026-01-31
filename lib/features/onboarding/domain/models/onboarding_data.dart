import 'package:fio_fut/features/onboarding/domain/models/gender.dart';
import 'package:fio_fut/features/onboarding/domain/models/weight_goal.dart';
import 'package:fio_fut/features/onboarding/domain/models/workout_location.dart';

/// Immutable data model containing all user data collected during onboarding.
///
/// This model uses the copyWith pattern for immutable updates.
class OnboardingData {
  const OnboardingData({
    this.weightGoal,
    this.height,
    this.currentWeight,
    this.workoutLocations = const {},
    this.gender,
    this.birthDate,
    this.referralCode,
    this.injuries,
    this.excludedFoods = const [],
    this.desiredWeight,
    this.useKgUnit = true,
  });

  /// Creates an empty OnboardingData with default values.
  const OnboardingData.empty()
      : weightGoal = null,
        height = null,
        currentWeight = null,
        workoutLocations = const {},
        gender = null,
        birthDate = null,
        referralCode = null,
        injuries = null,
        excludedFoods = const [],
        desiredWeight = null,
        useKgUnit = true;

  /// Step 1: The user's weight goal (lose, maintain, gain)
  final WeightGoal? weightGoal;

  /// Step 2: The user's height in centimeters
  final double? height;

  /// Step 3: The user's current weight in kilograms
  final double? currentWeight;

  /// Step 4: Where the user prefers to workout (can select multiple)
  final Set<WorkoutLocation> workoutLocations;

  /// Step 5: The user's gender
  final Gender? gender;

  /// Step 6: The user's birth date
  final DateTime? birthDate;

  /// Step 8: Optional referral code
  final String? referralCode;

  /// Step 9: Optional description of any injuries
  final String? injuries;

  /// Step 10: List of foods the user wants to exclude from their diet
  final List<String> excludedFoods;

  /// Step 12: The user's desired/target weight in kilograms
  final double? desiredWeight;

  /// Whether the user prefers kilograms (true) or pounds (false) for weight display
  final bool useKgUnit;

  /// Creates a copy of this OnboardingData with the given fields replaced.
  OnboardingData copyWith({
    WeightGoal? weightGoal,
    double? height,
    double? currentWeight,
    Set<WorkoutLocation>? workoutLocations,
    Gender? gender,
    DateTime? birthDate,
    String? referralCode,
    String? injuries,
    List<String>? excludedFoods,
    double? desiredWeight,
    bool? useKgUnit,
    // Use these to explicitly set nullable fields to null
    bool clearReferralCode = false,
    bool clearInjuries = false,
  }) {
    return OnboardingData(
      weightGoal: weightGoal ?? this.weightGoal,
      height: height ?? this.height,
      currentWeight: currentWeight ?? this.currentWeight,
      workoutLocations: workoutLocations ?? this.workoutLocations,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      referralCode:
          clearReferralCode ? null : (referralCode ?? this.referralCode),
      injuries: clearInjuries ? null : (injuries ?? this.injuries),
      excludedFoods: excludedFoods ?? this.excludedFoods,
      desiredWeight: desiredWeight ?? this.desiredWeight,
      useKgUnit: useKgUnit ?? this.useKgUnit,
    );
  }

  /// Calculates the user's age based on their birth date.
  int? get age {
    if (birthDate == null) return null;
    final now = DateTime.now();
    int age = now.year - birthDate!.year;
    if (now.month < birthDate!.month ||
        (now.month == birthDate!.month && now.day < birthDate!.day)) {
      age--;
    }
    return age;
  }

  /// Calculates BMI if height and current weight are available.
  double? get bmi {
    if (height == null || currentWeight == null) return null;
    final heightInMeters = height! / 100;
    return currentWeight! / (heightInMeters * heightInMeters);
  }

  /// Returns true if all required fields are filled.
  bool get isComplete =>
      weightGoal != null &&
      height != null &&
      currentWeight != null &&
      workoutLocations.isNotEmpty &&
      gender != null &&
      birthDate != null &&
      desiredWeight != null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OnboardingData) return false;

    return other.weightGoal == weightGoal &&
        other.height == height &&
        other.currentWeight == currentWeight &&
        _setEquals(other.workoutLocations, workoutLocations) &&
        other.gender == gender &&
        other.birthDate == birthDate &&
        other.referralCode == referralCode &&
        other.injuries == injuries &&
        _listEquals(other.excludedFoods, excludedFoods) &&
        other.desiredWeight == desiredWeight &&
        other.useKgUnit == useKgUnit;
  }

  @override
  int get hashCode => Object.hash(
        weightGoal,
        height,
        currentWeight,
        Object.hashAll(workoutLocations),
        gender,
        birthDate,
        referralCode,
        injuries,
        Object.hashAll(excludedFoods),
        desiredWeight,
        useKgUnit,
      );

  bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  bool _setEquals<T>(Set<T> a, Set<T> b) {
    if (a.length != b.length) return false;
    return a.containsAll(b);
  }

  @override
  String toString() => 'OnboardingData('
      'weightGoal: $weightGoal, '
      'height: $height, '
      'currentWeight: $currentWeight, '
      'workoutLocations: $workoutLocations, '
      'gender: $gender, '
      'birthDate: $birthDate, '
      'referralCode: $referralCode, '
      'injuries: $injuries, '
      'excludedFoods: $excludedFoods, '
      'desiredWeight: $desiredWeight, '
      'useKgUnit: $useKgUnit)';
}
