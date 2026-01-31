import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/providers/providers.dart';
import '../widgets/widgets.dart';

/// Pantalla 4: Peso actual del usuario
class CurrentWeightPage extends ConsumerStatefulWidget {
  const CurrentWeightPage({super.key});

  @override
  ConsumerState<CurrentWeightPage> createState() => _CurrentWeightPageState();
}

class _CurrentWeightPageState extends ConsumerState<CurrentWeightPage> {
  late double _weight;
  late bool _isKg;

  @override
  void initState() {
    super.initState();
    final state = ref.read(onboardingProvider);
    _weight = state.data.currentWeight ?? 75.5;
    _isKg = state.data.useKgUnit;
  }

  void _setUnit(bool isKg) {
    setState(() => _isKg = isKg);
    ref.read(onboardingProvider.notifier).updateWeightUnit(isKg);
  }

  double get _displayWeight => _isKg ? _weight : _weight * 2.20462;
  double get _minWeight => _isKg ? 40 : 88;
  double get _maxWeight => _isKg ? 150 : 330;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return OnboardingScaffold(
      progress: state.progress,
      title: '¿Cuál es tu peso actual?',
      subtitle: 'Tu peso actual nos ayuda a establecer tu punto de partida',
      onBack: () => notifier.previousStep(),
      bottomSection: OnboardingContinueButton(
        onPressed: () {
          notifier.updateCurrentWeight(_weight);
          notifier.nextStep();
        },
      ),
      child: Column(
        children: [
           // Toggle Kilogramos / Libras
          Row(
            children: [
              Expanded(
                child: _UnitToggle(
                  text: 'Kilogramos',
                  isSelected: _isKg,
                  onTap: () => _setUnit(true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _UnitToggle(
                  text: 'Libras',
                  isSelected: !_isKg,
                  onTap: () => _setUnit(false),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          // Display de peso

          Column(
            children: [
              Text(
                _displayWeight.toStringAsFixed(1),
                style: AppTextStyles.displayXL,
              ),
              const SizedBox(height: 8),
              Text(
                _isKg ? 'kilogramos' : 'libras',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Slider
          SliderWeight(
            value: _displayWeight,
            min: _minWeight,
            max: _maxWeight,
            isKg: _isKg,
            onChanged: (value) {
              setState(() {
                _weight = _isKg ? value : value / 2.20462;
              });
            },
          ),
          const SizedBox(height: 20),
         
        ],
      ),
    );
  }
}

class _UnitToggle extends StatelessWidget {
  const _UnitToggle({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomGestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.green : AppColors.card,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? AppColors.black : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

