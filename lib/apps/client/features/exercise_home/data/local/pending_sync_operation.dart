import 'package:isar/isar.dart';

part 'pending_sync_operation.g.dart';

/// Operación pendiente de sincronización con Supabase.
///
/// Cuando un request falla (sin internet, timeout, error), se guarda aquí.
/// El `setId` con `unique: true, replace: true` auto-deduplica:
/// si el usuario edita la misma serie 5 veces offline, solo se guarda
/// el último cambio.
///
/// Tipos de operación (`operationType`):
/// - `sync_set`: actualizar valores de una serie (reps, weight, mins, secs)
/// - `batch_toggle_true`: completar múltiples series
/// - `batch_toggle_false`: descompletar múltiples series
/// - `batch_values`: actualizar un campo en múltiples series (ej: propagar weight)
/// - `add_set`: crear una serie nueva
/// - `delete_set`: eliminar una serie
@collection
class PendingSyncOperation {
  Id isarId = Isar.autoIncrement;

  /// ID de la serie en Supabase. Unique + replace = auto-dedup.
  /// Para batch operations usa un key compuesto (ej: 'batch_toggle_true_<scheduleId>').
  @Index(unique: true, replace: true)
  late String setId;

  /// Tipo de operación pendiente.
  late String operationType;

  // ── Valores de la serie (para sync_set / add_set) ──

  int? repetitions;
  double? weight;
  int? minutes;
  int? seconds;
  double? distance;
  bool? isCompleted;
  String? setType;

  // ── Para add_set ──

  String? scheduleId;
  int? setNumber;
  String? sessionDateStr;

  // ── Para batch operations ──

  /// IDs separados por coma para batch_toggle / batch_values.
  String? batchSetIds;

  // ── Metadata ──

  /// Timestamp del último cambio. Sirve para ordenar el flush
  /// y garantizar que siempre se suba el valor más reciente.
  late DateTime updatedAt;

  /// Cantidad de reintentos fallidos.
  int retryCount = 0;
}
