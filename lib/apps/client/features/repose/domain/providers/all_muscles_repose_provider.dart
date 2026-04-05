import 'package:fio_fut/apps/client/features/repose/data/repositories/offline_aware_repose_repository.dart';
import 'package:fio_fut/apps/client/features/repose/data/repositories/repose_repository.dart';
import 'package:fio_fut/core/constants/workout_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:model/model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../presentation/widgets/repose_list_sliders/repose_list_sliders.dart';

part 'all_muscles_repose_state.dart';

/// Global provider: single source of truth para todos los musculos y su %.
final allMusclesReposeProvider =
    NotifierProvider<AllMusclesReposeNotifier, AllMusclesReposeState>(
  AllMusclesReposeNotifier.new,
);

class AllMusclesReposeNotifier extends Notifier<AllMusclesReposeState> {
  @override
  AllMusclesReposeState build() {
    // Cargar fake por defecto, luego reemplazar con datos reales
    final initial = AllMusclesReposeState.fromList(kFakeMuscles);

    // Cargar desde backend async
    Future.microtask(() => loadFromRemote());

    return initial;
  }

  /// Carga datos reales de Supabase y reemplaza el estado.
  Future<void> loadFromRemote() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    try {
      // Flush pendientes primero
      final offlineRepo = ref.read(offlineReposeRepoProvider);
      await offlineRepo.flushPending(userId);

      // Cargar datos frescos
      final repo = ref.read(reposeRepositoryProvider);
      final data = await repo.fetchAll(userId);

      if (data.isEmpty) return;

      final updated = Map<MuscleGroup, MuscleRepose>.from(state.muscles);
      for (final item in data) {
        final existing = updated[item.group];
        if (existing != null) {
          // Calcular recuperacion natural por tiempo transcurrido
          final percentage = item.updatedAt != null
              ? calculateRecoveredPercentage(
                  storedPercentage: item.percentage,
                  updatedAt: item.updatedAt!,
                  muscleGroup: item.group.toJson(),
                )
              : item.percentage;

          updated[item.group] = MuscleRepose(
            muscle: existing.muscle,
            percentage: percentage,
          );
        }
      }
      state = AllMusclesReposeState(muscles: updated);
    } catch (_) {
      // Sin internet, mantener estado actual
    }
  }

  /// Actualiza un musculo. Solo estado local (el sync lo hace el slider provider).
  void updateMuscleProgress(MuscleGroup group, int percentage) {
    final current = state.muscles[group];
    if (current == null) return;

    final updated = Map<MuscleGroup, MuscleRepose>.from(state.muscles);
    updated[group] = MuscleRepose(
      muscle: current.muscle,
      percentage: percentage.clamp(0, 100),
    );

    state = AllMusclesReposeState(muscles: updated);
  }

  /// Reduce porcentaje por fatiga (llamado desde serieDetailProvider).
  void reduceMuscleProgress(MuscleGroup group, double amount) {
    final current = state.muscles[group];
    if (current == null) return;
    final newPercentage = (current.percentage - amount).clamp(0, 100).round();
    updateMuscleProgress(group, newPercentage);

    // Sync a backend con offline support
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;
    ref.read(offlineReposeRepoProvider).upsertMuscleProgress(
          userId: userId,
          group: group,
          percentage: newPercentage,
        );
  }

  /// Reiniciar todos a 100%.
  void resetAll() {
    final updated = state.muscles.map(
      (group, mr) => MapEntry(
        group,
        MuscleRepose(muscle: mr.muscle, percentage: 100),
      ),
    );
    state = AllMusclesReposeState(muscles: updated);

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;
    ref.read(offlineReposeRepoProvider).resetAll(userId);
  }
}
