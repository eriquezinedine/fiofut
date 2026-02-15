
import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/home/domain/models/meal_item.dart';
import 'package:flutter/material.dart';

import '../../home/presentation/widgets/meal_item_card.dart';

/// Items list widget for each tab.
class FoodHomePage extends StatelessWidget {
  const FoodHomePage({super.key, required this.items});

  final List<MealItem> items;

  @override
  Widget build(BuildContext context) {
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
        return MealItemCard(mealItem: items[index]);
      },
    );
  }
}