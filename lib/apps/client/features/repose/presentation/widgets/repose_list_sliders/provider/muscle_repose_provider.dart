import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:model/model.dart';

import '../../../../domain/providers/all_muscles_repose_provider.dart';

part 'muscle_repose_state.dart';

/// AutoDispose family provider — one independent instance per [MuscleRepose].
///
/// Each instance is automatically disposed when the widget that watches it
/// is removed from the tree, so every navigation creates a fresh state.
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

  Timer? _debounceTimer;

  @override
  MuscleReposeState build(MuscleRepose arg) {
    ref.onDispose(() => _debounceTimer?.cancel());

    final isLarge = _largeMuscleGroups.contains(arg.muscle.muscleGroup);
    return MuscleReposeState(
      muscleRepose: arg,
      progress: arg.percentage / 100.0,
      totalMinutes: isLarge ? 2880 : 1440,
    );
  }

  /// Update the slider / progress value.
  /// Updates local state immediately, then syncs to global after 300ms debounce.
  void updateProgress(double value) {
    state = state.copyWith(progress: value.clamp(0.0, 1.0));

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      ref.read(allMusclesReposeProvider.notifier).updateMuscleProgress(
            arg.muscle.muscleGroup,
            (state.progress * 100).round(),
          );
    });
  }

  /// Reset — muscle is fully recovered.
  void reset() {
    state = state.copyWith(progress: 1.0);
  }

  /// Enable or disable the slider knob and interaction.
  void setSliderEnabled(bool enabled) {
    state = state.copyWith(sliderEnabled: enabled);
  }
}
