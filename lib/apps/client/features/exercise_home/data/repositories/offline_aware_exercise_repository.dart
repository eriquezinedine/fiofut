import 'package:fio_fut/apps/client/features/exercise_home/data/local/pending_sync_operation.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise_schedule_item.dart';
import 'package:fio_fut/core/services/sync_orchestrator.dart';
import 'package:fio_fut/core/services/sync_queue_service.dart';
import 'package:fio_fut/core/utils/app_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'exercise_home_repository.dart';

final offlineExerciseRepoProvider =
    Provider<OfflineAwareExerciseRepository>((ref) {
  return OfflineAwareExerciseRepository(
    innerRepo: ref.read(exerciseHomeRepositoryProvider),
    syncQueue: ref.read(syncQueueServiceProvider),
    ref: ref,
  );
});

/// Wrapper que intercepta llamadas al repositorio de Supabase.
/// Si la llamada falla, encola la operación en Isar para retry.
class OfflineAwareExerciseRepository {
  const OfflineAwareExerciseRepository({
    required ExerciseHomeRepository innerRepo,
    required SyncQueueService syncQueue,
    required Ref ref,
  })  : _innerRepo = innerRepo,
        _syncQueue = syncQueue,
        _ref = ref;

  final ExerciseHomeRepository _innerRepo;
  final SyncQueueService _syncQueue;
  final Ref _ref;

  void _notifyOrchestrator() {
    _ref.read(syncOrchestratorProvider.notifier).notifyEnqueued();
  }

  // ── syncSet ───────────────────────────────────────────────────────

  Future<void> syncSet({
    required String setId,
    int? repetitions,
    double? weight,
    int? minutes,
    int? seconds,
    required bool isCompleted,
    String setType = 'normal',
  }) async {
    try {
      await _innerRepo.syncSet(
        setId: setId,
        repetitions: repetitions,
        weight: weight,
        minutes: minutes,
        seconds: seconds,
        isCompleted: isCompleted,
        setType: setType,
      );
    } catch (e) {
      AppLogger.error('OfflineRepo: syncSet failed, enqueuing', e);
      await _syncQueue.enqueue(PendingSyncOperation()
        ..setId = setId
        ..operationType = 'sync_set'
        ..repetitions = repetitions
        ..weight = weight
        ..minutes = minutes
        ..seconds = seconds
        ..isCompleted = isCompleted
        ..setType = setType
        ..updatedAt = DateTime.now());
      _notifyOrchestrator();
    }
  }

  // ── batchToggleCompleted ──────────────────────────────────────────

  Future<void> batchToggleCompleted({
    required List<String> setIds,
    required bool isCompleted,
  }) async {
    if (setIds.isEmpty) return;
    try {
      await _innerRepo.batchToggleCompleted(
        setIds: setIds,
        isCompleted: isCompleted,
      );
    } catch (e) {
      AppLogger.error('OfflineRepo: batchToggleCompleted failed, enqueuing', e);
      final key = 'batch_toggle_${isCompleted}_${setIds.hashCode}';
      await _syncQueue.enqueue(PendingSyncOperation()
        ..setId = key
        ..operationType = isCompleted ? 'batch_toggle_true' : 'batch_toggle_false'
        ..batchSetIds = setIds.join(',')
        ..isCompleted = isCompleted
        ..updatedAt = DateTime.now());
      _notifyOrchestrator();
    }
  }

  // ── batchSyncValues ───────────────────────────────────────────────

  Future<void> batchSyncValues({
    required List<String> setIds,
    int? repetitions,
    double? weight,
    int? minutes,
    int? seconds,
    double? distance,
  }) async {
    if (setIds.isEmpty) return;
    try {
      await _innerRepo.batchSyncValues(
        setIds: setIds,
        repetitions: repetitions,
        weight: weight,
        minutes: minutes,
        seconds: seconds,
        distance: distance,
      );
    } catch (e) {
      AppLogger.error('OfflineRepo: batchSyncValues failed, enqueuing', e);
      final key = 'batch_values_${setIds.hashCode}';
      await _syncQueue.enqueue(PendingSyncOperation()
        ..setId = key
        ..operationType = 'batch_values'
        ..batchSetIds = setIds.join(',')
        ..repetitions = repetitions
        ..weight = weight
        ..minutes = minutes
        ..seconds = seconds
        ..distance = distance
        ..updatedAt = DateTime.now());
      _notifyOrchestrator();
    }
  }

  // ── addSet ─────────────────────────────────────────────────────────

  Future<ExerciseSetData> addSet({
    required String scheduleId,
    required int setNumber,
    required DateTime sessionDate,
    int? repetitions,
    double? weight,
    int? minutes,
    int? seconds,
  }) async {
    // addSet necesita retornar el ID real del backend.
    // Si falla, encolamos para retry pero retornamos un set con ID temporal.
    try {
      return await _innerRepo.addSet(
        scheduleId: scheduleId,
        setNumber: setNumber,
        sessionDate: sessionDate,
        repetitions: repetitions,
        weight: weight,
        minutes: minutes,
        seconds: seconds,
      );
    } catch (e) {
      AppLogger.error('OfflineRepo: addSet failed, enqueuing', e);
      final tempId = 'pending_${DateTime.now().millisecondsSinceEpoch}';
      await _syncQueue.enqueue(PendingSyncOperation()
        ..setId = tempId
        ..operationType = 'add_set'
        ..scheduleId = scheduleId
        ..setNumber = setNumber
        ..sessionDateStr = sessionDate.toIso8601String().split('T').first
        ..repetitions = repetitions
        ..weight = weight
        ..minutes = minutes
        ..seconds = seconds
        ..updatedAt = DateTime.now());
      _notifyOrchestrator();

      return ExerciseSetData(
        id: tempId,
        setNumber: setNumber,
        sessionDate: sessionDate,
        repetitions: repetitions,
        weight: weight,
        minutes: minutes,
        seconds: seconds,
      );
    }
  }

  // ── deleteSet ─────────────────────────────────────────────────────

  Future<void> deleteSet(String setId) async {
    try {
      await _innerRepo.deleteSet(setId);
    } catch (e) {
      AppLogger.error('OfflineRepo: deleteSet failed, enqueuing', e);
      await _syncQueue.enqueue(PendingSyncOperation()
        ..setId = setId
        ..operationType = 'delete_set'
        ..updatedAt = DateTime.now());
      _notifyOrchestrator();
    }
  }

  // ── toggleSetCompleted (individual, legacy) ───────────────────────

  Future<void> toggleSetCompleted({
    required String setId,
    required bool isCompleted,
  }) async {
    try {
      await _innerRepo.toggleSetCompleted(
        setId: setId,
        isCompleted: isCompleted,
      );
    } catch (e) {
      AppLogger.error('OfflineRepo: toggleSetCompleted failed, enqueuing', e);
      await _syncQueue.enqueue(PendingSyncOperation()
        ..setId = setId
        ..operationType = 'sync_set'
        ..isCompleted = isCompleted
        ..updatedAt = DateTime.now());
      _notifyOrchestrator();
    }
  }
}
