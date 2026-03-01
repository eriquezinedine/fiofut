import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/providers/providers.dart';
import '../widgets/widgets.dart';

/// Pantalla 8: Pantalla motivacional
class MotivationalPage extends ConsumerWidget {
  const MotivationalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    // Calculate weight difference
    final currentWeight = state.data.currentWeight ?? 0;
    final desiredWeight = state.data.desiredWeight ?? 0;
    final weightDiff = (currentWeight - desiredWeight).abs().round();

    return OnboardingScaffold(
      progress: state.progress,
      onBack: () => notifier.previousStep(),
      centerContent: true,
      bottomSection: OnboardingContinueButton(
        onPressed: () => notifier.nextStep(),
        text: 'Continuar',
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          // Main motivational text
          AppAnimatedColumn(
            children: [
              AppAnimatedEntry(
                child: Text(
                  'Perdiendo',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h2,
                ),
              ),
              const SizedBox(height: 8),
              AppAnimatedEntry(
                child: Text(
                  '$weightDiff kg',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h1.copyWith(
                    color: AppColors.orange,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              AppAnimatedEntry(
                child: SizedBox(
                  width: 320,
                  child: Text(
                    'es un objetivo realista.\n¡No es difícil en absoluto!',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.h2.copyWith(
                      height: 1.3,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              AppAnimatedEntry(
                child: SizedBox(
                  width: 320,
                  child: Text(
                    'El 90% de los usuarios dice que el\ncambio es obvio después de usar Cal AI y\nno es fácil recaer',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
