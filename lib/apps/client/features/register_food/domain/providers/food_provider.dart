import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ── State ───────────────────────────────────────────────────────

sealed class FoodImageUploadState {
  const FoodImageUploadState();
}

class FoodImageUploadInitial extends FoodImageUploadState {
  const FoodImageUploadInitial();
}

class FoodImageUploading extends FoodImageUploadState {
  const FoodImageUploading();
}

class FoodImageUploaded extends FoodImageUploadState {
  const FoodImageUploaded({required this.imageUrl});
  final String imageUrl;
}

class FoodImageUploadError extends FoodImageUploadState {
  const FoodImageUploadError({required this.message});
  final String message;
}

// ── Provider ────────────────────────────────────────────────────

final foodImageUploadProvider =
    NotifierProvider<FoodImageUploadNotifier, FoodImageUploadState>(
  FoodImageUploadNotifier.new,
);

class FoodImageUploadNotifier extends Notifier<FoodImageUploadState> {
  static const _bucket = 'food-images';

  @override
  FoodImageUploadState build() => const FoodImageUploadInitial();

  Future<void> uploadImage(File file) async {
    state = const FoodImageUploading();
    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser!.id;
      final ext = file.path.split('.').last;
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}.$ext';
      final path = '$userId/$fileName';

      await supabase.storage.from(_bucket).upload(path, file);

      final imageUrl =
          supabase.storage.from(_bucket).getPublicUrl(path);

      state = FoodImageUploaded(imageUrl: imageUrl);
    } catch (e) {
      state = FoodImageUploadError(message: e.toString());
    }
  }

  void reset() => state = const FoodImageUploadInitial();
}
