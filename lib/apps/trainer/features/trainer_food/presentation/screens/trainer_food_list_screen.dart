import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:fio_fut/apps/admin/features/meals/domain/models/food.dart';
import 'package:fio_fut/apps/admin/features/meals/domain/providers/food_provider.dart';
import 'package:fio_fut/apps/admin/features/meals/presentation/widgets/food_card.dart';
import 'package:fio_fut/apps/client/features/register_food/pages/food_detail_page.dart';

class TrainerFoodListScreen extends ConsumerStatefulWidget {
  const TrainerFoodListScreen({super.key});

  @override
  ConsumerState<TrainerFoodListScreen> createState() =>
      _TrainerFoodListScreenState();
}

class _TrainerFoodListScreenState
    extends ConsumerState<TrainerFoodListScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(foodProvider.notifier).loadFoods();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final foodState = ref.watch(foodProvider);

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
                    'Comidas',
                    style: AppTextStyles.h2.copyWith(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
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
                hint: 'Buscar comidas...',
                onChanged: (query) {
                  ref.read(foodProvider.notifier).searchFoods(query);
                },
                onClear: () {
                  _searchController.clear();
                  ref.read(foodProvider.notifier).loadFoods();
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: switch (foodState) {
                FoodInitial() ||
                FoodLoading() =>
                  const Center(
                    child:
                        CircularProgressIndicator(color: AppColors.primary),
                  ),
                FoodError(:final message) => Center(
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
                FoodLoaded(:final foods) => foods.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(LucideIcons.utensilsCrossed,
                                color: AppColors.textMuted, size: 56),
                            const SizedBox(height: 16),
                            Text(
                              'No hay comidas',
                              style: AppTextStyles.h3
                                  .copyWith(color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Aun no se han registrado comidas',
                              style: AppTextStyles.caption
                                  .copyWith(color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        color: AppColors.primary,
                        backgroundColor: AppColors.card,
                        onRefresh: () =>
                            ref.read(foodProvider.notifier).loadFoods(),
                        child: ListView.builder(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: foods.length,
                          itemBuilder: (context, index) {
                            final food = foods[index];
                            return FoodCard(
                              food: food,
                              onTap: () => _openFoodDetail(food),
                              onDelete: () =>
                                  _confirmDelete(context, food.id),
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

  void _openFoodDetail(Food food) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FoodDetailPage(foodId: food.id),
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
          'Eliminar comida',
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
              ref.read(foodProvider.notifier).deleteFood(id);
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
