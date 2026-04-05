import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/repose/data/repositories/offline_aware_repose_repository.dart';
import 'package:fio_fut/core/utils/debouncer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:model/model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../domain/providers/all_muscles_repose_provider.dart';

part 'muscle_repose_state.dart';

/// AutoDispose family provider — one independent instance per [MuscleRepose].
final muscleReposeProvider = NotifierProvider.autoDispose
    .family<MuscleReposeNotifier, MuscleReposeState, MuscleRepose>(
  MuscleReposeNotifier.new,
);

class MuscleReposeNotifier
    extends AutoDisposeFamilyNotifier<MuscleReposeState, MuscleRepose> {
  static const _largeMuscleGroups = {
    MuscleGroup.chest,
    MuscleGroup.back,
    MuscleGroup.lowerBack,
    MuscleGroup.quadriceps,
    MuscleGroup.hamstrings,
    MuscleGroup.glutes,
  };

  final _debouncer = Debouncer(milliseconds: 300);

  @override
  MuscleReposeState build(MuscleRepose arg) {
    ref.onDispose(() => _debouncer.cancel());

    final isLarge = _largeMuscleGroups.contains(arg.muscle.muscleGroup);
    return MuscleReposeState(
      muscleRepose: arg,
      progress: arg.percentage / 100.0,
      totalMinutes: isLarge ? 2880 : 1440,
    );
  }

  /// Update slider: UI inmediata + global state + debounce backend.
  void updateProgress(double value) {
    state = state.copyWith(progress: value.clamp(0.0, 1.0));

    // Sync a estado global (inmediato, in-memory)
    final percentage = (state.progress * 100).round();
    ref.read(allMusclesReposeProvider.notifier).updateMuscleProgress(
          arg.muscle.muscleGroup,
          percentage,
        );

    // Sync a backend con debounce 300ms
    _debouncer.run(() => _syncToBackend(percentage));
  }

  /// Reset: muscle fully recovered.
  void reset() {
    state = state.copyWith(progress: 1.0);

    ref.read(allMusclesReposeProvider.notifier).updateMuscleProgress(
          arg.muscle.muscleGroup,
          100,
        );

    _debouncer.run(() => _syncToBackend(100));
  }

  void setSliderEnabled(bool enabled) {
    state = state.copyWith(sliderEnabled: enabled);
  }

  Future<void> _syncToBackend(int percentage) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    await ref.read(offlineReposeRepoProvider).upsertMuscleProgress(
          userId: userId,
          group: arg.muscle.muscleGroup,
          percentage: percentage,
        );
  }
}
