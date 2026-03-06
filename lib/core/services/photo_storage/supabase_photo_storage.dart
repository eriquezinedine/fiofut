import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'workout_photo_storage.dart';

final workoutPhotoStorageProvider = Provider<WorkoutPhotoStorage>(
  (_) => SupabasePhotoStorage(),
);

class SupabasePhotoStorage implements WorkoutPhotoStorage {
  SupabasePhotoStorage({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;
  static const _bucket = 'workout_photos';

  @override
  Future<String> uploadPhoto({
    required String userId,
    required String fileName,
    required File file,
  }) async {
    final path = '$userId/$fileName';

    await _client.storage.from(_bucket).upload(
          path,
          file,
          fileOptions: const FileOptions(upsert: true),
        );

    return _client.storage.from(_bucket).getPublicUrl(path);
  }

  @override
  Future<void> deletePhoto(String url) async {
    // Extract path from public URL
    final uri = Uri.parse(url);
    final segments = uri.pathSegments;
    // URL pattern: .../storage/v1/object/public/workout_photos/userId/fileName
    final bucketIndex = segments.indexOf(_bucket);
    if (bucketIndex == -1) return;

    final path = segments.sublist(bucketIndex + 1).join('/');
    await _client.storage.from(_bucket).remove([path]);
  }
}
