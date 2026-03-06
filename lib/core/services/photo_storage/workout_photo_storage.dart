import 'dart:io';

/// Abstract interface for workout photo storage.
/// Implementations can be swapped (e.g., Supabase → S3 → Firebase).
abstract class WorkoutPhotoStorage {
  Future<String> uploadPhoto({
    required String userId,
    required String fileName,
    required File file,
  });

  Future<void> deletePhoto(String url);
}
