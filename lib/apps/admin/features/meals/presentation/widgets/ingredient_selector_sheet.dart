import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../ingredients/data/repositories/ingredients_repository.dart';
import '../../../ingredients/domain/models/ingredient.dart';
import 'ingredient_quantity_sheet.dart';

class IngredientSelectorSheet extends ConsumerStatefulWidget {
  const IngredientSelectorSheet({
    required this.onIngredientSelected,
    required this.onCreateIngredient,
    super.key,
  });

  final void Function(Ingredient ingredient, double quantity)
      onIngredientSelected;
  final VoidCallback onCreateIngredient;

  @override
  ConsumerState<IngredientSelectorSheet> createState() =>
      _IngredientSelectorSheetState();
}

class _IngredientSelectorSheetState
    extends ConsumerState<IngredientSelectorSheet> {
  final _searchController = TextEditingController();
  List<Ingredient> _ingredients = [];
  List<Ingredient> _filtered = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadIngredients();
  }

  Future<void> _loadIngredients() async {
    try {
      final repo = ref.read(ingredientsRepositoryProvider);
      final ingredients = await repo.getIngredients();
      if (mounted) {
        setState(() {
          _ingredients = ingredients;
          _filtered = ingredients;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _filter(String query) {
    setState(() {
      if (query.isEmpty) {
        _filtered = _ingredients;
      } else {
        _filtered = _ingredients
            .where((i) =>
                i.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  'Seleccionar Ingrediente',
                  style: AppTextStyles.h3.copyWith(color: AppColors.white),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: widget.onCreateIngredient,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(LucideIcons.plus,
                            color: AppColors.primary, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          'Nuevo',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AppSearchField(
              controller: _searchController,
              hint: 'Buscar ingrediente...',
              onChanged: _filter,
              onClear: () {
                _searchController.clear();
                _filter('');
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primary),
                  )
                : _filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(LucideIcons.searchX,
                                color: AppColors.textMuted, size: 40),
                            const SizedBox(height: 12),
                            Text(
                              'No se encontraron ingredientes',
                              style: AppTextStyles.caption
                                  .copyWith(color: AppColors.textMuted),
                            ),
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: widget.onCreateIngredient,
                              child: Text(
                                'Crear uno nuevo',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _filtered.length,
                        itemBuilder: (context, index) {
                          final ingredient = _filtered[index];
                          return _IngredientTile(
                            ingredient: ingredient,
                            onTap: () async {
                              final navigator = Navigator.of(context);
                              final qty =
                                  await IngredientQuantitySheet.show(
                                context,
                                ingredient: ingredient,
                              );
                              if (qty != null && mounted) {
                                navigator.pop();
                                widget.onIngredientSelected(ingredient, qty);
                              }
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _IngredientTile extends StatelessWidget {
  const _IngredientTile({
    required this.ingredient,
    required this.onTap,
  });

  final Ingredient ingredient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ingredient.name,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${ingredient.calories.toStringAsFixed(0)} kcal | '
                    '${ingredient.protein.toStringAsFixed(0)}g P | '
                    '${ingredient.carbohydrates.toStringAsFixed(0)}g C | '
                    '${ingredient.fat.toStringAsFixed(0)}g G',
                    style: AppTextStyles.small
                        .copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            const Icon(
              LucideIcons.plus,
              color: AppColors.primary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
