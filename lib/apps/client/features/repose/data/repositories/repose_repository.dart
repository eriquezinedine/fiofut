import 'package:fio_fut/apps/client/features/repose/domain/models/models.dart';

/// Repository interface for repose data operations.
abstract class ReposeRepository {
  /// Saves a completed repose session.
  Future<void> saveReposeSession(ReposeItem item);

  /// Fetches the repose history for the current user.
  Future<List<ReposeItem>> getReposeHistory();
}
