import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'food_provider.dart';

// ── Models ──────────────────────────────────────────────────────

class RecognizedIngredient {
  const RecognizedIngredient({
    required this.id,
    required this.idDetailFoodIngredient,
    required this.name,
    required this.slug,
    required this.calories,
    required this.fat,
    required this.carbohydrates,
    required this.protein,
    required this.unit,
    required this.baseQuantity,
    required this.quantity,
    this.category,
  });

  final String id;
  final String idDetailFoodIngredient;
  final String name;
  final String slug;
  final double calories;
  final double fat;
  final double carbohydrates;
  final double protein;
  final String unit;
  final double baseQuantity;
  final double quantity;
  final String? category;

  double get totalCalories => (calories * quantity) / baseQuantity;
  double get totalProtein => (protein * quantity) / baseQuantity;
  double get totalCarbohydrates => (carbohydrates * quantity) / baseQuantity;
  double get totalFat => (fat * quantity) / baseQuantity;

  String get unitAbbreviation => switch (unit) {
        'grams' => 'g',
        'milliliters' => 'ml',
        'units' => 'uds',
        _ => unit,
      };

  RecognizedIngredient copyWith({double? quantity}) {
    return RecognizedIngredient(
      id: id,
      idDetailFoodIngredient: idDetailFoodIngredient,
      name: name,
      slug: slug,
      calories: calories,
      fat: fat,
      carbohydrates: carbohydrates,
      protein: protein,
      unit: unit,
      baseQuantity: baseQuantity,
      quantity: quantity ?? this.quantity,
      category: category,
    );
  }

  factory RecognizedIngredient.fromJson(Map<String, dynamic> json) {
    return RecognizedIngredient(
      id: json['id'] as String,
      idDetailFoodIngredient:
          json['id_detail_food_ingredient'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      calories: (json['calories'] as num?)?.toDouble() ?? 0,
      fat: (json['fat'] as num?)?.toDouble() ?? 0,
      carbohydrates: (json['carbohydrates'] as num?)?.toDouble() ?? 0,
      protein: (json['protein'] as num?)?.toDouble() ?? 0,
      unit: json['unit'] as String? ?? 'grams',
      baseQuantity: (json['base_quantity'] as num?)?.toDouble() ?? 100,
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0,
      category: json['category'] as String?,
    );
  }
}

class FoodRecognitionResult {
  const FoodRecognitionResult({
    required this.id,
    required this.title,
    required this.description,
    required this.typeFood,
    required this.imageUrl,
    required this.ingredients,
  });

  final String id;
  final String title;
  final String description;
  final String typeFood;
  final String imageUrl;
  final List<RecognizedIngredient> ingredients;

  double get totalCalories =>
      ingredients.fold(0, (sum, i) => sum + i.totalCalories);
  double get totalProtein =>
      ingredients.fold(0, (sum, i) => sum + i.totalProtein);
  double get totalCarbohydrates =>
      ingredients.fold(0, (sum, i) => sum + i.totalCarbohydrates);
  double get totalFat => ingredients.fold(0, (sum, i) => sum + i.totalFat);

  FoodRecognitionResult copyWith({List<RecognizedIngredient>? ingredients}) {
    return FoodRecognitionResult(
      id: id,
      title: title,
      description: description,
      typeFood: typeFood,
      imageUrl: imageUrl,
      ingredients: ingredients ?? this.ingredients,
    );
  }

  String get typeFoodDisplay => switch (typeFood) {
        'breakfast' => 'Desayuno',
        'lunch' => 'Almuerzo',
        'dinner' => 'Cena',
        'snack' => 'Snack',
        _ => typeFood,
      };

