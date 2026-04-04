import 'package:fio_fut/apps/client/features/exercise_home/data/local/pending_sync_operation.dart';
import 'package:fio_fut/apps/client/features/exercise_home/data/repositories/exercise_home_repository.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/providers/exercise_home/exercise_home_provider.dart';
import 'package:fio_fut/core/services/connectivity_service.dart';
import 'package:fio_fut/core/services/sync_queue_service.dart';
import 'package:fio_fut/core/utils/app_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Estado visible para la UI (sync_status_indicator).
enum SyncStatus { idle, syncing, error }

final syncOrchestratorProvider =
    NotifierProvider<SyncOrchestrator, SyncOrchestratorState>(
  SyncOrchestrator.new,
);

class SyncOrchestratorState {
  const SyncOrchestratorState({
    this.status = SyncStatus.idle,
    this.pendingCount = 0,
  });

  final SyncStatus status;
  final int pendingCount;

  bool get hasPending => pendingCount > 0;
  bool get isSynced => pendingCount == 0 && status != SyncStatus.error;

  SyncOrchestratorState copyWith({SyncStatus? status, int? pendingCount}) {
    return SyncOrchestratorState(
      status: status ?? this.status,
      pendingCount: pendingCount ?? this.pendingCount,
    );
  }
}

class SyncOrchestrator extends Notifier<SyncOrchestratorState> {
  SyncQueueService get _queue => ref.read(syncQueueServiceProvider);
  ExerciseHomeRepository get _repo => ref.read(exerciseHomeRepositoryProvider);

  bool _isSyncing = false;

  @override
  SyncOrchestratorState build() {
    // Escuchar cambios de conectividad
    ref.listen<bool>(hasConnectivityProvider, (prev, hasNet) {
      if (hasNet && !(prev ?? true)) {
        // Conexión restaurada → flush
        flushQueue();
      }
    });

    // Cargar count inicial
    _refreshCount();
    return const SyncOrchestratorState();
  }

  Future<void> _refreshCount() async {
    final count = await _queue.count();
    state = state.copyWith(pendingCount: count);
  }

  /// Intenta sincronizar todas las operaciones pendientes con Supabase.
  Future<void> flushQueue() async {
    if (_isSyncing) return;
    _isSyncing = true;
    state = state.copyWith(status: SyncStatus.syncing);

    try {
      final ops = await _queue.dequeueAll();
      if (ops.isEmpty) {
        state = state.copyWith(status: SyncStatus.idle, pendingCount: 0);
        _isSyncing = false;
        return;
      }

      // Ordenar: add_set primero, luego sync/batch, luego delete_set
      final sorted = _sortByPriority(ops);
      final failedIds = <String>[];

      for (final op in sorted) {
        try {
          await _executeOp(op);
          await _queue.remove(op.setId);
        } catch (e) {
          AppLogger.error('SyncOrchestrator: op ${op.operationType} failed', e);
          failedIds.add(op.setId);
        }
      }

      final remaining = await _queue.count();
      state = state.copyWith(
        status: remaining > 0 ? SyncStatus.error : SyncStatus.idle,
        pendingCount: remaining,
      );

      // Post-flush: recargar datos frescos del backend
      if (remaining == 0) {
        ref.read(exerciseHomeProvider.notifier).reload();
      }
    } catch (e) {
      AppLogger.error('SyncOrchestrator: flushQueue failed', e);
      await _refreshCount();
      state = state.copyWith(status: SyncStatus.error);
    } finally {
      _isSyncing = false;
    }
  }

  /// Notifica que se encoló una operación nueva (para actualizar el count).
  Future<void> notifyEnqueued() async {
    await _refreshCount();
  }

  // ── Ejecución de operaciones ──────────────────────────────────────

  Future<void> _executeOp(PendingSyncOperation op) async {
    switch (op.operationType) {
      case 'sync_set':
        await _repo.syncSet(
          setId: op.setId,
          repetitions: op.repetitions,
          weight: op.weight,
          minutes: op.minutes,
          seconds: op.seconds,
          isCompleted: op.isCompleted ?? false,
          setType: op.setType ?? 'normal',
        );

      case 'batch_toggle_true':
      case 'batch_toggle_false':
        final ids = op.batchSetIds?.split(',') ?? [];
        if (ids.isNotEmpty) {
          await _repo.batchToggleCompleted(
            setIds: ids,
            isCompleted: op.operationType == 'batch_toggle_true',
          );
        }

      case 'batch_values':
        final ids = op.batchSetIds?.split(',') ?? [];
        if (ids.isNotEmpty) {
          await _repo.batchSyncValues(
            setIds: ids,
            repetitions: op.repetitions,
            weight: op.weight,
            minutes: op.minutes,
            seconds: op.seconds,
            distance: op.distance,
          );
        }

      case 'add_set':
        if (op.scheduleId != null && op.setNumber != null && op.sessionDateStr != null) {
          await _repo.addSet(
            scheduleId: op.scheduleId!,
            setNumber: op.setNumber!,
            sessionDate: DateTime.parse(op.sessionDateStr!),
            repetitions: op.repetitions,
            weight: op.weight,
            minutes: op.minutes,
            seconds: op.seconds,
          );
        }

      case 'delete_set':
        await _repo.deleteSet(op.setId);

      default:
        AppLogger.error('SyncOrchestrator: unknown op type ${op.operationType}');
    }
  }

  /// Ordena: add_set → sync_set/batch → delete_set.
  List<PendingSyncOperation> _sortByPriority(List<PendingSyncOperation> ops) {
    const priority = {
      'add_set': 0,
      'sync_set': 1,
      'batch_toggle_true': 1,
      'batch_toggle_false': 1,
      'batch_values': 1,
      'delete_set': 2,
    };
    return ops..sort((a, b) {
      final pa = priority[a.operationType] ?? 1;
      final pb = priority[b.operationType] ?? 1;
      if (pa != pb) return pa.compareTo(pb);
      return a.updatedAt.compareTo(b.updatedAt);
    });
  }
}
