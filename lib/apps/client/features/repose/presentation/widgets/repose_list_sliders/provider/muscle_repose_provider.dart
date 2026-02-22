import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/repose/domain/models/muscle_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'muscle_repose_state.dart';

/// AutoDispose family provider — one independent instance per [MuscleGroup].
///
/// Each instance is automatically disposed when the widget that watches it
/// is removed from the tree, so every navigation creates a fresh state.
final muscleReposeProvider = NotifierProvider.autoDispose
    .family<MuscleReposeNotifier, MuscleReposeState, MuscleGroup>(
  MuscleReposeNotifier.new,
);

class MuscleReposeNotifier
    extends AutoDisposeFamilyNotifier<MuscleReposeState, MuscleGroup> {
  static const _disabledMuscles = {
    MuscleGroup.chestLeft,
    MuscleGroup.chestRight,
    MuscleGroup.upperBack,
  };

  @override
  MuscleReposeState build(MuscleGroup arg) {
    return MuscleReposeState(
      muscle: arg,
      progress: _fakeProgress(arg),
      totalMinutes: _fakeTotalMinutes(arg),
      sliderEnabled: !_disabledMuscles.contains(arg),
    );
  }

  /// Update the slider / progress value.
  void updateProgress(double value) {
    state = state.copyWith(progress: value.clamp(0.0, 1.0));
  }

  /// Reset — muscle is fully recovered.
  void reset() {
    state = state.copyWith(progress: 1.0);
  }

  /// Enable or disable the slider knob and interaction.
  void setSliderEnabled(bool enabled) {
    state = state.copyWith(sliderEnabled: enabled);
  }

  // ---------------------------------------------------------------
  // Fake defaults (replace with repository data later)
  // ---------------------------------------------------------------

  static const _largeMuscles = {
    MuscleGroup.chestLeft,
    MuscleGroup.chestRight,
    MuscleGroup.upperBack,
    MuscleGroup.lowerBack,
    MuscleGroup.quadLeft,
    MuscleGroup.quadRight,
    MuscleGroup.hamstringLeft,
    MuscleGroup.hamstringRight,
    MuscleGroup.gluteLeft,
    MuscleGroup.gluteRight,
  };

  /// Large muscles: 48 h, small muscles: 24 h.
  static int _fakeTotalMinutes(MuscleGroup muscle) {
    return _largeMuscles.contains(muscle) ? 2880 : 1440;
  }

  static double _fakeProgress(MuscleGroup muscle) {
    return switch (muscle) {
      MuscleGroup.chestLeft => 1.0,
      MuscleGroup.chestRight => 1.0,
      MuscleGroup.upperBack => 0.80,
      MuscleGroup.lowerBack => 0.65,
      MuscleGroup.quadLeft => 0.45,
      MuscleGroup.quadRight => 0.45,
      MuscleGroup.hamstringLeft => 0.20,
      MuscleGroup.hamstringRight => 0.20,
      MuscleGroup.gluteLeft => 1.0,
      MuscleGroup.gluteRight => 0.90,
      MuscleGroup.shoulderLeft => 1.0,
      MuscleGroup.shoulderRight => 0.75,
      MuscleGroup.bicepLeft => 0.55,
      MuscleGroup.bicepRight => 0.55,
      MuscleGroup.tricepLeft => 0.30,
      MuscleGroup.tricepRight => 0.30,
      MuscleGroup.forearmLeft => 1.0,
      MuscleGroup.forearmRight => 1.0,
      MuscleGroup.abs => 0.10,
      MuscleGroup.calfLeft => 0.70,
      MuscleGroup.calfRight => 0.70,
      _ => 0.0,
    };
  }
}
