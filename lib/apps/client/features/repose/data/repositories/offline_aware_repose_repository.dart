import 'package:fio_fut/apps/client/features/repose/data/local/pending_repose_sync.dart';
import 'package:fio_fut/apps/client/features/repose/data/repositories/repose_repository.dart';
import 'package:fio_fut/core/services/isar_service.dart';
import 'package:fio_fut/core/utils/app_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:model/model.dart';

final offlineReposeRepoProvider =
    Provider<OfflineAwareReposeRepository>((ref) {
  return OfflineAwareReposeRepository(
    innerRepo: ref.read(reposeRepositoryProvider),
    isar: ref.read(isarProvider),
  );
});

class OfflineAwareReposeRepository {
  const OfflineAwareReposeRepository({
    required ReposeRepository innerRepo,
    required Isar isar,
  })  : _innerRepo = innerRepo,
        _isar = isar;

  final ReposeRepository _innerRepo;
  final Isar _isar;

  /// Upsert con fallback a Isar.
  Future<void> upsertMuscleProgress({
    required String userId,
    required MuscleGroup group,
    required int percentage,
  }) async {
    try {
      await _innerRepo.upsertMuscleProgress(
        userId: userId,
        group: group,
        percentage: percentage,
      );
    } catch (e) {
      AppLogger.error('OfflineReposeRepo: upsert failed, enqueuing', e);
      await _isar.writeTxn(() => _isar.pendingReposeSyncs.put(
            PendingReposeSync()
              ..muscleGroup = group.toJson()
              ..operationType = 'upsert'
              ..percentage = percentage
              ..updatedAt = DateTime.now(),
          ));
    }
  }

  /// Reset all con fallback a Isar.
  Future<void> resetAll(String userId) async {
    try {
      await _innerRepo.resetAll(userId);
    } catch (e) {
      AppLogger.error('OfflineReposeRepo: resetAll failed, enqueuing', e);
      await _isar.writeTxn(() async {
        for (final g in MuscleGroup.values) {
          await _isar.pendingReposeSyncs.put(
            PendingReposeSync()
              ..muscleGroup = g.toJson()
              ..operationType = 'upsert'
              ..percentage = 100
              ..updatedAt = DateTime.now(),
          );
        }
      });
    }
  }

  /// Flush: sube todos los pendientes a Supabase.
  Future<int> flushPending(String userId) async {
    final ops = await _isar.pendingReposeSyncs.where().sortByUpdatedAt().findAll();
    if (ops.isEmpty) return 0;

    var synced = 0;
    for (final op in ops) {
      try {
        final group = MuscleGroup.fromJson(op.muscleGroup);
        await _innerRepo.upsertMuscleProgress(
          userId: userId,
          group: group,
          percentage: op.percentage ?? 100,
        );
        await _isar.writeTxn(() => _isar.pendingReposeSyncs.delete(op.isarId));
        synced++;
      } catch (e) {
        AppLogger.error('OfflineReposeRepo: flush op failed', e);
      }
    }
    return synced;
  }

  /// Cantidad de operaciones pendientes.
  Future<int> pendingCount() => _isar.pendingReposeSyncs.count();
}
