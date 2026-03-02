/// A single ingredient within a daily meal, returned by the `get_daily_meals` RPC.
class DailyMealIngredient {
  const DailyMealIngredient({
    required this.id,
    required this.detailId,
    required this.name,
    required this.slug,
    required this.calories,
    required this.protein,
    required this.carbohydrates,
    required this.fat,
    required this.unit,
    required this.baseQuantity,
    required this.quantity,
    this.category,
  });

  final String id;
  final String detailId;
  final String name;
  final String slug;
  final double calories;
  final double protein;
  final double carbohydrates;
  final double fat;
  final String unit;
  final double baseQuantity;
  final double quantity;
  final String? category;

  factory DailyMealIngredient.fromJson(Map<String, dynamic> json) {
    return DailyMealIngredient(
      id: json['id'] as String? ?? '',
      detailId: json['detail_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      calories: (json['calories'] as num?)?.toDouble() ?? 0,
      protein: (json['protein'] as num?)?.toDouble() ?? 0,
      carbohydrates: (json['carbohydrates'] as num?)?.toDouble() ?? 0,
      fat: (json['fat'] as num?)?.toDouble() ?? 0,
      unit: json['unit'] as String? ?? 'grams',
      baseQuantity: (json['base_quantity'] as num?)?.toDouble() ?? 100,
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0,
      category: json['category'] as String?,
    );
  }
}

/// A meal item for a specific day, returned by the `get_daily_meals` RPC.
///
/// Includes full ingredient list and pre-calculated nutrition totals.
class DailyMealItem {
  const DailyMealItem({
    required this.scheduleId,
    required this.foodId,
    required this.title,
    required this.description,
    required this.typeFood,
    required this.imageUrl,
    required this.isCompleted,
    required this.createdAt,
    required this.ingredients,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    this.linkYoutube,
  });

  final String scheduleId;
  final String foodId;
  final String title;
  final String description;
  final String typeFood;
  final String imageUrl;
  final String? linkYoutube;
  final bool isCompleted;
  final DateTime createdAt;
  final List<DailyMealIngredient> ingredients;
  final double totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;

  String get typeFoodDisplay => switch (typeFood) {
        'breakfast' => 'Desayuno',
        'lunch' => 'Almuerzo',
        'dinner' => 'Cena',
        'snack' => 'Snack',
        _ => typeFood,
      };

  factory DailyMealItem.fromJson(Map<String, dynamic> json) {
    final ingredientsJson = json['ingredients'] as List<dynamic>? ?? [];

    return DailyMealItem(
      scheduleId: json['schedule_id'] as String? ?? '',
      foodId: json['food_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      typeFood: json['type_food'] as String? ?? 'snack',
      imageUrl: json['image_url'] as String? ?? '',
      linkYoutube: json['link_youtube'] as String?,
      isCompleted: json['is_completed'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
      ingredients: ingredientsJson
          .map((e) =>
              DailyMealIngredient.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCalories: (json['total_calories'] as num?)?.toDouble() ?? 0,
      totalProtein: (json['total_protein'] as num?)?.toDouble() ?? 0,
      totalCarbs: (json['total_carbs'] as num?)?.toDouble() ?? 0,
      totalFat: (json['total_fat'] as num?)?.toDouble() ?? 0,
    );
  }
}
