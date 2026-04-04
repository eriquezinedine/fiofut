import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise.dart';
import 'package:fio_fut/apps/client/features/exercise_home/presentation/pages/exercise_image_page.dart';
import 'package:fio_fut/core/extension/muscle_group_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:model/model.dart';

class ExcerciseCardImage extends StatelessWidget {
  const ExcerciseCardImage({super.key, required this.exercise, required this.style2});
  final Exercise exercise;
  final bool style2;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(ExerciseImagePage.name, extra: exercise);   
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 80,
              height: style2 ? 90 : 120,
              child: exercise.imageUrl != null && exercise.imageUrl!.isNotEmpty
                  ? Image.network(
                      exercise.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildPlaceholder(),
                    )
                  : _buildPlaceholder(),
            ),
          ),
          Positioned(
            bottom: -4,
            right: -4,
            child: SizedBox.square(
              dimension: 44,
              child: SvgPicture.asset(MuscleGroup.back.getIcon)))
        ],
      ),
    );
  }
}


Widget _buildPlaceholder() {
    return Container(
      color: AppColors.textDescription,
      child: const Center(
        child: Icon(
          LucideIcons.dumbbell,
          color: AppColors.card,
          size: 32,
        ),
      ),
    );
  }