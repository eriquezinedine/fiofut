import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ConfigurationExerciseButton extends StatelessWidget {
  const ConfigurationExerciseButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Ejercicios',
              style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
            ),
            CustomGestureDetector(
              onTap: onTap,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 6,
                children: [
                  Text(
                    'Editar rutina',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textDescription,
                    ),
                  ),
                  const Icon(
                    LucideIcons.calendarRange,
                    color: AppColors.textDescription,
                    size: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
