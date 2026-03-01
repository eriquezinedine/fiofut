import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/widgets/ingredient/ingredient.dart';
import '../../domain/providers/providers.dart';
import '../widgets/widgets.dart';

/// Pantalla 9: Alimentos excluidos
class ExcludedFoodsPage extends ConsumerWidget {
  const ExcludedFoodsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);
    final excludedFoods = onboardingState.data.excludedFoods;

    return OnboardingScaffold(
      progress: onboardingState.progress,
      title: '¿Cual es la comida que\nno te gusta o te hace mal?',
      onBack: () => notifier.previousStep(),
      scrollable: false,
      bottomSection: OnboardingContinueButton(
        onPressed: () => notifier.nextStep(),
        text: 'Continuar',
      ),
      child: IngredientSearchBody(
          onIngredientTap: (item) {
            if (excludedFoods.contains(item.name)) {
              notifier.removeExcludedFood(item.name);
            } else {
              notifier.addExcludedFood(item.name);
            }
          },
          selectedNames: excludedFoods.toSet(),
          onAddNew: (name) {
            notifier.addExcludedFood(name);
          },
        ),
    );
  }
}
