import 'package:fio_fut/features/onboarding/domain/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      currentStep: OnboardingStep.birthDate,
      data: const OnboardingData.empty(),
    );
  }

  /// Advances to the next step in the wizard.
  ///
  /// Returns true if successfully moved to next step, false if already at last step.
  bool nextStep() {
    return switch (state) {
      OnboardingInProgress(:final currentStep, :final data) => () {
          final nextStep = currentStep.next;
          if (nextStep != null) {
            state = OnboardingInProgress(
              currentStep: nextStep,
              data: data,
            );
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
  bool previousStep() {
    return switch (state) {
      OnboardingInProgress(:final currentStep, :final data) => () {
          final prevStep = currentStep.previous;
          if (prevStep != null) {
            state = OnboardingInProgress(
              currentStep: prevStep,
              data: data,
            );
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

  /// Toggles a workout location in the selection.
  void toggleWorkoutLocation(WorkoutLocation location) {
    switch (state) {
      case OnboardingInProgress(:final currentStep, :final data):
        final newLocations = Set<WorkoutLocation>.from(data.workoutLocations);
        if (newLocations.contains(location)) {
          newLocations.remove(location);
        } else {
          newLocations.add(location);
        }
        state = OnboardingInProgress(
          currentStep: currentStep,
          data: data.copyWith(workoutLocations: newLocations),
        );
      default:
        break;
    }
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

  /// Completes the onboarding process.
  ///
  /// Returns true if onboarding was completed successfully,
  /// false if data is incomplete.
  bool completeOnboarding() {
    return switch (state) {
      OnboardingInProgress(:final data) => () {
          if (data.isComplete) {
            state = OnboardingCompleted(data: data);
            return true;
          }
          return false;
        }(),
      _ => false,
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
}