  factory FoodRecognitionResult.fromJson(Map<String, dynamic> json) {
    final foodJson = json['food'] as Map<String, dynamic>;
    final ingredientsJson = foodJson['ingredients'] as List<dynamic>? ?? [];

    return FoodRecognitionResult(
      id: foodJson['id'] as String,
      title: foodJson['title'] as String? ?? '',
      description: foodJson['description'] as String? ?? '',
      typeFood: foodJson['type_food'] as String? ?? 'snack',
      imageUrl: foodJson['image_url'] as String? ?? '',
      ingredients: ingredientsJson
          .map((e) => RecognizedIngredient.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

// ── State ───────────────────────────────────────────────────────

sealed class FoodDetailState {
  const FoodDetailState();
}

class FoodDetailInitial extends FoodDetailState {
  const FoodDetailInitial();
}

class FoodDetailAnalyzing extends FoodDetailState {
  const FoodDetailAnalyzing();
}

class FoodDetailLoaded extends FoodDetailState {
  const FoodDetailLoaded({required this.result});
  final FoodRecognitionResult result;
}

class FoodDetailError extends FoodDetailState {
  const FoodDetailError({required this.message});
  final String message;
}

// ── Provider ────────────────────────────────────────────────────

final foodDetailProvider =
    NotifierProvider<FoodDetailNotifier, FoodDetailState>(
  FoodDetailNotifier.new,
);

class FoodDetailNotifier extends Notifier<FoodDetailState> {
  @override
  FoodDetailState build() {
    ref.listen(foodImageUploadProvider, (prev, next) {
      if (next is FoodImageUploaded) {
        recognizeFood(next.imageUrl);
      }
    });

    // Handle case where upload already completed before this provider
    final upload = ref.read(foodImageUploadProvider);
    if (upload is FoodImageUploaded) {
      Future.microtask(() => recognizeFood(upload.imageUrl));
    }

    return const FoodDetailInitial();
  }

  Future<void> recognizeFood(String imageUrl) async {
    state = const FoodDetailAnalyzing();
    try {
      final supabase = Supabase.instance.client;
      final accessToken = supabase.auth.currentSession?.accessToken;
      if (accessToken == null) {
        developer.log('zineKey - No hay sesion activa', name: 'FoodDetail');
        throw Exception('No hay sesion activa');
      }

      developer.log('zineKey - Calling gemini function', name: 'FoodDetail');

      final response = await supabase.functions.invoke(
        'gemini',
        body: {'action': 'recognize-food', 'image_url': imageUrl},
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      final data = response.data as Map<String, dynamic>;

      developer.log('zineKey - Response: $data', name: 'FoodDetail');

      if (data['success'] != true) {
        throw Exception(data['error'] as String? ?? 'Error desconocido');
      }

      state = FoodDetailLoaded(
        result: FoodRecognitionResult.fromJson(data),
      );
    } catch (e) {
      developer.log('zineKey - $e', name: 'FoodDetail');
      state = FoodDetailError(
        message: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Elimina un ingrediente del detalle (optimistic update).
  /// Retorna un mensaje de error si falla, o `null` si OK.
  Future<String?> deleteIngredient(String idDetailFoodIngredient) async {
    final current = state;
    if (current is! FoodDetailLoaded) return null;

    // Guardar estado previo
    final previousResult = current.result;

    // Actualizar estado inmediatamente
    final updatedIngredients = previousResult.ingredients
        .where((i) => i.idDetailFoodIngredient != idDetailFoodIngredient)
        .toList();
    state = FoodDetailLoaded(
      result: previousResult.copyWith(ingredients: updatedIngredients),
    );

    // Actualizar DB en background
    try {
      final supabase = Supabase.instance.client;
      await supabase
          .from('detail_food_ingredient')
          .delete()
          .eq('id', idDetailFoodIngredient);
      developer.log('zineKey - Ingrediente eliminado: $idDetailFoodIngredient',
          name: 'FoodDetail');
      return null;
    } catch (e) {
      developer.log('zineKey - Error al eliminar: $e', name: 'FoodDetail');
      // Restaurar estado previo
      state = FoodDetailLoaded(result: previousResult);
      return 'No se pudo eliminar el ingrediente';
    }
  }

  /// Actualiza la cantidad de un ingrediente (optimistic update).
  /// Retorna un mensaje de error si falla, o `null` si OK.
  Future<String?> updateIngredientQuantity(
    String idDetailFoodIngredient,
    double newQuantity,
  ) async {
    final current = state;
    if (current is! FoodDetailLoaded) return null;

    // Guardar estado previo
    final previousResult = current.result;

    // Actualizar estado inmediatamente
    final updatedIngredients = previousResult.ingredients.map((i) {
      if (i.idDetailFoodIngredient == idDetailFoodIngredient) {
        return i.copyWith(quantity: newQuantity);
      }
      return i;
    }).toList();
    state = FoodDetailLoaded(
      result: previousResult.copyWith(ingredients: updatedIngredients),
    );

    // Actualizar DB en background
    try {
      final supabase = Supabase.instance.client;
      await supabase
          .from('detail_food_ingredient')
          .update({'quantity': newQuantity})
          .eq('id', idDetailFoodIngredient);
      developer.log(
          'zineKey - Cantidad actualizada: $idDetailFoodIngredient -> $newQuantity',
          name: 'FoodDetail');
      return null;
    } catch (e) {
      developer.log('zineKey - Error al actualizar: $e', name: 'FoodDetail');
      // Restaurar estado previo
      state = FoodDetailLoaded(result: previousResult);
      return 'No se pudo actualizar la cantidad';
    }
  }

  void reset() => state = const FoodDetailInitial();
}
