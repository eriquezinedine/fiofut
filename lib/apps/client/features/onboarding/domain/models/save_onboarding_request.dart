import 'package:model/model.dart';

import 'activity_level.dart';
import 'gender.dart';
import 'onboarding_data.dart';
import 'referral_source.dart';
import 'training_duration.dart';
import 'weight_goal.dart';
import 'workout_location.dart';

/// Request class that maps [OnboardingData] to the Supabase `profiles` table.
class SaveOnboardingRequest {
  const SaveOnboardingRequest({
    required this.userId,
    required this.weightGoal,
    required this.heightCm,
    required this.currentWeight,
    required this.desiredWeight,
    required this.gender,
    required this.birthDate,
    required this.workoutLocations,
    this.referralCode,
    this.injuries,
    this.excludedFoods = const [],
    this.useKgUnit = true,
    this.activityLevel,
    this.trainingDuration,
    this.trainingDays,
    this.referralSource,
    this.selectedMuscles = const [],
  });

  /// Creates a request from [OnboardingData].
  /// Returns null if required fields are missing.
  static SaveOnboardingRequest? fromData({
    required String userId,
    required OnboardingData data,
    List<MuscleGroup> selectedMuscles = const [],
  }) {
    if (data.weightGoal == null ||
        data.height == null ||
        data.currentWeight == null ||
        data.desiredWeight == null ||
        data.gender == null ||
        data.birthDate == null) {
      return null;
    }

    return SaveOnboardingRequest(
      userId: userId,
      weightGoal: data.weightGoal!,
      heightCm: data.height!,
      currentWeight: data.currentWeight!,
      desiredWeight: data.desiredWeight!,
      gender: data.gender!,
      birthDate: data.birthDate!,
      workoutLocations: data.workoutLocations.toList(),
      referralCode: data.referralCode,
      injuries: data.injuries,
      excludedFoods: data.excludedFoods,
      useKgUnit: data.useKgUnit,
      activityLevel: data.activityLevel,
      trainingDuration: data.trainingDuration,
      trainingDays: data.trainingDays,
      referralSource: data.referralSource,
      selectedMuscles: selectedMuscles,
    );
  }

  final String userId;
  final WeightGoal weightGoal;
  final double heightCm;
  final double currentWeight;
  final double desiredWeight;
  final Gender gender;
  final DateTime birthDate;
  final List<WorkoutLocation> workoutLocations;
  final String? referralCode;
  final String? injuries;
  final List<String> excludedFoods;
  final bool useKgUnit;
  final ActivityLevel? activityLevel;
  final TrainingDuration? trainingDuration;
  final int? trainingDays;
  final ReferralSource? referralSource;
  final List<MuscleGroup> selectedMuscles;

  /// Converts to JSON map matching the `profiles` table columns.
  Map<String, dynamic> toJson() {
    return {
      'weight_goal': weightGoal.name,
      'height_cm': heightCm,
      'current_weight': currentWeight,
      'desired_weight': desiredWeight,
      'gender': gender.name,
      'birth_date': birthDate.toIso8601String().split('T').first,
      'workout_locations': workoutLocations.map((e) => e.name).toList(),
      'referral_code': referralCode,
      'injuries': injuries,
      'excluded_foods': excludedFoods,
      'use_kg_unit': useKgUnit,
      'activity_level': activityLevel?.name,
      'training_duration': trainingDuration?.name,
      'training_days': trainingDays,
      'referral_source': referralSource?.name,
      'selected_muscles': selectedMuscles.map((e) => e.name).toList(),
      'is_profile_complete': true,
    };
  }
}
