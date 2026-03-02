import 'package:isar/isar.dart';

import 'cached_exercise.dart';
import 'cached_exercise_search.dart';
import 'pending_schedule.dart';

class ExerciseLocalSource {
  const ExerciseLocalSource(this._isar);

  final Isar _isar;

  // ── Cached exercises ──────────────────────────────────────────

  /// O(1) lookup via composite index (searchQuery + muscleFilter).
  Future<CachedExerciseSearch?> getSearchResult(
    String query,
    String muscleFilter,
  ) async {
    return _isar.cachedExerciseSearchs
        .where()
        .searchQueryMuscleFilterEqualTo(query, muscleFilter)
        .findFirst();
  }

  /// O(1) per ID via unique index on exerciseId.
  Future<List<CachedExercise>> getExercisesByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    return _isar.cachedExercises
        .where()
        .anyOf(ids, (q, id) => q.exerciseIdEqualTo(id))
        .findAll();
  }

  /// Save exercises to Isar (upsert via replace: true on unique index).
  Future<void> saveExercises(List<CachedExercise> items) async {
    await _isar.writeTxn(() async {
      await _isar.cachedExercises.putAll(items);
    });
  }

  /// Save a search result (upsert via replace: true on unique composite index).
  Future<void> saveSearchResult(CachedExerciseSearch result) async {
    await _isar.writeTxn(() async {
      await _isar.cachedExerciseSearchs.put(result);
    });
  }

  // ── Pending schedules (offline queue) ─────────────────────────

  /// Get all pending schedules that haven't been synced yet.
  Future<List<PendingSchedule>> getAllPending() async {
    return _isar.pendingSchedules.where().findAll();
  }

  /// Get pending schedules for a specific date.
  Future<List<PendingSchedule>> getPendingForDate(String dateStr) async {
    return _isar.pendingSchedules
        .filter()
        .dateStrEqualTo(dateStr)
        .findAll();
  }

  /// Save pending schedules (upsert via replace: true on unique index).
  Future<void> savePending(List<PendingSchedule> items) async {
    await _isar.writeTxn(() async {
      await _isar.pendingSchedules.putAll(items);
    });
  }

  /// Delete pending schedules by their temp IDs after successful sync.
  Future<void> deletePendingByTempIds(List<String> tempIds) async {
    await _isar.writeTxn(() async {
      for (final tempId in tempIds) {
        await _isar.pendingSchedules
            .filter()
            .tempIdEqualTo(tempId)
            .deleteAll();
      }
    });
  }

  /// Delete a single pending schedule by temp ID.
  Future<void> deletePending(String tempId) async {
    await _isar.writeTxn(() async {
      await _isar.pendingSchedules
          .filter()
          .tempIdEqualTo(tempId)
          .deleteAll();
    });
  }

  /// Increment retry count for a pending schedule.
  Future<void> incrementRetry(String tempId) async {
    final item = await _isar.pendingSchedules
        .filter()
        .tempIdEqualTo(tempId)
        .findFirst();
    if (item != null) {
      item.retryCount++;
      await _isar.writeTxn(() async {
        await _isar.pendingSchedules.put(item);
      });
    }
  }
}
