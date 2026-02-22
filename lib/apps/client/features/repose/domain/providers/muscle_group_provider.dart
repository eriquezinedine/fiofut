import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/muscle_group.dart';

part 'muscle_group_state.dart';

final muscleGroupProvider =
    NotifierProvider<MuscleGroupNotifier, MuscleGroupState>(
  MuscleGroupNotifier.new,
);

class MuscleGroupNotifier extends Notifier<MuscleGroupState> {
  @override
  MuscleGroupState build() {
    return const MuscleGroupState();
  }

  void toggleMuscle(MuscleGroup muscle) {
    final selected = Set<MuscleGroup>.from(state.selectedMuscles);
    if (selected.contains(muscle)) {
      selected.remove(muscle);
    } else {
      selected.add(muscle);
    }
    state = state.copyWith(selectedMuscles: selected);
  }

  void selectMuscle(MuscleGroup muscle) {
    state = state.copyWith(
      selectedMuscles: {...state.selectedMuscles, muscle},
    );
  }

  void deselectMuscle(MuscleGroup muscle) {
    final selected = Set<MuscleGroup>.from(state.selectedMuscles)
      ..remove(muscle);
    state = state.copyWith(selectedMuscles: selected);
  }

  void setMuscleColor(MuscleGroup muscle, Color color) {
    final colors = Map<MuscleGroup, Color>.from(state.muscleColors);
    colors[muscle] = color;
    state = state.copyWith(muscleColors: colors);
  }

  void selectMultiple(Set<MuscleGroup> muscles) {
    state = state.copyWith(
      selectedMuscles: {...state.selectedMuscles, ...muscles},
    );
  }

  void clearSelection() {
    state = state.copyWith(selectedMuscles: {});
  }

  void reset() {
    state = const MuscleGroupState();
  }
}
