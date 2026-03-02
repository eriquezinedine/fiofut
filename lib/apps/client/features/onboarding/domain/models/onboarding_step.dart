/// Represents each step in the onboarding wizard.
/// Order based on design: fio_design.pen
enum OnboardingStep {
  /// Step 1: How did you find us
  referralSource(1),

  /// Step 2: Enter birth date
  birthDate(2),

  /// Step 3: Select gender
  gender(3),

  /// Step 4: Select workout location preference
  workoutLocation(4),

  /// Step 5: Enter current weight in kg
  currentWeight(5),

  /// Step 6: Enter height in cm
  height(6),

  /// Step 7: Select weight goal (lose, maintain, gain)
  weightGoal(7),

  /// Step 8: Enter desired weight in kg
  desiredWeight(8),

  /// Step 9: Motivational screen
  motivational(9),

  /// Step 10: Select muscles to train
  injuries(10),

  /// Step 11: Select activity level
  activityLevel(11),

  /// Step 12: Select preferred training duration
  trainingDuration(12),

  /// Step 13: How many days per week to train
  trainingDays(13),

  /// Step 14: Enter optional referral code
  referralCode(14),

  /// Step 15: Loading/completion screen
  loading(15);

  const OnboardingStep(this.stepNumber);

  /// The numeric step number (1-15)
  final int stepNumber;

  /// Total number of steps in the onboarding wizard
  static const int totalSteps = 15;

  /// Returns the progress as a value between 0.0 and 1.0
  double get progress => stepNumber / totalSteps;

  /// Returns true if this is the first step
  bool get isFirst => this == OnboardingStep.referralSource;

  /// Returns true if this is the last step
  bool get isLast => this == OnboardingStep.loading;

  /// Returns the next step, or null if this is the last step
  OnboardingStep? get next {
    final currentIndex = OnboardingStep.values.indexOf(this);
    if (currentIndex < OnboardingStep.values.length - 1) {
      return OnboardingStep.values[currentIndex + 1];
    }
    return null;
  }

  /// Returns the previous step, or null if this is the first step
  OnboardingStep? get previous {
    final currentIndex = OnboardingStep.values.indexOf(this);
    if (currentIndex > 0) {
      return OnboardingStep.values[currentIndex - 1];
    }
    return null;
  }
}
