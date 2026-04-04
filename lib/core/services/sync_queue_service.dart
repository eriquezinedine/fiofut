import 'package:fio_fut/apps/client/features/exercise_home/data/local/pending_sync_operation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import 'isar_service.dart';

final syncQueueServiceProvider = Provider<SyncQueueService>((ref) {
  return SyncQueueService(ref.read(isarProvider));
});

/// Servicio para leer/escribir operaciones pendientes en Isar.
/// Auto-deduplica por `setId` gracias al index unique+replace.
class SyncQueueService {
  const SyncQueueService(this._isar);

  final Isar _isar;

  /// Encola una operación. Si ya existe una con el mismo `setId`, la reemplaza.
  Future<void> enqueue(PendingSyncOperation op) async {
    await _isar.writeTxn(() => _isar.pendingSyncOperations.put(op));
  }

  /// Retorna todas las operaciones pendientes ordenadas por `updatedAt`.
  Future<List<PendingSyncOperation>> dequeueAll() async {
    return _isar.pendingSyncOperations
        .where()
        .sortByUpdatedAt()
        .findAll();
  }

  /// Elimina una operación por su `setId`.
  Future<void> remove(String setId) async {
    await _isar.writeTxn(() async {
      await _isar.pendingSyncOperations
          .where()
          .setIdEqualTo(setId)
          .deleteAll();
    });
  }

  /// Elimina múltiples operaciones por sus `setId`.
  Future<void> removeAll(List<String> setIds) async {
    await _isar.writeTxn(() async {
      for (final id in setIds) {
        await _isar.pendingSyncOperations
            .where()
            .setIdEqualTo(id)
            .deleteAll();
      }
    });
  }

  /// Cantidad de operaciones pendientes.
  Future<int> count() async {
    return _isar.pendingSyncOperations.count();
  }

  /// Limpia toda la cola (debug/reset).
  Future<void> clear() async {
    await _isar.writeTxn(() => _isar.pendingSyncOperations.clear());
  }
}
