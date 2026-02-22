import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class FoodTypeTag extends StatelessWidget {
  const FoodTypeTag({super.key, required this.typeFood, required this.label});

  final String typeFood;
  final String label;

  Color get _color => switch (typeFood) {
        'breakfast' => AppColors.orange,
        'lunch' => AppColors.primary,
        'dinner' => AppColors.purple,
        'snack' => AppColors.info,
        _ => AppColors.primary,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _color,
        ),
      ),
    );
  }
}
