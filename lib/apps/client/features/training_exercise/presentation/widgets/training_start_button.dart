import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class TrainingStartButton extends StatelessWidget {
  const TrainingStartButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: (MediaQuery.paddingOf(context).bottom + AppSpacing.md)
            .bottom
            .add(AppSpacing.md.horizontal),
        child: CustomGestureDetector(
          onTap: onTap,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppSpacing.md),
            ),
            child: Padding(
              padding: AppSpacing.md.all,
              child: Text(
                'Iniciar Entrenamiento',
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
