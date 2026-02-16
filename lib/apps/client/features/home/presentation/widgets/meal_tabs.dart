import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_home/exercise_home.dart';
import 'package:fio_fut/apps/client/features/food_home/feature/food_home_page.dart';
import 'package:fio_fut/apps/client/features/home/domain/models/models.dart';
import 'package:flutter/material.dart';

import 'meal_item_card.dart';

/// Tabs widget for switching between meals and exercises using TabView.
class MealTabs extends StatefulWidget {
  const MealTabs({
    required this.exerciseItems,
    super.key,
  });

  final List<MealItem> exerciseItems;

  @override
  State<MealTabs> createState() => _MealTabsState();
}

class _MealTabsState extends State<MealTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Custom styled TabBar
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Container(
            height: 48,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: AppColors.black,
              unselectedLabelColor: AppColors.textMuted,
              labelStyle: AppTextStyles.titleSmall,
              unselectedLabelStyle: AppTextStyles.labelLarge,
              tabs: const [
                Tab(text: 'Alimentación'),
                Tab(text: 'Ejercicios'),
              ],
            ),
          ),
        ),

        // TabBarView with content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Meals tab - now reads from provider
              const FoodHomePage(),

              // Exercises tab
              const ExerciseHomePage()
              // _ItemsList(items: widget.exerciseItems),
            ],
          ),
        ),
      ],
    );
  }
}

class _ItemsList extends StatelessWidget {
  const _ItemsList({required this.items});

  final List<MealItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          'No hay elementos para mostrar',
          style: AppTextStyles.caption.copyWith(
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
