import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class FoodSaveButton extends StatelessWidget {
  const FoodSaveButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Center(
          child: Text(
            'Guardar cambios',
            style: AppTextStyles.button.copyWith(
              color: AppColors.black,
            ),
          ),
        ),
      ),
    );
  }
}
