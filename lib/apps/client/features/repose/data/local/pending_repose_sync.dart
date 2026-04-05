import 'package:isar/isar.dart';

part 'pending_repose_sync.g.dart';

/// Operacion pendiente de sincronizacion de reposo muscular.
///
/// `muscleGroup` con unique+replace auto-deduplica:
/// si el usuario mueve el slider 10 veces offline,
/// solo el ultimo valor se guarda.
@collection
class PendingReposeSync {
  Id isarId = Isar.autoIncrement;

  /// Muscle group key (ej: 'chest'). Unique+replace = auto-dedup.
  @Index(unique: true, replace: true)
  late String muscleGroup;

  /// Tipo: 'upsert' o 'reset_all'.
  late String operationType;

  /// Porcentaje de recuperacion (0-100).
  int? percentage;

  /// Timestamp del ultimo cambio.
  late DateTime updatedAt;

  int retryCount = 0;
}
