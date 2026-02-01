import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/features/home/domain/models/models.dart';
import 'package:flutter/material.dart';

import 'meal_item_card.dart';

/// Tabs widget for switching between meals and exercises using TabView.
class MealTabs extends StatefulWidget {
  const MealTabs({
    required this.mealItems,
    super.key,
  });

  final List<MealItem> mealItems;

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

  List<MealItem> get _meals =>
      widget.mealItems.where((item) => item.type == MealItemType.meal).toList();

  List<MealItem> get _exercises => widget.mealItems
      .where((item) => item.type == MealItemType.exercise)
      .toList();

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
              labelStyle: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
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
              // Meals tab
              _ItemsList(items: _meals),

              // Exercises tab
              _ItemsList(items: _exercises),
            ],
          ),
        ),
      ],
    );
  }
}

/// Items list widget for each tab.
class _ItemsList extends StatelessWidget {
  const _ItemsList({required this.items});

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
