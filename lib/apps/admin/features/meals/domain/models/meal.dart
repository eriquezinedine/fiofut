import 'package:flutter/foundation.dart';

enum MealType {
  desayuno,
  almuerzo,
  cena,
  snack;

  String get displayName => switch (this) {
        desayuno => 'Desayuno',
        almuerzo => 'Almuerzo',
        cena => 'Cena',
        snack => 'Snack',
      };
}

@immutable
class Meal {
  const Meal({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.calories,
    required this.mealType,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final int calories;
  final MealType mealType;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      calories: json['calories'] as int? ?? 0,
      mealType: _parseMealType(json['meal_type'] as String),
      createdBy: json['created_by'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'calories': calories,
      'meal_type': mealType.name,
    };
  }

  Meal copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    int? calories,
    MealType? mealType,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Meal(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      calories: calories ?? this.calories,
      mealType: mealType ?? this.mealType,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static MealType _parseMealType(String value) {
    return MealType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => MealType.snack,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Meal && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
