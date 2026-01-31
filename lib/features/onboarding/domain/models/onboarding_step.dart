/// Represents each step in the onboarding wizard.
/// Order based on design: fio_design.pen
enum OnboardingStep {
  /// Step 1: Enter birth date
  birthDate(1),

  /// Step 2: Select gender
  gender(2),

  /// Step 3: Select workout location preference
  workoutLocation(3),

  /// Step 4: Enter current weight in kg
  currentWeight(4),

  /// Step 5: Enter height in cm
  height(5),

  /// Step 6: Select weight goal (lose, maintain, gain)
  weightGoal(6),

  /// Step 7: Enter desired weight in kg
  desiredWeight(7),

  /// Step 8: Motivational screen
  motivational(8),

  /// Step 9: Select excluded foods
  excludedFoods(9),

  /// Step 10: Enter optional injuries description
  injuries(10),

  /// Step 11: Enter optional referral code
  referralCode(11),

  /// Step 12: Loading/completion screen
  loading(12);

  const OnboardingStep(this.stepNumber);

  /// The numeric step number (1-12)
  final int stepNumber;

  /// Total number of steps in the onboarding wizard
  static const int totalSteps = 12;

  /// Returns the progress as a value between 0.0 and 1.0
  double get progress => stepNumber / totalSteps;

  /// Returns true if this is the first step
  bool get isFirst => this == OnboardingStep.birthDate;

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
