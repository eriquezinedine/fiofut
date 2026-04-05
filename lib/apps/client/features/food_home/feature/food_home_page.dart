import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../core/widgets/widgets.dart';
import '../../home/domain/models/meal_item.dart';
import '../../home/presentation/widgets/meal_item_card.dart';
import '../../register_food/domain/providers/food_provider_detail.dart';
import '../../register_food/pages/food_detail_page.dart';
import '../../search_food/pages/search_food_page.dart';
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
      return Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: OutLineButton(
            label: 'Buscar alimento',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchFoodPage()),
            ),
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
            :final scheduleId,
            :final detail,
          ) =>
            _buildLoadedCard(context, ref, mealItem, foodId, scheduleId, detail),
          FoodHomeError(:final tempId, :final message) => FoodErrorCard(
              message: message,
              onRetry: () =>
                  ref.read(foodHomeProvider.notifier).retryItem(tempId),
            ),
        };
      },
    );
  }

  Widget _buildLoadedCard(
    BuildContext context,
    WidgetRef ref,
    MealItem mealItem,
    String foodId,
    String? scheduleId,
    FoodRecognitionResult? detail,
  ) {
    final card = MealItemCard(
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
    );

    if (scheduleId == null) return card;

    return Dismissible(
      key: ValueKey(scheduleId),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: AppColors.card,
            title: Text(
              'Eliminar comida',
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.white),
            ),
            content: Text(
              'Se eliminará "${mealItem.name}" de tu plan.',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(
                  'Cancelar',
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.textMuted),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(
                  'Eliminar',
                  style:
                      AppTextStyles.caption.copyWith(color: AppColors.error),
                ),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        ref.read(foodHomeProvider.notifier).deleteItem(scheduleId);
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          LucideIcons.trash2,
          color: AppColors.error,
          size: 24,
        ),
      ),
      child: card,
    );
  }
}
