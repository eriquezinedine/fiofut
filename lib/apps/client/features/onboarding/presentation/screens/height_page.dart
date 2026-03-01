import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/providers/providers.dart';
import '../widgets/widgets.dart';

/// Pantalla 5: Altura del usuario
class HeightPage extends ConsumerStatefulWidget {
  const HeightPage({super.key});

  @override
  ConsumerState<HeightPage> createState() => _HeightPageState();
}

class _HeightPageState extends ConsumerState<HeightPage> {
  late double _height;
  bool _isCm = true;

  @override
  void initState() {
    super.initState();
    final state = ref.read(onboardingProvider);
    _height = state.data.height ?? 175.0;
  }

  double get _displayHeight {
    if (_isCm) return _height;
    // Convert cm to feet (decimal)
    return _height / 30.48;
  }

  String get _displayHeightText {
    if (_isCm) return _height.toInt().toString();
    final feet = (_height / 30.48).floor();
    final inches = ((_height / 2.54) % 12).round();
    return "$feet'$inches\"";
  }

  double get _minHeight => _isCm ? 100 : 3.3;
  double get _maxHeight => _isCm ? 220 : 7.2;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return OnboardingScaffold(
      progress: state.progress,
      title: '¿Cuál es tu altura?',
      subtitle: 'Esto nos ayuda a calcular tu plan personalizado',
      scrollable: false,
      onBack: () => notifier.previousStep(),
      bottomSection: OnboardingContinueButton(
        onPressed: () {
          notifier.updateHeight(_height);
          notifier.nextStep();
        },
      ),
      child: Column(
        children: [
          AppAnimatedColumn(
            
            children: [
               AppAnimatedEntry(
              child: Row(
                          children: [
                            Expanded(
                              child: _UnitToggle(
                                text: 'Centímetros',
                                isSelected: _isCm,
                                onTap: () => setState(() => _isCm = true),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _UnitToggle(
                                text: 'Pies & Pulgadas',
                                isSelected: !_isCm,
                                onTap: () => setState(() => _isCm = false),
                              ),
                            ),
                          ],
                        ),
            ),
          const SizedBox(height: 20),

          // Display de altura
          AppAnimatedEntry(
            child: Column(
              children: [
                Text(
                  _isCm ? _height.toInt().toString() : _displayHeightText,
                  style: AppTextStyles.displayXL,
                ),
                const SizedBox(height: 8),
                Text(
                  _isCm ? 'centímetros' : 'pies & pulgadas',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
            ],
          ),
           
          // Slider
          Expanded(
            child: AppAnimatedEntry(
              child: SliderHeight(
                value: _displayHeight,
                min: _minHeight,
                max: _maxHeight,
                isCm: _isCm,
                onChanged: (value) {
                  setState(() {
                    _height = _isCm ? value : value * 30.48;
                  });
                },
              ),
            ),
          ),
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

