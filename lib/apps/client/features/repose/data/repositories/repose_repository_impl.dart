import 'package:fio_fut/apps/client/features/repose/data/repositories/repose_repository.dart';
import 'package:fio_fut/apps/client/features/repose/domain/models/models.dart';

/// Implementation of [ReposeRepository].
class ReposeRepositoryImpl implements ReposeRepository {
  const ReposeRepositoryImpl();

  @override
  Future<void> saveReposeSession(ReposeItem item) async {
    // TODO: Implement persistence (local DB or remote API)
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<List<ReposeItem>> getReposeHistory() async {
    // TODO: Implement actual data fetch
    await Future.delayed(const Duration(milliseconds: 500));
    return [];
  }
}
