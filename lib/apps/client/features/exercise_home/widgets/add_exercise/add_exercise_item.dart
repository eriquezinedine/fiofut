import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AddExerciseItem extends StatelessWidget {
  const AddExerciseItem({
    required this.exercise,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final Exercise exercise;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomGestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            // Imagen
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 60,
                height: 60,
                child: exercise.imageUrl != null
                    ? Image.network(
                        exercise.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const _ImagePlaceholder(),
                      )
                    : const _ImagePlaceholder(),
              ),
            ),
            const SizedBox(width: 16),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.32,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    exercise.targetFormatted,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textDescription,
                      fontSize: 14,
                      letterSpacing: -0.28,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            // Checkbox
            _ExerciseCheckbox(isSelected: isSelected),
          ],
        ),
      ),
    );
  }
}

class _ExerciseCheckbox extends StatelessWidget {
  const _ExerciseCheckbox({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.card,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(
          color: isSelected ? AppColors.primary : const Color(0xFF43454D),
          width: 1,
        ),
      ),
      child: isSelected
          ? const Icon(
              LucideIcons.check,
              color: AppColors.white,
              size: 12,
            )
          : null,
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.surface,
      child: Center(
        child: Icon(
          LucideIcons.dumbbell,
          color: AppColors.textDescription,
          size: 24,
        ),
      ),
    );
  }
}
