import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/providers/providers.dart';
import '../widgets/widgets.dart';

/// Pantalla 1: Fecha de nacimiento
class BirthDatePage extends ConsumerStatefulWidget {
  const BirthDatePage({super.key});

  @override
  ConsumerState<BirthDatePage> createState() => _BirthDatePageState();
}

class _BirthDatePageState extends ConsumerState<BirthDatePage> {
  late int _selectedMonth;
  late int _selectedDay;
  late int _selectedYear;

  late FixedExtentScrollController _monthController;
  late FixedExtentScrollController _dayController;
  late FixedExtentScrollController _yearController;

  final List<String> _months = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre',
  ];

  int get _minYear => 1940;
  int get _maxYear => DateTime.now().year - 10;

  @override
  void initState() {
    super.initState();
    final state = ref.read(onboardingProvider);
    final birthDate = state.data.birthDate ?? DateTime(1995, 12, 15);

    _selectedMonth = birthDate.month;
    _selectedDay = birthDate.day;
    _selectedYear = birthDate.year;

    _monthController = FixedExtentScrollController(
      initialItem: _selectedMonth - 1,
    );
    _dayController = FixedExtentScrollController(
      initialItem: _selectedDay - 1,
    );
    _yearController = FixedExtentScrollController(
      initialItem: _selectedYear - _minYear,
    );
  }

  @override
  void dispose() {
    _monthController.dispose();
    _dayController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  int _getDaysInMonth(int month, int year) {
    return DateTime(year, month + 1, 0).day;
  }

  DateTime get _selectedDate {
    final daysInMonth = _getDaysInMonth(_selectedMonth, _selectedYear);
    final day = _selectedDay > daysInMonth ? daysInMonth : _selectedDay;
    return DateTime(_selectedYear, _selectedMonth, day);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return OnboardingScaffold(
      progress: state.progress,
      showBackButton: false,
      centerContent: true,
      title: '¿Cuándo naciste?',
      subtitle: 'Esto se utilizará para calibrar tu plan personalizado',
      onBack: () => notifier.previousStep(),
      bottomSection: OnboardingContinueButton(
        onPressed: () {
          notifier.updateBirthDate(_selectedDate);
          notifier.nextStep();
        },
      ),
      child: SizedBox(
        height: 200,
        child: Row(
          children: [
            // Month column
            Expanded(
              child: _buildPickerColumn(
                controller: _monthController,
                itemCount: 12,
                selectedIndex: _selectedMonth - 1,
                itemBuilder: (index) => _months[index],
                onSelectedItemChanged: (index) {
                  setState(() {
                    _selectedMonth = index + 1;
                  });
                },
              ),
            ),
            // Day column
            Expanded(
              child: _buildPickerColumn(
                controller: _dayController,
                itemCount: 31,
                selectedIndex: _selectedDay - 1,
                itemBuilder: (index) => '${index + 1}',
                onSelectedItemChanged: (index) {
                  setState(() {
                    _selectedDay = index + 1;
                  });
                },
              ),
            ),
            // Year column
            Expanded(
              child: _buildPickerColumn(
                controller: _yearController,
                itemCount: _maxYear - _minYear + 1,
                selectedIndex: _selectedYear - _minYear,
                itemBuilder: (index) => '${_minYear + index}',
                onSelectedItemChanged: (index) {
                  setState(() {
                    _selectedYear = _minYear + index;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPickerColumn({
    required FixedExtentScrollController controller,
    required int itemCount,
    required int selectedIndex,
    required String Function(int) itemBuilder,
    required ValueChanged<int> onSelectedItemChanged,
  }) {
    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: 40,
      perspective: 0.005,
      diameterRatio: 1.2,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: onSelectedItemChanged,
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: itemCount,
        builder: (context, index) {
          final isSelected = index == selectedIndex;
          final distance = (index - selectedIndex).abs();

          // Determine style based on distance from selected
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
              itemBuilder(index),
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
