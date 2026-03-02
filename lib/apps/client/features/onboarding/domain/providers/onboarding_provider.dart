import 'package:fio_fut/apps/client/features/onboarding/domain/models/models.dart';
import 'package:fio_fut/core/providers/auth_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'onboarding_state.dart';

/// Provider for the onboarding wizard state.
final onboardingProvider =
    NotifierProvider<OnboardingNotifier, OnboardingState>(
  OnboardingNotifier.new,
);

/// Notifier that manages the onboarding wizard state and transitions.
class OnboardingNotifier extends Notifier<OnboardingState> {
  @override
  OnboardingState build() {
    return const OnboardingInitial();
  }

  /// Starts the onboarding process from the first step.
  void startOnboarding() {
    state = OnboardingInProgress(
      currentStep: OnboardingStep.referralSource,
      data: const OnboardingData.empty(),
    );
    _saveStep(OnboardingStep.referralSource);
  }

  /// Starts the onboarding from a specific step (for resume).
  void startFromStep(int stepNumber) {
    final step = OnboardingStep.values.firstWhere(
      (s) => s.stepNumber == stepNumber,
      orElse: () => OnboardingStep.referralSource,
    );
    state = OnboardingInProgress(
      currentStep: step,
      data: const OnboardingData.empty(),
    );
  }

  /// Advances to the next step in the wizard.
  ///
  /// Returns true if successfully moved to next step, false if already at last step.
  /// When the goal is "maintain", skips the desiredWeight step and sets
  /// desiredWeight equal to currentWeight.
  bool nextStep() {
    return switch (state) {
      OnboardingInProgress(:final currentStep, :final data) => () {
          var next = currentStep.next;
          var updatedData = data;

          // Skip desiredWeight when goal is maintain
          if (currentStep == OnboardingStep.weightGoal &&
              data.weightGoal == WeightGoal.maintain) {
            updatedData = data.copyWith(desiredWeight: data.currentWeight);
            next = OnboardingStep.motivational;
          }

          if (next != null) {
            state = OnboardingInProgress(
              currentStep: next,
              data: updatedData,
            );
            _saveStep(next);
            return true;
          }
          return false;
        }(),
      _ => false,
    };
  }

  /// Goes back to the previous step in the wizard.
  ///
  /// Returns true if successfully moved to previous step, false if already at first step.
  /// When the goal is "maintain", skips back over the desiredWeight step.
  bool previousStep() {
    return switch (state) {
      OnboardingInProgress(:final currentStep, :final data) => () {
          var prev = currentStep.previous;

          // Skip desiredWeight going back when goal is maintain
          if (currentStep == OnboardingStep.motivational &&
              data.weightGoal == WeightGoal.maintain) {
            prev = OnboardingStep.weightGoal;
          }

          if (prev != null) {
            state = OnboardingInProgress(
              currentStep: prev,
              data: data,
            );
            _saveStep(prev);
            return true;
          }
          return false;
        }(),
      _ => false,
    };
  }

  /// Jumps to a specific step in the wizard.
  void goToStep(OnboardingStep step) {
    switch (state) {
      case OnboardingInProgress(:final data):
        state = OnboardingInProgress(
          currentStep: step,
          data: data,
        );
      case OnboardingInitial():
        state = OnboardingInProgress(
          currentStep: step,
          data: const OnboardingData.empty(),
        );
      default:
        break;
    }
    _saveStep(step);
  }

  /// Updates the weight goal selection.
  void updateWeightGoal(WeightGoal weightGoal) {
    _updateData((data) => data.copyWith(weightGoal: weightGoal));
  }

  /// Updates the user's height in centimeters.
  void updateHeight(double height) {
    _updateData((data) => data.copyWith(height: height));
  }

  /// Updates the user's current weight in kilograms.
  void updateCurrentWeight(double currentWeight) {
    _updateData((data) => data.copyWith(currentWeight: currentWeight));
  }

  /// Updates the weight unit preference (kg or lb).
  void updateWeightUnit(bool useKgUnit) {
    _updateData((data) => data.copyWith(useKgUnit: useKgUnit));
  }

  /// Updates the workout location selection.
  void updateWorkoutLocation(WorkoutLocation location) {
    _updateData((data) => data.copyWith(workoutLocation: location));
  }

  /// Updates the user's gender.
  void updateGender(Gender gender) {
    _updateData((data) => data.copyWith(gender: gender));
  }

