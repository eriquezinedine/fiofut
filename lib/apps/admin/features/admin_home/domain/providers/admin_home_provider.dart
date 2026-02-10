import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/admin_home_repository.dart';
import '../models/admin_stats.dart';

part 'admin_home_state.dart';

final adminHomeProvider =
    NotifierProvider<AdminHomeNotifier, AdminHomeState>(
  AdminHomeNotifier.new,
);

class AdminHomeNotifier extends Notifier<AdminHomeState> {
  @override
  AdminHomeState build() {
    return const AdminHomeInitial();
  }

  Future<void> loadStats() async {
    state = const AdminHomeLoading();

    try {
      final repo = ref.read(adminHomeRepositoryProvider);
      final stats = await repo.getAdminStats();
      state = AdminHomeLoaded(stats: stats);
    } catch (e) {
      state = AdminHomeError(message: e.toString());
    }
  }

  Future<void> refresh() async {
    await loadStats();
  }
}
