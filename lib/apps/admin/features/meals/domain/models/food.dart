import 'package:flutter/foundation.dart';

import '../../../ingredients/domain/models/ingredient.dart';

enum FoodType {
  breakfast,
  lunch,
  dinner,
  snack;

  String get displayName => switch (this) {
        breakfast => 'Desayuno',
        lunch => 'Almuerzo',
        dinner => 'Cena',
        snack => 'Snack',
      };
}

@immutable
class SelectedIngredient {
  const SelectedIngredient({
    required this.ingredient,
    required this.quantity,
  });

  final Ingredient ingredient;
  final double quantity;

  double get calories =>
      (ingredient.calories * quantity) / 100;
  double get protein =>
      (ingredient.protein * quantity) / 100;
  double get carbohydrates =>
      (ingredient.carbohydrates * quantity) / 100;
  double get fat =>
      (ingredient.fat * quantity) / 100;

  SelectedIngredient copyWith({
    Ingredient? ingredient,
    double? quantity,
  }) {
    return SelectedIngredient(
      ingredient: ingredient ?? this.ingredient,
      quantity: quantity ?? this.quantity,
    );
  }
}

@immutable
class Food {
  const Food({
    required this.id,
    required this.title,
    required this.typeFood,
    this.description,
    this.createdAt,
    this.ingredients = const [],
  });

  final String id;
  final String title;
  final FoodType typeFood;
  final String? description;
  final DateTime? createdAt;
  final List<SelectedIngredient> ingredients;

  double get totalCalories =>
      ingredients.fold(0, (sum, i) => sum + i.calories);
  double get totalProtein =>
      ingredients.fold(0, (sum, i) => sum + i.protein);
  double get totalCarbohydrates =>
      ingredients.fold(0, (sum, i) => sum + i.carbohydrates);
  double get totalFat =>
      ingredients.fold(0, (sum, i) => sum + i.fat);

  factory Food.fromJson(Map<String, dynamic> json,
      {List<SelectedIngredient> ingredients = const []}) {
    return Food(
      id: json['id'] as String,
      title: json['title'] as String,
      typeFood: _parseFoodType(json['type_food'] as String),
      description: json['description'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      ingredients: ingredients,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type_food': typeFood.name,
      'description': description,
    };
  }

  Food copyWith({
    String? id,
    String? title,
    FoodType? typeFood,
    String? description,
    DateTime? createdAt,
    List<SelectedIngredient>? ingredients,
  }) {
    return Food(
      id: id ?? this.id,
      title: title ?? this.title,
      typeFood: typeFood ?? this.typeFood,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      ingredients: ingredients ?? this.ingredients,
    );
  }

  static FoodType _parseFoodType(String value) {
    return FoodType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => FoodType.snack,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Food && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
