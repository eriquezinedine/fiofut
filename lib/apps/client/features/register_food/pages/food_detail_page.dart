import 'dart:developer';
import 'dart:io';

import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/food_home/domain/providers/food_home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/widgets/modal/delete_ingredient_modal.dart';
import '../../../../../core/widgets/modal/edit_ingredient_modal.dart';
import '../../../../../core/widgets/modal/ingredient_options_modal.dart';
import '../domain/providers/food_provider.dart';
import '../domain/providers/food_provider_detail.dart';
import '../widgets/food_detail_shimmer.dart';
import '../widgets/food_image_section.dart';
import '../widgets/food_ingredient_item.dart';
import '../widgets/food_nutrition_card.dart';
import '../widgets/food_save_button.dart';
import '../widgets/food_type_tag.dart';
import 'select_ingredient_page.dart';

class FoodDetailPage extends ConsumerStatefulWidget {
  const FoodDetailPage({
    this.imageFile,
    this.foodId,
    this.imageUrl,
    this.initialResult,
    super.key,
  }) : assert(imageFile != null || foodId != null);

  /// For new food flow (take photo -> upload -> recognize).
  final File? imageFile;

  /// For existing food flow (tap loaded card).
  final String? foodId;
  final String? imageUrl;

  /// Pre-loaded detail (skips DB fetch entirely).
  final FoodRecognitionResult? initialResult;

  bool get isExistingFood => foodId != null;

  @override
  ConsumerState<FoodDetailPage> createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends ConsumerState<FoodDetailPage> {
  bool _hasChanges = false;

  void _markChanged() {
    if (!_hasChanges) setState(() => _hasChanges = true);
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (widget.initialResult != null) {
        ref.read(foodDetailProvider.notifier).setResult(widget.initialResult!);
      } else if (widget.isExistingFood) {
        ref
            .read(foodDetailProvider.notifier)
            .loadExistingFood(widget.foodId!);
      } else {
        ref
            .read(foodImageUploadProvider.notifier)
            .uploadImage(widget.imageFile!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final uploadState = ref.watch(foodImageUploadProvider);
    final detailState = ref.watch(foodDetailProvider);

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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screenPadding.left,
              AppSpacing.screenPadding.top,
              AppSpacing.screenPadding.right,
              _hasChanges ? 100 : AppSpacing.xl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FoodImageSection(
                  isExistingFood: widget.isExistingFood,
                  imageUrl: widget.imageUrl,
                  uploadState: uploadState,
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildInfoSection(uploadState, detailState),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
          if (_hasChanges)
            Positioned(
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).padding.bottom + 16,
              child: FoodSaveButton(
                onTap: () => _saveChanges(detailState),
              ),
            ),
        ],
      ),
    );
  }

  // ── Info Section Routing ────────────────────────────────────────

  Widget _buildInfoSection(
    FoodImageUploadState uploadState,
    FoodDetailState detailState,
  ) {
    if (widget.isExistingFood) {
      return switch (detailState) {
        FoodDetailInitial() || FoodDetailAnalyzing() =>
          const FoodContentShimmer(),
        FoodDetailLoaded(:final result) => _buildFoodDetail(result),
        FoodDetailError(:final message) => _buildAnalysisError(message),
      };
    }

    if (uploadState is FoodImageUploadInitial ||
        uploadState is FoodImageUploading) {
      return const FoodContentShimmer();
    }

    if (uploadState is FoodImageUploadError) {
      return AppErrorWidget(
        title: 'Error al subir imagen',
        message: uploadState.message,
        onRetry: () {
          ref
              .read(foodImageUploadProvider.notifier)
              .uploadImage(widget.imageFile!);
        },
      );
    }

    return switch (detailState) {
      FoodDetailInitial() || FoodDetailAnalyzing() =>
        const FoodAnalyzingState(),
      FoodDetailLoaded(:final result) => _buildFoodDetail(result),
      FoodDetailError(:final message) => _buildAnalysisError(message),
    };
  }

  // ── Food Detail (Loaded) ───────────────────────────────────────

