import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../home/presentation/widgets/meal_item_card.dart';
import '../../register_food/pages/food_detail_page.dart';
import '../domain/models/food_home_item.dart';
import '../domain/providers/food_home_provider.dart';
import '../widgets/food_error_card.dart';
import '../widgets/food_loading_card.dart';

/// Food list widget for the "Alimentacion" tab.
/// Reads from [currentDateFoodItemsProvider] (real data by selected date).
class FoodHomePage extends ConsumerWidget {
  const FoodHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(currentDateFoodItemsProvider);

    if (items.isEmpty) {
      return Center(
        child: Text(
          'No hay elementos para mostrar',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: AppColors.textMuted,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = items[index];
        return switch (item) {
          FoodHomeLoading(:final imageFile) => FoodLoadingCard(
              imageFile: imageFile,
            ),
          FoodHomeLoaded(
            :final mealItem,
            :final foodId,
            :final detail,
          ) =>
            MealItemCard(
              mealItem: mealItem,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FoodDetailPage(
                      foodId: foodId,
                      imageUrl: mealItem.imageUrl,
                      initialResult: detail,
                    ),
                  ),
                );
              },
            ),
          FoodHomeError(:final tempId, :final message) => FoodErrorCard(
              message: message,
              onRetry: () =>
                  ref.read(foodHomeProvider.notifier).retryItem(tempId),
            ),
        };
      },
    );
  }
}
