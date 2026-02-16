import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ExcerciseCardImage extends StatelessWidget {
  const ExcerciseCardImage({super.key, required this.exercise});
  final Exercise exercise;
  @override
  Widget build(BuildContext context) {
    return  ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: IntrinsicHeight(
              child: SizedBox(
                width: 80,
                // height: double.infinity,
                // height: 80,
                child: exercise.imageUrl != null &&
                        exercise.imageUrl!.isNotEmpty
                    ? Image.network(
                        exercise.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildPlaceholder(),
                      )
                    : _buildPlaceholder(),
              ),
            ),
          );
  }
}


Widget _buildPlaceholder() {
    return Container(
      color: AppColors.surfaceAlt,
      child: const Center(
        child: Icon(
          LucideIcons.dumbbell,
          color: AppColors.textMuted,
          size: 32,
        ),
      ),
    );
  }