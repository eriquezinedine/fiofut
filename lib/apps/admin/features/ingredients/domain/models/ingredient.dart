import 'package:flutter/foundation.dart';

enum IngredientUnit {
  grams,
  milliliters,
  units,
  tablespoons,
  teaspoons,
  cups;

  String get displayName => switch (this) {
        grams => 'Gramos',
        milliliters => 'Mililitros',
        units => 'Unidades',
        tablespoons => 'Cucharadas',
        teaspoons => 'Cucharaditas',
        cups => 'Tazas',
      };

  String get abbreviation => switch (this) {
        grams => 'g',
        milliliters => 'ml',
        units => 'uds',
        tablespoons => 'cda',
        teaspoons => 'cdta',
        cups => 'tz',
      };
}

@immutable
class Ingredient {
  const Ingredient({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbohydrates,
    required this.unit,
  });

  final String id;
  final String name;
  final double calories;
  final double protein;
  final double fat;
  final double carbohydrates;
  final IngredientUnit unit;

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'] as String,
      name: json['name'] as String,
      calories: (json['calories'] as num?)?.toDouble() ?? 0,
      protein: (json['protein'] as num?)?.toDouble() ?? 0,
      fat: (json['fat'] as num?)?.toDouble() ?? 0,
      carbohydrates: (json['carbohydrates'] as num?)?.toDouble() ?? 0,
      unit: _parseUnit(json['unit'] as String? ?? 'grams'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'carbohydrates': carbohydrates,
      'unit': unit.name,
    };
  }

  Ingredient copyWith({
    String? id,
    String? name,
    double? calories,
    double? protein,
    double? fat,
    double? carbohydrates,
    IngredientUnit? unit,
  }) {
    return Ingredient(
      id: id ?? this.id,
      name: name ?? this.name,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      carbohydrates: carbohydrates ?? this.carbohydrates,
      unit: unit ?? this.unit,
    );
  }

  static IngredientUnit _parseUnit(String value) {
    return IngredientUnit.values.firstWhere(
      (e) => e.name == value,
      orElse: () => IngredientUnit.grams,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Ingredient &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