  Widget _buildFoodDetail(FoodRecognitionResult result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(result.title, style: AppTextStyles.h3),
        const SizedBox(height: AppSpacing.xs),
        FoodTypeTag(typeFood: result.typeFood, label: result.typeFoodDisplay),
        if (result.description.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            result.description,
            style:
                AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        FoodNutritionCard(result: result),
        _buildSourceChips(result),
        const SizedBox(height: AppSpacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Ingredientes', style: AppTextStyles.h3),
            GestureDetector(
              onTap: () async {
                final added = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SelectIngredientPage(foodId: result.id),
                  ),
                );
                if (added == true && mounted) {
                  _markChanged();
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '+ Agregar',
                  style: AppTextStyles.small.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ...result.ingredients.map(
          (i) => FoodIngredientItem(
            ingredient: i,
            onTap: () => _showIngredientOptions(i),
          ),
        ),
      ],
    );
  }

  // ── Source Chips ──────────────────────────────────────────────

  Widget _buildSourceChips(FoodRecognitionResult result) {
    final hasYoutube = result.linkYoutube != null;
    final hasTiktok = result.linkTiktok != null;
    final hasInstagram = result.linkInstagram != null;

    if (!hasYoutube && !hasTiktok && !hasInstagram) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: Wrap(
        spacing: AppSpacing.sm,
        children: [
          if (hasYoutube)
            _SourceChip(
              label: 'YouTube',
              icon: LucideIcons.youtube,
              color: const Color(0xFFFF0000),
              onTap: () => _openUrl(result.linkYoutube!),
            ),
          if (hasTiktok)
            _SourceChip(
              label: 'TikTok',
              icon: LucideIcons.music2,
              color: AppColors.white,
              onTap: () => _openUrl(result.linkTiktok!),
            ),
          if (hasInstagram)
            _SourceChip(
              label: 'Instagram',
              icon: LucideIcons.instagram,
              color: const Color(0xFFE1306C),
              onTap: () => _openUrl(result.linkInstagram!),
            ),
        ],
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // ── Save ───────────────────────────────────────────────────────

  void _saveChanges(FoodDetailState detailState) {
    if (detailState is! FoodDetailLoaded) return;

    final result = detailState.result;
    ref.read(foodHomeProvider.notifier).updateFoodItem(
          result.id,
          calories: result.totalCalories.round(),
          protein: result.totalProtein.round(),
          carbs: result.totalCarbohydrates.round(),
          fat: result.totalFat.round(),
          detail: result,
        );

    setState(() => _hasChanges = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Cambios guardados'),
        backgroundColor: AppColors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusMd,
        ),
      ),
    );
  }

  // ── Modal Flow ────────────────────────────────────────────────

  void _showIngredientOptions(RecognizedIngredient ingredient) {
    IngredientOptionsModal.show(
      context,
      ingredientName: ingredient.name,
      onEdit: () => _showEditModal(ingredient),
      onDelete: () => _showDeleteModal(ingredient),
    );
  }

  Future<void> _showEditModal(RecognizedIngredient ingredient) async {
    final newQuantity = await EditIngredientModal.show(
      context,
      ingredientName: ingredient.name,
      currentQuantity: ingredient.quantity,
      unit: ingredient.unit,
    );
    if (newQuantity == null || !mounted) return;

    final error = await ref
        .read(foodDetailProvider.notifier)
        .updateIngredientQuantity(
          ingredient.idDetailFoodIngredient,
          newQuantity,
        );
    if (error != null && mounted) {
      _showErrorSnackBar(error);
    } else {
      _markChanged();
    }
  }

  Future<void> _showDeleteModal(RecognizedIngredient ingredient) async {
    final confirmed = await DeleteIngredientModal.show(
      context,
      ingredientName: ingredient.name,
    );
    if (confirmed != true || !mounted) return;

    final error = await ref
        .read(foodDetailProvider.notifier)
        .deleteIngredient(ingredient.idDetailFoodIngredient);
    if (error != null && mounted) {
      _showErrorSnackBar(error);
    } else {
      _markChanged();
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusMd,
        ),
      ),
    );
  }

  // ── Analysis Error ─────────────────────────────────────────────

  Widget _buildAnalysisError(String message) {
    log('zineKey - $message');
    return AppErrorWidget(
      title: widget.isExistingFood
          ? 'Error al cargar comida'
          : 'Error al analizar comida',
      message: message,
      onRetry: () {
        if (widget.isExistingFood) {
          ref
              .read(foodDetailProvider.notifier)
              .loadExistingFood(widget.foodId!);
        } else {
          final uploadState = ref.read(foodImageUploadProvider);
          if (uploadState is FoodImageUploaded) {
            ref
                .read(foodDetailProvider.notifier)
                .recognizeFood(uploadState.imageUrl);
          }
        }
      },
    );
  }
}

class _SourceChip extends StatelessWidget {
  const _SourceChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.small.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
