import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../domain/providers/food_provider.dart';

class FoodImageSection extends StatelessWidget {
  const FoodImageSection({
    super.key,
    required this.isExistingFood,
    this.imageUrl,
    required this.uploadState,
  });

  final bool isExistingFood;
  final String? imageUrl;
  final FoodImageUploadState uploadState;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppSpacing.borderRadiusXl,
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: isExistingFood
            ? Image.network(
                imageUrl ?? '',
                fit: BoxFit.cover,
                loadingBuilder: (_, child, progress) {
                  if (progress == null) return child;
                  return const _ImageShimmer();
                },
                errorBuilder: (_, __, ___) => const _ImageError(),
              )
            : switch (uploadState) {
                FoodImageUploadInitial() ||
                FoodImageUploading() =>
                  const _ImageShimmer(),
                FoodImageUploaded(:final imageUrl) => Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (_, child, progress) {
                      if (progress == null) return child;
                      return const _ImageShimmer();
                    },
                    errorBuilder: (_, __, ___) => const _ImageError(),
                  ),
                FoodImageUploadError() => const _ImageError(),
              },
      ),
    );
  }
}

class _ImageShimmer extends StatelessWidget {
  const _ImageShimmer();

  @override
  Widget build(BuildContext context) {
    return AppShimmer(child: Container(color: AppColors.grey800));
  }
}

class _ImageError extends StatelessWidget {
  const _ImageError();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.card,
      child: const Center(
        child: Icon(
          LucideIcons.imageOff,
          color: AppColors.textMuted,
          size: AppSpacing.iconXl,
        ),
      ),
    );
  }
}
