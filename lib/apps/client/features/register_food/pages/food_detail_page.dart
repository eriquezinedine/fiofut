import 'dart:developer';
import 'dart:io';

import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/food_home/domain/providers/food_home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../core/widgets/modal/delete_ingredient_modal.dart';
import '../../../../../core/widgets/modal/edit_ingredient_modal.dart';
import '../../../../../core/widgets/modal/ingredient_options_modal.dart';
import '../domain/providers/food_provider.dart';
import '../domain/providers/food_provider_detail.dart';
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
        // Data already available — no fetch needed.
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
                _buildImageSection(uploadState),
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
              child: _buildSaveButton(detailState),
            ),
        ],
      ),
    );
  }

  // ── Image Section ─────────────────────────────────────────────

  Widget _buildImageSection(FoodImageUploadState uploadState) {
    return ClipRRect(
      borderRadius: AppSpacing.borderRadiusXl,
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: widget.isExistingFood
            ? Image.network(
                widget.imageUrl ?? '',
                fit: BoxFit.cover,
                loadingBuilder: (_, child, progress) {
                  if (progress == null) return child;
                  return _buildImageShimmer();
                },
                errorBuilder: (_, __, ___) => _buildImageError(),
              )
            : switch (uploadState) {
                FoodImageUploadInitial() ||
                FoodImageUploading() =>
                  _buildImageShimmer(),
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
    return AppShimmer(child: Container(color: AppColors.grey800));
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

  Widget _buildInfoSection(
    FoodImageUploadState uploadState,
    FoodDetailState detailState,
  ) {
    // Existing food: skip upload state checks entirely.
    if (widget.isExistingFood) {
      return switch (detailState) {
        FoodDetailInitial() || FoodDetailAnalyzing() =>
          _buildContentShimmer(),
        FoodDetailLoaded(:final result) => _buildFoodDetail(result),
        FoodDetailError(:final message) => _buildAnalysisError(message),
      };
    }

    if (uploadState is FoodImageUploadInitial ||
        uploadState is FoodImageUploading) {
      return _buildContentShimmer();
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
      FoodDetailInitial() || FoodDetailAnalyzing() => _buildAnalyzingState(),
      FoodDetailLoaded(:final result) => _buildFoodDetail(result),
      FoodDetailError(:final message) => _buildAnalysisError(message),
    };
  }

  // ── Analyzing State ───────────────────────────────────────────

  Widget _buildAnalyzingState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status indicator
        Container(
          width: double.infinity,
          padding: AppSpacing.cardPadding,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: AppSpacing.borderRadiusLg,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Analizando tu comida con IA...',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        // Content shimmer
        _buildContentShimmer(),
      ],
    );
  }

  Widget _buildContentShimmer() {
    return AppShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppShimmerBox(width: 220, height: 24),
          const SizedBox(height: AppSpacing.xs),
          const AppShimmerBox(width: 80, height: 22),
          const SizedBox(height: AppSpacing.sm),
          const AppShimmerBox(width: double.infinity, height: 16),
          const SizedBox(height: AppSpacing.xs),
          const AppShimmerBox(width: 260, height: 16),
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
                const AppShimmerBox(width: 160, height: 20),
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
          const SizedBox(height: AppSpacing.lg),
          // Ingredients shimmer
          const AppShimmerBox(width: 140, height: 20),
          const SizedBox(height: AppSpacing.sm),
          ...List.generate(3, (_) => _buildIngredientShimmer()),
        ],
      ),
    );
  }

  Widget _buildNutrientShimmer() {
    return const Column(
      children: [
        AppShimmerBox(
          width: 48,
          height: 48,
          borderRadius:
              BorderRadius.all(Radius.circular(AppSpacing.radiusMd)),
        ),
        SizedBox(height: AppSpacing.xs),
        AppShimmerBox(width: 40, height: 14),
        SizedBox(height: AppSpacing.xxxs),
        AppShimmerBox(width: 48, height: 12),
      ],
    );
  }

  Widget _buildIngredientShimmer() {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: AppSpacing.borderRadiusMd,
        ),
        child: const Row(
          children: [
            AppShimmerBox(
              width: 36,
              height: 36,
              borderRadius:
                  BorderRadius.all(Radius.circular(AppSpacing.radiusSm)),
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppShimmerBox(width: 140, height: 14),
                  SizedBox(height: 6),
                  AppShimmerBox(width: 200, height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Food Detail (Loaded) ──────────────────────────────────────

  Widget _buildFoodDetail(FoodRecognitionResult result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title + type tag
        Text(result.title, style: AppTextStyles.h3),
        const SizedBox(height: AppSpacing.xs),
        _FoodTypeTag(typeFood: result.typeFood, label: result.typeFoodDisplay),
        if (result.description.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            result.description,
            style:
                AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),

        // Nutrition summary card
        _buildNutritionCard(result),
        const SizedBox(height: AppSpacing.lg),

        // Ingredients section
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
        ...result.ingredients.map(_buildIngredientItem),
      ],
    );
  }

  Widget _buildNutritionCard(FoodRecognitionResult result) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppSpacing.borderRadiusXl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumen nutricional',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _NutrientBox(
                icon: LucideIcons.flame,
                value: result.totalCalories.toStringAsFixed(0),
                label: 'kcal',
                color: AppColors.orange,
              ),
              const SizedBox(width: AppSpacing.sm),
              _NutrientBox(
                icon: LucideIcons.beef,
                value: '${result.totalProtein.toStringAsFixed(1)}g',
                label: 'Proteina',
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.sm),
              _NutrientBox(
                icon: LucideIcons.wheat,
                value: '${result.totalCarbohydrates.toStringAsFixed(1)}g',
                label: 'Carbos',
                color: AppColors.info,
              ),
              const SizedBox(width: AppSpacing.sm),
              _NutrientBox(
                icon: LucideIcons.droplet,
                value: '${result.totalFat.toStringAsFixed(1)}g',
                label: 'Grasas',
                color: AppColors.warning,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientItem(RecognizedIngredient ingredient) {
    final color = _categoryColor(ingredient.category);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: GestureDetector(
        onTap: () => _showIngredientOptions(ingredient),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: AppSpacing.borderRadiusMd,
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: AppSpacing.borderRadiusSm,
                ),
                child: Icon(
                  _categoryIcon(ingredient.category),
                  color: color,
                  size: 18,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            ingredient.name,
                            style:
                                AppTextStyles.bodyMedium.copyWith(fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '${ingredient.quantity.toStringAsFixed(0)} ${ingredient.unitAbbreviation}',
                          style: AppTextStyles.small.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _MiniChip(
                          text:
                              '${ingredient.totalCalories.toStringAsFixed(0)} kcal',
                          color: AppColors.orange,
                        ),
                        const SizedBox(width: 6),
                        _MiniChip(
                          text:
                              '${ingredient.totalProtein.toStringAsFixed(1)}g P',
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 6),
                        _MiniChip(
                          text:
                              '${ingredient.totalCarbohydrates.toStringAsFixed(1)}g C',
                          color: AppColors.info,
                        ),
                        const SizedBox(width: 6),
                        _MiniChip(
                          text: '${ingredient.totalFat.toStringAsFixed(1)}g G',
                          color: AppColors.warning,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Save Button ────────────────────────────────────────────────

  Widget _buildSaveButton(FoodDetailState detailState) {
    return GestureDetector(
      onTap: () => _saveChanges(detailState),
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

  // ── Modal Flow ─────────────────────────────────────────────────

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

  // ── Analysis Error ────────────────────────────────────────────

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

  // ── Helpers ───────────────────────────────────────────────────

  static IconData _categoryIcon(String? category) => switch (category) {
        'vegetables' => LucideIcons.leaf,
        'meat' => LucideIcons.beef,
        'fruits' => LucideIcons.apple,
        'fish_seafood' => LucideIcons.fish,
        'grains_cereals' => LucideIcons.wheat,
        'oils_fats' => LucideIcons.droplet,
        _ => LucideIcons.utensilsCrossed,
      };

  static Color _categoryColor(String? category) => switch (category) {
        'vegetables' => AppColors.green,
        'meat' => AppColors.red,
        'dairy' => AppColors.blue,
        'fruits' => AppColors.orange,
        'fish_seafood' => AppColors.teal,
        'grains_cereals' => AppColors.warning,
        'legumes' => AppColors.green,
        'nuts_seeds' => AppColors.orange,
        'oils_fats' => AppColors.warning,
        'spices_herbs' => AppColors.purple,
        'eggs' => AppColors.orange,
        'beverages' => AppColors.info,
        'sauces_condiments' => AppColors.red,
        'sweets_sugars' => AppColors.pink,
        'processed' => AppColors.textMuted,
        _ => AppColors.primary,
      };
}

// ── Private Widgets ─────────────────────────────────────────────

class _FoodTypeTag extends StatelessWidget {
  const _FoodTypeTag({required this.typeFood, required this.label});

  final String typeFood;
  final String label;

  Color get _color => switch (typeFood) {
        'breakfast' => AppColors.orange,
        'lunch' => AppColors.primary,
        'dinner' => AppColors.purple,
        'snack' => AppColors.info,
        _ => AppColors.primary,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _color,
        ),
      ),
    );
  }
}

class _NutrientBox extends StatelessWidget {
  const _NutrientBox({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: AppSpacing.borderRadiusMd,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xxxs),
          Text(
            label,
            style:
                AppTextStyles.small.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  const _MiniChip({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
