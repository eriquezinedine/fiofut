part of 'onboarding_provider.dart';

/// Sealed class representing all possible states of the onboarding wizard.
///
/// Uses sealed classes to enable exhaustive pattern matching in Dart.
sealed class OnboardingState {
  const OnboardingState();
}

/// Initial state before onboarding has started.
class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
}

/// State when the user is actively going through the onboarding wizard.
class OnboardingInProgress extends OnboardingState {
  const OnboardingInProgress({
    required this.currentStep,
    required this.data,
  });

  /// The current step in the onboarding wizard.
  final OnboardingStep currentStep;

  /// The collected onboarding data so far.
  final OnboardingData data;

  /// Returns the progress as a value between 0.0 and 1.0.
  double get progress => currentStep.progress;

  /// Returns true if the user can go back to a previous step.
  bool get canGoBack => !currentStep.isFirst;

  /// Returns true if this is the last step.
  bool get isLastStep => currentStep.isLast;
}

/// State when the onboarding has been completed successfully.
class OnboardingCompleted extends OnboardingState {
  const OnboardingCompleted({required this.data});

  /// The complete onboarding data.
  final OnboardingData data;
}

/// State when an error occurred during onboarding.
class OnboardingError extends OnboardingState {
  const OnboardingError({required this.message});

  /// The error message describing what went wrong.
  final String message;
}

/// Extension providing safe accessors for OnboardingState.
extension OnboardingStateX on OnboardingState {
  /// Returns the current step, or the first step if not in progress.
  OnboardingStep get currentStep => switch (this) {
        OnboardingInProgress(:final currentStep) => currentStep,
        _ => OnboardingStep.weightGoal,
      };

  /// Returns the onboarding data, or empty data if not available.
  OnboardingData get data => switch (this) {
        OnboardingInProgress(:final data) => data,
        OnboardingCompleted(:final data) => data,
        _ => const OnboardingData.empty(),
      };

  /// Returns the progress as a value between 0.0 and 1.0.
  double get progress => switch (this) {
        OnboardingInProgress(:final currentStep) => currentStep.progress,
        OnboardingCompleted() => 1.0,
        _ => 0.0,
      };

  /// Returns true if the onboarding is currently in progress.
  bool get isInProgress => this is OnboardingInProgress;

  /// Returns true if the onboarding has been completed.
  bool get isCompleted => this is OnboardingCompleted;

  /// Returns true if there's an error.
  bool get hasError => this is OnboardingError;

  /// Returns the error message if in error state, null otherwise.
  String? get errorMessage => switch (this) {
        OnboardingError(:final message) => message,
        _ => null,
      };

  /// Pattern matching helper for when you need to perform different actions
  /// based on the state.
  T when<T>({
    required T Function() initial,
    required T Function(OnboardingStep currentStep, OnboardingData data)
        inProgress,
    required T Function(OnboardingData data) completed,
    required T Function(String message) error,
  }) =>
      switch (this) {
        OnboardingInitial() => initial(),
        OnboardingInProgress(:final currentStep, :final data) =>
          inProgress(currentStep, data),
        OnboardingCompleted(:final data) => completed(data),
        OnboardingError(:final message) => error(message),
      };

  /// Pattern matching helper with optional handlers.
  T maybeWhen<T>({
    T Function()? initial,
    T Function(OnboardingStep currentStep, OnboardingData data)? inProgress,
    T Function(OnboardingData data)? completed,
    T Function(String message)? error,
    required T Function() orElse,
  }) =>
      switch (this) {
        OnboardingInitial() => initial?.call() ?? orElse(),
        OnboardingInProgress(:final currentStep, :final data) =>
          inProgress?.call(currentStep, data) ?? orElse(),
        OnboardingCompleted(:final data) => completed?.call(data) ?? orElse(),
        OnboardingError(:final message) => error?.call(message) ?? orElse(),
      };
}
