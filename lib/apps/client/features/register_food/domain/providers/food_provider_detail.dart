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
    this.linkYoutube,
    this.linkTiktok,
    this.linkInstagram,
  });

  final String id;
  final String title;
  final String description;
  final String typeFood;
  final String imageUrl;
  final List<RecognizedIngredient> ingredients;
  final String? linkYoutube;
  final String? linkTiktok;
  final String? linkInstagram;

  double get totalCalories =>
      ingredients.fold(0, (sum, i) => sum + i.totalCalories);
  double get totalProtein =>
      ingredients.fold(0, (sum, i) => sum + i.totalProtein);
  double get totalCarbohydrates =>
      ingredients.fold(0, (sum, i) => sum + i.totalCarbohydrates);
  double get totalFat => ingredients.fold(0, (sum, i) => sum + i.totalFat);

  FoodRecognitionResult copyWith({
    List<RecognizedIngredient>? ingredients,
    String? linkYoutube,
    String? linkTiktok,
    String? linkInstagram,
  }) {
    return FoodRecognitionResult(
      id: id,
      title: title,
      description: description,
      typeFood: typeFood,
      imageUrl: imageUrl,
      ingredients: ingredients ?? this.ingredients,
      linkYoutube: linkYoutube ?? this.linkYoutube,
      linkTiktok: linkTiktok ?? this.linkTiktok,
      linkInstagram: linkInstagram ?? this.linkInstagram,
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
      linkYoutube: foodJson['link_youtube'] as String?,
      linkTiktok: foodJson['link_tiktok'] as String?,
      linkInstagram: foodJson['link_instagram'] as String?,
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
    AutoDisposeNotifierProvider<FoodDetailNotifier, FoodDetailState>(
  FoodDetailNotifier.new,
);

class FoodDetailNotifier extends AutoDisposeNotifier<FoodDetailState> {
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

  /// Agrega un ingrediente a la comida.
  /// Retorna un mensaje de error si falla, o `null` si OK.
  Future<String?> addIngredient({
    required String foodId,
    required String ingredientId,
    required double quantity,
  }) async {
    final current = state;
    if (current is! FoodDetailLoaded) return null;

    try {
      final supabase = Supabase.instance.client;

      // Fetch full ingredient data + insert detail in parallel
      final results = await Future.wait([
        supabase
            .from('ingredient')
            .select()
            .eq('id', ingredientId)
            .single(),
        supabase
            .from('detail_food_ingredient')
            .insert({
              'id_food': foodId,
              'id_ingredient': ingredientId,
              'quantity': quantity,
            })
            .select('id')
            .single(),
      ]);

      final ingredientData = results[0];
      final detailData = results[1];

      final newIngredient = RecognizedIngredient(
        id: ingredientId,
        idDetailFoodIngredient: detailData['id'] as String,
        name: ingredientData['name'] as String? ?? '',
        slug: ingredientData['slug'] as String? ?? '',
        calories: (ingredientData['calories'] as num?)?.toDouble() ?? 0,
        fat: (ingredientData['fat'] as num?)?.toDouble() ?? 0,
        carbohydrates:
            (ingredientData['carbohydrates'] as num?)?.toDouble() ?? 0,
        protein: (ingredientData['protein'] as num?)?.toDouble() ?? 0,
        unit: ingredientData['unit'] as String? ?? 'grams',
        baseQuantity:
            (ingredientData['base_quantity'] as num?)?.toDouble() ?? 100,
        quantity: quantity,
        category: ingredientData['category'] as String?,
      );

      // Actualizar estado
      final updatedIngredients = [
        ...current.result.ingredients,
        newIngredient,
      ];
      state = FoodDetailLoaded(
        result: current.result.copyWith(ingredients: updatedIngredients),
      );

      developer.log(
        'zineKey - Ingrediente agregado: $ingredientId',
        name: 'FoodDetail',
      );
      return null;
    } catch (e) {
      developer.log('zineKey - Error al agregar: $e', name: 'FoodDetail');
      return 'No se pudo agregar el ingrediente';
    }
  }

  /// Sets a pre-loaded result directly (no network fetch needed).
  void setResult(FoodRecognitionResult result) {
    state = FoodDetailLoaded(result: result);
  }

  /// Loads an existing food from the database by its ID.
  Future<void> loadExistingFood(String foodId) async {
    state = const FoodDetailAnalyzing();
    try {
      final supabase = Supabase.instance.client;

      final food = await supabase
          .from('food')
          .select('''
            id, title, description, type_food, image_url,
            link_youtube, link_tiktok, link_instagram,
            detail_food_ingredient (
              id, quantity,
              ingredient:id_ingredient (
                id, name, slug, calories, fat, carbohydrates, protein,
                unit, base_quantity, category
              )
            )
          ''')
          .eq('id', foodId)
          .single();

      final details =
          food['detail_food_ingredient'] as List<dynamic>? ?? [];
      final ingredients = details.map((d) {
        final detail = d as Map<String, dynamic>;
        final ing = detail['ingredient'] as Map<String, dynamic>;
        return RecognizedIngredient(
          id: ing['id'] as String,
          idDetailFoodIngredient: detail['id'] as String,
          name: ing['name'] as String? ?? '',
          slug: ing['slug'] as String? ?? '',
          calories: (ing['calories'] as num?)?.toDouble() ?? 0,
          fat: (ing['fat'] as num?)?.toDouble() ?? 0,
          carbohydrates: (ing['carbohydrates'] as num?)?.toDouble() ?? 0,
          protein: (ing['protein'] as num?)?.toDouble() ?? 0,
          unit: ing['unit'] as String? ?? 'grams',
          baseQuantity: (ing['base_quantity'] as num?)?.toDouble() ?? 100,
          quantity: (detail['quantity'] as num?)?.toDouble() ?? 0,
          category: ing['category'] as String?,
        );
      }).toList();

      state = FoodDetailLoaded(
        result: FoodRecognitionResult(
          id: food['id'] as String,
          title: food['title'] as String? ?? '',
          description: food['description'] as String? ?? '',
          typeFood: food['type_food'] as String? ?? 'snack',
          imageUrl: food['image_url'] as String? ?? '',
          ingredients: ingredients,
          linkYoutube: food['link_youtube'] as String?,
          linkTiktok: food['link_tiktok'] as String?,
          linkInstagram: food['link_instagram'] as String?,
        ),
      );
    } catch (e) {
      developer.log('zineKey - Error loading existing food: $e',
          name: 'FoodDetail');
      state = FoodDetailError(
        message: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  void reset() => state = const FoodDetailInitial();
}
