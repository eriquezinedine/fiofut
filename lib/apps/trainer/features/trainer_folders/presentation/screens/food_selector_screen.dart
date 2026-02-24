import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:fio_fut/apps/admin/features/meals/domain/models/food.dart';
import 'package:fio_fut/apps/trainer/features/trainer_food/domain/providers/trainer_food_provider.dart';

class FoodSelectorScreen extends ConsumerStatefulWidget {
  const FoodSelectorScreen({super.key});

  @override
  ConsumerState<FoodSelectorScreen> createState() =>
      _FoodSelectorScreenState();
}

class _FoodSelectorScreenState extends ConsumerState<FoodSelectorScreen> {
  final _searchController = TextEditingController();
  final _selectedIds = <String>{};

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(trainerFoodProvider.notifier).loadAll();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final foodState = ref.watch(trainerFoodProvider);
    final allFoods = [...foodState.appFoods, ...foodState.myFoods];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.white),
        ),
        title: Text(
          'Seleccionar Comidas',
          style: AppTextStyles.h3.copyWith(color: AppColors.white),
        ),
        actions: [
          if (_selectedIds.isNotEmpty)
            TextButton(
              onPressed: () => Navigator.pop(context, _selectedIds.toList()),
              child: Text(
                'Agregar (${_selectedIds.length})',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.primary),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AppSearchField(
              controller: _searchController,
              hint: 'Buscar comidas...',
              onChanged: (query) {
                ref
                    .read(trainerFoodProvider.notifier)
                    .search(query, TrainerFoodTab.app);
              },
              onClear: () {
                _searchController.clear();
                ref.read(trainerFoodProvider.notifier).loadAll();
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: foodState.isLoading
                ? const Center(
                    child:
                        CircularProgressIndicator(color: AppColors.primary),
                  )
                : foodState.error != null
                    ? Center(
                        child: Text(
                          foodState.error!,
                          style: AppTextStyles.body
                              .copyWith(color: AppColors.error),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: allFoods.length,
                        itemBuilder: (context, index) {
                          final food = allFoods[index];
                          final isSelected = _selectedIds.contains(food.id);
                          return _SelectableFoodCard(
                            food: food,
                            isSelected: isSelected,
                            onToggle: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedIds.remove(food.id);
                                } else {
                                  _selectedIds.add(food.id);
                                }
                              });
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

class _SelectableFoodCard extends StatelessWidget {
  const _SelectableFoodCard({
    required this.food,
    required this.isSelected,
    required this.onToggle,
  });

  final Food food;
  final bool isSelected;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 1.5)
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                LucideIcons.utensilsCrossed,
                color: AppColors.textMuted,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${food.totalCalories.toStringAsFixed(0)} kcal · ${food.typeFood.displayName}',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? LucideIcons.checkCircle2
                  : LucideIcons.circle,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
