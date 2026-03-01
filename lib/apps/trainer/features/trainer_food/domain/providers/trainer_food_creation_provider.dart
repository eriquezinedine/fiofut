import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'trainer_food_provider.dart';

sealed class TrainerFoodCreationState {
  const TrainerFoodCreationState();
}

class TrainerFoodCreationIdle extends TrainerFoodCreationState {
  const TrainerFoodCreationIdle();
}

class TrainerFoodCreationUploading extends TrainerFoodCreationState {
  const TrainerFoodCreationUploading();
}

class TrainerFoodCreationAnalyzing extends TrainerFoodCreationState {
  const TrainerFoodCreationAnalyzing();
}

class TrainerFoodCreationSuccess extends TrainerFoodCreationState {
  const TrainerFoodCreationSuccess({required this.foodTitle});
  final String foodTitle;
}

class TrainerFoodCreationError extends TrainerFoodCreationState {
  const TrainerFoodCreationError({required this.message});
  final String message;
}

final trainerFoodCreationProvider = AutoDisposeNotifierProvider<
    TrainerFoodCreationNotifier, TrainerFoodCreationState>(
  TrainerFoodCreationNotifier.new,
);

class TrainerFoodCreationNotifier
    extends AutoDisposeNotifier<TrainerFoodCreationState> {
  @override
  TrainerFoodCreationState build() => const TrainerFoodCreationIdle();

  void reset() => state = const TrainerFoodCreationIdle();

  Future<void> createFromPhoto(File imageFile) async {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser!.id;
    final accessToken = supabase.auth.currentSession?.accessToken;
    if (accessToken == null) {
      state = const TrainerFoodCreationError(
        message: 'No hay sesion activa',
      );
      return;
    }

    try {
      // 1. Upload image
      state = const TrainerFoodCreationUploading();
      final ext = imageFile.path.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$ext';
      final path = '$userId/$fileName';

      await supabase.storage.from('food-images').upload(path, imageFile);
      final imageUrl =
          supabase.storage.from('food-images').getPublicUrl(path);

      // 2. Call gemini
      state = const TrainerFoodCreationAnalyzing();
      final response = await supabase.functions.invoke(
        'gemini',
        body: {'action': 'recognize-food', 'image_url': imageUrl},
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      final data = response.data as Map<String, dynamic>;
      if (data['success'] != true) {
        throw Exception(data['error'] as String? ?? 'Error desconocido');
      }

      final foodData = data['food'] as Map<String, dynamic>;
      final title = foodData['title'] as String? ?? 'Comida';

      // 3. Refresh trainer food list
      ref.read(trainerFoodProvider.notifier).loadAll();

      state = TrainerFoodCreationSuccess(foodTitle: title);
    } catch (e) {
      state = TrainerFoodCreationError(
        message: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> createFromYouTube(String youtubeUrl) async {
    final supabase = Supabase.instance.client;
    final accessToken = supabase.auth.currentSession?.accessToken;
    if (accessToken == null) {
      state = const TrainerFoodCreationError(
        message: 'No hay sesion activa',
      );
      return;
    }

    try {
      state = const TrainerFoodCreationAnalyzing();

      final response = await supabase.functions.invoke(
        'gemini',
        body: {
          'action': 'recognize-food-youtube',
          'youtube_url': youtubeUrl,
        },
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      final data = response.data as Map<String, dynamic>;
      if (data['success'] != true) {
        throw Exception(data['error'] as String? ?? 'Error desconocido');
      }

      final foodData = data['food'] as Map<String, dynamic>;
      final title = foodData['title'] as String? ?? 'Comida';

      // Refresh trainer food list
      ref.read(trainerFoodProvider.notifier).loadAll();

      state = TrainerFoodCreationSuccess(foodTitle: title);
    } catch (e) {
      state = TrainerFoodCreationError(
        message: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }
}
