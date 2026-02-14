import 'dart:io';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../domain/providers/food_provider.dart';

class FoodDetailPage extends ConsumerStatefulWidget {
  const FoodDetailPage({required this.imageFile, super.key});

  final File imageFile;

  @override
  ConsumerState<FoodDetailPage> createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends ConsumerState<FoodDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(foodImageUploadProvider.notifier).uploadImage(widget.imageFile);
    });
  }

  @override
  void dispose() {
    Future.microtask(() {
      ref.read(foodImageUploadProvider.notifier).reset();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uploadState = ref.watch(foodImageUploadProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Detalle de comida', style: AppTextStyles.titleMedium),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(uploadState),
            const SizedBox(height: AppSpacing.lg),
            _buildInfoSection(uploadState),
          ],
        ),
      ),
    );
  }

  // ── Image Section ─────────────────────────────────────────────

  Widget _buildImageSection(FoodImageUploadState uploadState) {
    return ClipRRect(
      borderRadius: AppSpacing.borderRadiusXl,
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: switch (uploadState) {
          FoodImageUploadInitial() || FoodImageUploading() => _buildImageShimmer(),
          FoodImageUploaded(:final imageUrl) => Image.network(
              imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (_, child, progress) {
                if (progress == null) return child;
                return _buildImageShimmer();
              },
              errorBuilder: (_, __, ___) => _buildImageError(),
            ),
          FoodImageUploadError() => _buildImageError(),
        },
      ),
    );
  }

  Widget _buildImageShimmer() {
    return AppShimmer(
      child: Container(
        color: AppColors.grey800,
      ),
    );
  }

  Widget _buildImageError() {
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

  // ── Info Section ──────────────────────────────────────────────

  Widget _buildInfoSection(FoodImageUploadState uploadState) {
    return switch (uploadState) {
      FoodImageUploadInitial() || FoodImageUploading() => _buildInfoShimmer(),
      FoodImageUploaded() => _buildInfoLoaded(),
      FoodImageUploadError(:final message) => _buildInfoError(message),
    };
  }

  Widget _buildInfoShimmer() {
    return AppShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppShimmerBox(width: 200, height: 24),
          const SizedBox(height: AppSpacing.sm),
          AppShimmerBox(width: double.infinity, height: 16),
          const SizedBox(height: AppSpacing.xs),
          AppShimmerBox(width: 260, height: 16),
          const SizedBox(height: AppSpacing.lg),
          // Nutrition card shimmer
          Container(
            padding: AppSpacing.cardPadding,
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: AppSpacing.borderRadiusXl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppShimmerBox(width: 160, height: 20),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildNutrientShimmer(),
                    _buildNutrientShimmer(),
                    _buildNutrientShimmer(),
                    _buildNutrientShimmer(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientShimmer() {
    return const Column(
      children: [
        AppShimmerBox(width: 48, height: 48, borderRadius: BorderRadius.all(Radius.circular(AppSpacing.radiusMd))),
        SizedBox(height: AppSpacing.xs),
        AppShimmerBox(width: 40, height: 12),
        SizedBox(height: AppSpacing.xxxs),
        AppShimmerBox(width: 32, height: 10),
      ],
    );
  }

  Widget _buildInfoLoaded() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Foto subida correctamente',
          style: AppTextStyles.h3,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'La imagen se ha guardado. Pronto podremos analizar su contenido nutricional.',
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.lg),
        Container(
          width: double.infinity,
          padding: AppSpacing.cardPadding,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: AppSpacing.borderRadiusXl,
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: AppSpacing.borderRadiusMd,
                ),
                child: const Icon(
                  LucideIcons.check,
                  color: AppColors.primary,
                  size: AppSpacing.iconMd,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upload completo',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxxs),
                    Text(
                      'Imagen guardada en la nube',
                      style: AppTextStyles.small.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoError(String message) {
    return AppErrorWidget(
      title: 'Error al subir imagen',
      message: message,
      onRetry: () {
        ref.read(foodImageUploadProvider.notifier).uploadImage(widget.imageFile);
      },
    );
  }
}
