import 'dart:io';

import 'package:fio_fut/apps/client/features/home/domain/models/meal_item.dart';
import 'package:fio_fut/apps/client/features/register_food/domain/providers/food_provider_detail.dart';

sealed class FoodHomeItem {
  const FoodHomeItem();
}

class FoodHomeLoading extends FoodHomeItem {
  const FoodHomeLoading({
    required this.tempId,
    required this.imageFile,
  });

  final String tempId;
  final File imageFile;
}

class FoodHomeLoaded extends FoodHomeItem {
  const FoodHomeLoaded({
    required this.mealItem,
    required this.foodId,
    this.scheduleId,
    this.detail,
  });

  final MealItem mealItem;
  final String foodId;

  /// The food_schedule row id. Needed for delete/update operations.
  final String? scheduleId;

  /// Full detail for FoodDetailPage. Available when loaded from network.
  /// Null when loaded from Isar cache (will fetch on tap).
  final FoodRecognitionResult? detail;
}

class FoodHomeError extends FoodHomeItem {
  const FoodHomeError({
    required this.tempId,
    required this.imageFile,
    required this.message,
  });

  final String tempId;
  final File imageFile;
  final String message;
}
