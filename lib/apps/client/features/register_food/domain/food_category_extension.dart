import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

extension FoodCategoryX on String? {
  IconData get categoryIcon => switch (this) {
        'vegetables' => LucideIcons.leaf,
        'meat' => LucideIcons.beef,
        'fruits' => LucideIcons.apple,
        'fish_seafood' => LucideIcons.fish,
        'grains_cereals' => LucideIcons.wheat,
        'oils_fats' => LucideIcons.droplet,
        _ => LucideIcons.utensilsCrossed,
      };

  Color get categoryColor => switch (this) {
        'vegetables' => AppColors.green,
        'meat' => AppColors.red,
        'dairy' => AppColors.blue,
        'fruits' => AppColors.orange,
        'fish_seafood' => AppColors.teal,
        'grains_cereals' => AppColors.warning,
        'legumes' => AppColors.green,
        'nuts_seeds' => AppColors.orange,
        'oils_fats' => AppColors.warning,
        'spices_herbs' => AppColors.purple,
        'eggs' => AppColors.orange,
        'beverages' => AppColors.info,
        'sauces_condiments' => AppColors.red,
        'sweets_sugars' => AppColors.pink,
        'processed' => AppColors.textMuted,
        _ => AppColors.primary,
      };
}
