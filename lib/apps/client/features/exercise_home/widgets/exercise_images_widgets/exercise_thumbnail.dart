import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// A small thumbnail image of an exercise with a border.
///
/// Displays the exercise image in a rounded container with a white border.
/// Shows a dumbbell icon as fallback when image fails to load.
class ExerciseThumbnail extends StatelessWidget {
  const ExerciseThumbnail({
    super.key,
    this.imageUrl,
    this.size = 60,
    this.borderRadius,
  });

  /// URL of the exercise image. Can be null.
  final String? imageUrl;

  /// Size of the thumbnail container (default: 60).
  final double size;

  /// Border radius (default: 12).
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return const SizedBox.shrink();
    }

    final radius = borderRadius ?? AppSpacing.radiusMd;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius - 2),
        child: Image.network(
          imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(
            LucideIcons.dumbbell,
            color: AppColors.textSecondary,
            size: 28,
          ),
        ),
      ),
    );
  }
}
