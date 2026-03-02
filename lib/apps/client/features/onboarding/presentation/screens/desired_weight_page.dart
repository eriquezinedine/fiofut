import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/models.dart';
import '../../domain/providers/providers.dart';
import '../widgets/widgets.dart';

/// Pantalla 7: Peso deseado
class DesiredWeightPage extends ConsumerStatefulWidget {
  const DesiredWeightPage({super.key});

  @override
  ConsumerState<DesiredWeightPage> createState() => _DesiredWeightPageState();
}

class _DesiredWeightPageState extends ConsumerState<DesiredWeightPage> {
  late double _weight;

  @override
  void initState() {
    super.initState();
    final state = ref.read(onboardingProvider);
    _weight = state.data.desiredWeight ??
        (state.data.currentWeight != null ? state.data.currentWeight! - 5 : 81.0);
  }

  String get _goalLabel {
    final goal = ref.read(onboardingProvider).data.weightGoal;
    switch (goal) {
      case WeightGoal.lose:
        return 'Perder peso';
      case WeightGoal.gain:
        return 'Ganar peso';
      case WeightGoal.maintain:
        return 'Mantener peso';
      case null:
        return 'Objetivo';
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);
    final isKg = state.data.useKgUnit;

    final currentWeight = state.data.currentWeight ?? _weight;
    final displayWeight = isKg ? _weight : _weight * 2.20462;
    final displayCurrentWeight = isKg ? currentWeight : currentWeight * 2.20462;
    final minWeight = isKg ? 40.0 : 88.0;
    final maxWeight = isKg ? 150.0 : 330.0;

    final Color? rangeColor;
    if (_weight < currentWeight) {
      rangeColor = AppColors.red;
    } else if (_weight > currentWeight) {
      rangeColor = AppColors.green;
    } else {
      rangeColor = null;
    }

    return OnboardingScaffold(
      progress: state.progress,
      title: '¿Cuál es tu\npeso deseado?',
      onBack: () => notifier.previousStep(),
      bottomSection: OnboardingContinueButton(
        onPressed: () {
          notifier.updateDesiredWeight(_weight);
          notifier.nextStep();
        },
        text: 'Continuar',
      ),
      child: AppAnimatedColumn(
        children: [
          const SizedBox(height: 20),
          // Goal label
          AppAnimatedEntry(
            child: Text(
              _goalLabel,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Weight display
          AppAnimatedEntry(
            child: Column(
              children: [
                Text(
                  displayWeight.toStringAsFixed(1),
                  style: AppTextStyles.displayXL,
                ),
                const SizedBox(height: 8),
                Text(
                  isKg ? 'kilogramos' : 'libras',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Slider
          AppAnimatedEntry(
            child: SliderWeight(
              value: displayWeight,
              min: minWeight,
              max: maxWeight,
              isKg: isKg,
              referenceValue: displayCurrentWeight,
              rangeColor: rangeColor,
              onChanged: (value) {
                setState(() {
                  _weight = isKg ? value : value / 2.20462;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