  /// Updates the user's birth date.
  void updateBirthDate(DateTime birthDate) {
    _updateData((data) => data.copyWith(birthDate: birthDate));
  }

  /// Updates the optional referral code.
  ///
  /// Pass null to clear the referral code.
  void updateReferralCode(String? referralCode) {
    _updateData((data) => data.copyWith(
          referralCode: referralCode,
          clearReferralCode: referralCode == null,
        ));
  }

  /// Updates the optional injuries description.
  ///
  /// Pass null to clear the injuries field.
  void updateInjuries(String? injuries) {
    _updateData((data) => data.copyWith(
          injuries: injuries,
          clearInjuries: injuries == null,
        ));
  }

  /// Adds a food to the excluded foods list.
  void addExcludedFood(String food) {
    switch (state) {
      case OnboardingInProgress(:final currentStep, :final data):
        if (!data.excludedFoods.contains(food)) {
          state = OnboardingInProgress(
            currentStep: currentStep,
            data: data.copyWith(
              excludedFoods: [...data.excludedFoods, food],
            ),
          );
        }
      default:
        break;
    }
  }

  /// Removes a food from the excluded foods list.
  void removeExcludedFood(String food) {
    switch (state) {
      case OnboardingInProgress(:final currentStep, :final data):
        state = OnboardingInProgress(
          currentStep: currentStep,
          data: data.copyWith(
            excludedFoods:
                data.excludedFoods.where((f) => f != food).toList(),
          ),
        );
      default:
        break;
    }
  }

  /// Clears all excluded foods.
  void clearExcludedFoods() {
    _updateData((data) => data.copyWith(excludedFoods: []));
  }

  /// Updates the user's desired/target weight in kilograms.
  void updateDesiredWeight(double desiredWeight) {
    _updateData((data) => data.copyWith(desiredWeight: desiredWeight));
  }

  /// Updates the user's activity level.
  void updateActivityLevel(ActivityLevel activityLevel) {
    _updateData((data) => data.copyWith(activityLevel: activityLevel));
  }

  /// Updates the user's preferred training duration.
  void updateTrainingDuration(TrainingDuration trainingDuration) {
    _updateData((data) => data.copyWith(trainingDuration: trainingDuration));
  }

  /// Updates how many days per week the user wants to train.
  void updateTrainingDays(int days) {
    _updateData((data) => data.copyWith(trainingDays: days));
  }

  /// Updates how the user found the app.
  void updateReferralSource(ReferralSource referralSource) {
    _updateData((data) => data.copyWith(referralSource: referralSource));
  }

  /// Completes the onboarding process and saves data to Supabase.
  ///
  /// Returns true if onboarding was completed successfully,
  /// false if data is incomplete.
  Future<bool> completeOnboarding() async {
    return switch (state) {
      OnboardingInProgress(:final data) => () async {
          final userId = Supabase.instance.client.auth.currentUser?.id;
          if (userId == null) {
            debugPrint('[Onboarding] userId es null');
            return false;
          }

          final request = SaveOnboardingRequest.fromData(
            userId: userId,
            data: data,
          );

          if (request == null) {
            debugPrint('[Onboarding] Data incompleta');
            return false;
          }

          try {
            await ref.read(authRepositoryProvider).saveOnboardingData(
                  userId: userId,
                  data: request.toJson(),
                );
            return true;
          } catch (e, st) {
            debugPrint('[Onboarding] Error al guardar: $e');
            debugPrint('[Onboarding] StackTrace: $st');
            return false;
          }
        }(),
      _ => () {
          debugPrint('[Onboarding] Estado no es InProgress: $state');
          return Future.value(false);
        }(),
    };
  }

  /// Marks the onboarding as failed with an error message.
  void setError(String message) {
    state = OnboardingError(message: message);
  }

  /// Resets the onboarding to the initial state.
  void reset() {
    state = const OnboardingInitial();
  }

  /// Helper method to update data within the InProgress state.
  void _updateData(OnboardingData Function(OnboardingData data) updater) {
    switch (state) {
      case OnboardingInProgress(:final currentStep, :final data):
        state = OnboardingInProgress(
          currentStep: currentStep,
          data: updater(data),
        );
      default:
        break;
    }
  }

  /// Persists the current onboarding step to Supabase.
  void _saveStep(OnboardingStep step) {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;
    ref
        .read(authRepositoryProvider)
        .updateOnboardingStep(userId: userId, step: step.stepNumber);
  }
}
