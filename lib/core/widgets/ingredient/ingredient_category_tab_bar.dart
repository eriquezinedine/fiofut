import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

import '../../../apps/client/features/onboarding/domain/models/ingredient_category.dart';

class IngredientCategoryTabBar extends StatelessWidget {
  const IngredientCategoryTabBar({
    super.key,
    required this.tabController,
  });

  final TabController tabController;

  static final tabNames = <Object>[
    'Todos',
    ...IngredientCategory.values,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        padding: const EdgeInsets.all(4),
        labelPadding: const EdgeInsets.symmetric(horizontal: 4),
        indicator: BoxDecoration(
          color: AppColors.green,
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: AppColors.transparent,
        labelColor: AppColors.black,
        unselectedLabelColor: AppColors.white,
        labelStyle: AppTextStyles.labelMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextStyles.labelMedium.copyWith(
          fontWeight: FontWeight.w500,
        ),
        tabs: tabNames.map((tab) {
          final label =
              tab is IngredientCategory ? tab.displayName : tab as String;
          return Tab(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(label),
            ),
          );
        }).toList(),
      ),
    );
  }
}
