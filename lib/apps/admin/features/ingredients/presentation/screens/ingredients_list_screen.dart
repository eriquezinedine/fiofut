import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart' as router;
import 'package:lucide_icons/lucide_icons.dart';

import '../../domain/providers/ingredients_provider.dart';
import '../widgets/ingredient_card.dart';
import 'ingredient_form_screen.dart';

class IngredientsListScreen extends ConsumerStatefulWidget {
  const IngredientsListScreen({super.key});

  @override
  ConsumerState<IngredientsListScreen> createState() =>
      _IngredientsListScreenState();
}

class _IngredientsListScreenState
    extends ConsumerState<IngredientsListScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(ingredientsProvider.notifier).loadIngredients();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ingredientsState = ref.watch(ingredientsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Row(
                children: [
                  Text(
                    'Ingredientes',
                    style: AppTextStyles.h2.copyWith(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => router.GoRouter.of(context)
                        .push(IngredientFormScreen.pathNew),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        LucideIcons.plus,
                        color: AppColors.black,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AppSearchField(
                controller: _searchController,
                hint: 'Buscar ingredientes...',
                onChanged: (query) {
                  ref
                      .read(ingredientsProvider.notifier)
                      .searchIngredients(query);
                },
                onClear: () {
                  _searchController.clear();
                  ref.read(ingredientsProvider.notifier).loadIngredients();
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: switch (ingredientsState) {
                IngredientsInitial() ||
                IngredientsLoading() =>
                  const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primary),
                  ),
                IngredientsError(:final message) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(LucideIcons.alertTriangle,
                            color: AppColors.error, size: 48),
                        const SizedBox(height: 12),
                        Text(
                          message,
                          style: AppTextStyles.body
                              .copyWith(color: AppColors.error),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                IngredientsLoaded(:final ingredients) => ingredients.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(LucideIcons.egg,
                                color: AppColors.textMuted, size: 56),
                            const SizedBox(height: 16),
                            Text(
                              'No hay ingredientes',
                              style: AppTextStyles.h3
                                  .copyWith(color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Agrega tu primer ingrediente',
                              style: AppTextStyles.caption
                                  .copyWith(color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        color: AppColors.primary,
                        backgroundColor: AppColors.card,
                        onRefresh: () => ref
                            .read(ingredientsProvider.notifier)
                            .loadIngredients(),
                        child: ListView.builder(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: ingredients.length,
                          itemBuilder: (context, index) {
                            final ingredient = ingredients[index];
                            return IngredientCard(
                              ingredient: ingredient,
                              onTap: () => router.GoRouter.of(context)
                                  .push('/admin/ingredients/${ingredient.id}'),
                              onDelete: () =>
                                  _confirmDelete(context, ingredient.id),
                            );
                          },
                        ),
                      ),
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Eliminar ingrediente',
          style: AppTextStyles.h3.copyWith(color: AppColors.white),
        ),
        content: Text(
          'Esta accion no se puede deshacer.',
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancelar',
              style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(ingredientsProvider.notifier).deleteIngredient(id);
            },
            child: Text(
              'Eliminar',
              style: AppTextStyles.body.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
