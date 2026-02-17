import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/models.dart';
import '../../domain/providers/providers.dart';
import 'screens.dart';

/// Widget principal que coordina el flujo del onboarding wizard.
class OnboardingWizard extends ConsumerStatefulWidget {
  static const String name = 'onboarding';
  static const String path = '/onboarding';

  const OnboardingWizard({super.key});

  @override
  ConsumerState<OnboardingWizard> createState() => _OnboardingWizardState();
}

class _OnboardingWizardState extends ConsumerState<OnboardingWizard> {
  @override
  void initState() {
    super.initState();
    // Iniciar el onboarding cuando se carga el widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(onboardingProvider.notifier).startOnboarding();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);

    return switch (state) {
      OnboardingInitial() => const _LoadingScreen(),
      OnboardingInProgress(:final currentStep, :final data) =>
        _buildStepScreen(currentStep, data),
      OnboardingCompleted(:final data) => _OnboardingCompleteScreen(data: data),
      OnboardingError(:final message) => _ErrorScreen(message: message),
    };
  }

  Widget _buildStepScreen(OnboardingStep step, OnboardingData data) {
    return switch (step) {
      OnboardingStep.weightGoal => const WeightGoalPage(),
      OnboardingStep.height => const HeightPage(),
      OnboardingStep.currentWeight => const CurrentWeightPage(),
      OnboardingStep.workoutLocation => const WorkoutLocationPage(),
      OnboardingStep.gender => const GenderPage(),
      OnboardingStep.birthDate => const BirthDatePage(),
      OnboardingStep.loading => const LoadingPage(),
      OnboardingStep.referralCode => const ReferralCodePage(),
      OnboardingStep.injuries => const InjuriesPage(),
      OnboardingStep.excludedFoods => const ExcludedFoodsPage(),
      OnboardingStep.motivational => const MotivationalPage(),
      OnboardingStep.desiredWeight => const DesiredWeightPage(),
    };
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _OnboardingCompleteScreen extends StatelessWidget {
  const _OnboardingCompleteScreen({required this.data});

  final OnboardingData data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 80, color: Colors.green),
            const SizedBox(height: 24),
            const Text(
              'Onboarding Completado!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('IMC: ${data.bmi?.toStringAsFixed(1) ?? "N/A"}'),
          ],
        ),
      ),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 80, color: Colors.red),
            const SizedBox(height: 24),
            Text(message),
          ],
        ),
      ),
    );
  }
}
