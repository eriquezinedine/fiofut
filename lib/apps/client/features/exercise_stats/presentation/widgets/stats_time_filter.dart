import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// Time filter toggle with only "Semana" and "Mes" options.
///
/// [selectedIndex]: 0 = Semana, 1 = Mes.
class StatsTimeFilter extends StatelessWidget {
  const StatsTimeFilter({
    required this.selectedIndex,
    required this.onChanged,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  static const _labels = ['Semana', 'Mes'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppSpacing.borderRadiusFull,
      ),
      child: Row(
        children: List.generate(_labels.length, (i) {
          final isSelected = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color:
                      isSelected ? AppColors.primary : AppColors.transparent,
                  borderRadius: AppSpacing.borderRadiusFull,
                ),
                alignment: Alignment.center,
                child: Text(
                  _labels[i],
                  style: AppTextStyles.labelMedium.copyWith(
                    color:
                        isSelected ? AppColors.black : AppColors.textSecondary,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
