import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:model/model.dart';

import '../../presentation/widgets/repose_list_sliders/repose_list_sliders.dart';

part 'all_muscles_repose_state.dart';

/// Global provider that holds ALL muscles and their recovery percentages.
///
/// This is the single source of truth. Per-muscle slider providers
/// sync back here after a 300ms debounce.
final allMusclesReposeProvider =
    NotifierProvider<AllMusclesReposeNotifier, AllMusclesReposeState>(
  AllMusclesReposeNotifier.new,
);

class AllMusclesReposeNotifier extends Notifier<AllMusclesReposeState> {
  @override
  AllMusclesReposeState build() {
    // TODO: Replace with repository call → load from Supabase
    // final muscles = await ref.read(reposeRepositoryProvider).getAllMuscleRepose();
    return AllMusclesReposeState.fromList(kFakeMuscles);
  }

  /// Updates a single muscle's percentage.
  /// Called by per-muscle providers after debounce.
  void updateMuscleProgress(MuscleGroup group, int percentage) {
    final current = state.muscles[group];
    if (current == null) return;

    final updated = Map<MuscleGroup, MuscleRepose>.from(state.muscles);
    updated[group] = MuscleRepose(
      muscle: current.muscle,
      percentage: percentage.clamp(0, 100),
    );

    state = AllMusclesReposeState(muscles: updated);

    // TODO: Sync to Supabase via repository
    // ref.read(reposeRepositoryProvider).updateMuscleProgress(group, percentage);
  }

  /// Reduces a muscle's recovery percentage by the given amount.
  /// Used after completing reps (e.g., amount = reps * kFatiguePerRep).
  void reduceMuscleProgress(MuscleGroup group, double amount) {
    final current = state.muscles[group];
    if (current == null) return;
    final newPercentage = (current.percentage - amount).clamp(0, 100).round();
    updateMuscleProgress(group, newPercentage);
  }

  /// Resets all muscles to 100%.
  void resetAll() {
    final updated = state.muscles.map(
      (group, mr) => MapEntry(
        group,
        MuscleRepose(muscle: mr.muscle, percentage: 100),
      ),
    );
    state = AllMusclesReposeState(muscles: updated);

    // TODO: Sync reset to Supabase
    // ref.read(reposeRepositoryProvider).resetAllMuscles();
  }

  // TODO: Future<void> loadFromRemote() async {
  //   final muscles = await ref.read(reposeRepositoryProvider).getAllMuscleRepose();
  //   state = AllMusclesReposeState.fromList(muscles);
  // }

  // TODO: Future<void> syncToRemote() async {
  //   await ref.read(reposeRepositoryProvider).saveAllMuscleRepose(state.asList);
  // }
}
