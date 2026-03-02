import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/providers/providers.dart';
import '../widgets/widgets.dart';

/// Pantalla 13: ¿Cuántos días a la semana deseas entrenar?
class TrainingDaysPage extends ConsumerStatefulWidget {
  const TrainingDaysPage({super.key});

  @override
  ConsumerState<TrainingDaysPage> createState() => _TrainingDaysPageState();
}

class _TrainingDaysPageState extends ConsumerState<TrainingDaysPage> {
  late int _selectedDays;
  late FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    final state = ref.read(onboardingProvider);
    _selectedDays = state.data.trainingDays ?? 4;
    _controller = FixedExtentScrollController(
      initialItem: _selectedDays - 1,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return OnboardingScaffold(
      progress: state.progress,
      centerContent: true,
      title: '¿Cuántos días a la semana\ndeseas entrenar?',
      subtitle: 'Recomendamos entre 3 y 5 días para mejores resultados',
      onBack: () => notifier.previousStep(),
      bottomSection: OnboardingContinueButton(
        onPressed: () {
          notifier.updateTrainingDays(_selectedDays);
          notifier.nextStep();
        },
      ),
      child: Center(
        child: SizedBox(
          height: 200,
          width: 160,
          child: _buildPickerColumn(),
        ),
      ),
    );
  }

  Widget _buildPickerColumn() {
    return ListWheelScrollView.useDelegate(
      controller: _controller,
      itemExtent: 40,
      perspective: 0.005,
      diameterRatio: 1.2,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: (index) {
        setState(() {
          _selectedDays = index + 1;
        });
      },
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: 7,
        builder: (context, index) {
          final day = index + 1;
          final isSelected = day == _selectedDays;
          final distance = (index - (_selectedDays - 1)).abs();

          final Color textColor;
          final double fontSize;
          final FontWeight fontWeight;

          if (isSelected) {
            textColor = AppColors.white;
            fontSize = 24;
            fontWeight = FontWeight.w700;
          } else if (distance == 1) {
            textColor = AppColors.textMuted;
            fontSize = 20;
            fontWeight = FontWeight.w500;
          } else {
            textColor = AppColors.textDimmed;
            fontSize = 18;
            fontWeight = FontWeight.w500;
          }

          return Center(
            child: Text(
              '$day ${day == 1 ? 'día' : 'días'}',
              style: AppTextStyles.body.copyWith(
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: textColor,
              ),
            ),
          );
        },
      ),
    );
  }
}
