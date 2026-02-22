import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:model/model.dart';

import 'muscle_repose_group_card.dart';
import 'provider/muscle_repose_provider.dart';

export 'muscle_repose_group_card.dart';
export 'muscle_progress_bar.dart';
export 'progress_badge.dart';
export 'provider/muscle_repose_provider.dart';

// ---------------------------------------------------------------------------
// Constants
// ---------------------------------------------------------------------------

const _largeMuscleGroups = {
  MuscleGroup.chest,
  MuscleGroup.back,
  MuscleGroup.lowerBack,
  MuscleGroup.quadriceps,
  MuscleGroup.hamstrings,
  MuscleGroup.glutes,
};

/// Default list of muscles shown for development / preview.
const kFakeMuscles = [
  // Large
  MuscleRepose(
    muscle: Muscle(id: '1', name: 'Pecho', isMain: true, muscleGroup: MuscleGroup.chest),
    percentage: 100,
  ),
  MuscleRepose(
    muscle: Muscle(id: '2', name: 'Espalda Alta', isMain: true, muscleGroup: MuscleGroup.back),
    percentage: 80,
  ),
  MuscleRepose(
    muscle: Muscle(id: '3', name: 'Espalda Baja', isMain: true, muscleGroup: MuscleGroup.lowerBack),
    percentage: 65,
  ),
  MuscleRepose(
    muscle: Muscle(id: '4', name: 'Cuadriceps', isMain: true, muscleGroup: MuscleGroup.quadriceps),
    percentage: 45,
  ),
  MuscleRepose(
    muscle: Muscle(id: '5', name: 'Isquiotibiales', isMain: true, muscleGroup: MuscleGroup.hamstrings),
    percentage: 20,
  ),
  MuscleRepose(
    muscle: Muscle(id: '6', name: 'Gluteos', isMain: true, muscleGroup: MuscleGroup.glutes),
    percentage: 95,
  ),
  // Small
  MuscleRepose(
    muscle: Muscle(id: '7', name: 'Hombro Frontal', isMain: false, muscleGroup: MuscleGroup.frontDeltoid),
    percentage: 100,
  ),
  MuscleRepose(
    muscle: Muscle(id: '8', name: 'Hombro Lateral', isMain: false, muscleGroup: MuscleGroup.lateralDeltoid),
    percentage: 75,
  ),
  MuscleRepose(
    muscle: Muscle(id: '9', name: 'Biceps', isMain: false, muscleGroup: MuscleGroup.biceps),
    percentage: 55,
  ),
  MuscleRepose(
    muscle: Muscle(id: '10', name: 'Triceps', isMain: false, muscleGroup: MuscleGroup.triceps),
    percentage: 30,
  ),
  MuscleRepose(
    muscle: Muscle(id: '11', name: 'Antebrazos', isMain: false, muscleGroup: MuscleGroup.forearms),
    percentage: 100,
  ),
  MuscleRepose(
    muscle: Muscle(id: '12', name: 'Abdominales', isMain: false, muscleGroup: MuscleGroup.abs),
    percentage: 10,
  ),
  MuscleRepose(
    muscle: Muscle(id: '13', name: 'Gemelos', isMain: false, muscleGroup: MuscleGroup.calves),
    percentage: 70,
  ),
  MuscleRepose(
    muscle: Muscle(id: '14', name: 'Oblicuos', isMain: false, muscleGroup: MuscleGroup.obliques),
    percentage: 60,
  ),
  MuscleRepose(
    muscle: Muscle(id: '15', name: 'Abductores', isMain: false, muscleGroup: MuscleGroup.abductors),
    percentage: 85,
  ),
  MuscleRepose(
    muscle: Muscle(id: '16', name: 'Aductores', isMain: false, muscleGroup: MuscleGroup.adductors),
    percentage: 90,
  ),
  MuscleRepose(
    muscle: Muscle(id: '17', name: 'Deltoides Posterior', isMain: false, muscleGroup: MuscleGroup.rearDeltoid),
    percentage: 40,
  ),
  MuscleRepose(
    muscle: Muscle(id: '18', name: 'Trapecios', isMain: false, muscleGroup: MuscleGroup.traps),
    percentage: 50,
  ),
];

// ---------------------------------------------------------------------------
// Main widget
// ---------------------------------------------------------------------------

/// Displays muscle groups organized by size with rest-progress sliders.
///
/// Each [MuscleRepose] reads from its own [muscleReposeProvider] instance
/// (autoDispose family) so every card has independent state.
class ReposeListSliders extends ConsumerWidget {
  const ReposeListSliders({
    required this.muscles,
    super.key,
  });

  final List<MuscleRepose> muscles;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final large = muscles
        .where((m) => _largeMuscleGroups.contains(m.muscle.muscleGroup))
        .toList();
    final small = muscles
        .where((m) => !_largeMuscleGroups.contains(m.muscle.muscleGroup))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context, ref),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          if (large.isNotEmpty) ...[
            _SectionHeader(
              title: 'Grupos musculares grandes (${large.length})',
            ),
            const SizedBox(height: 45),
            _MuscleGroupList(muscles: large),
          ],
          if (small.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            _SectionHeader(
              title: 'Grupos musculares peque\u00f1os (${small.length})',
            ),
            const SizedBox(height: 45),
            _MuscleGroupList(muscles: small),
          ],
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, size: AppSpacing.iconMd),
        color: AppColors.textPrimary,
        onPressed: () => context.pop(),
      ),
      actions: [
        TextButton(
          onPressed: () {
            for (final muscle in muscles) {
              ref.read(muscleReposeProvider(muscle).notifier).reset();
            }
          },
          child: Text(
            'Reiniciar',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              letterSpacing: -0.32,
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Private helpers (small, only used here)
// ---------------------------------------------------------------------------

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.bodyMedium.copyWith(
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _MuscleGroupList extends StatelessWidget {
  const _MuscleGroupList({required this.muscles});

  final List<MuscleRepose> muscles;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < muscles.length; i++) ...[
          MuscleReposeGroupCard(muscleRepose: muscles[i], sliderEnabled: true),
          if (i < muscles.length - 1) const SizedBox(height: AppSpacing.xs),
        ],
      ],
    );
  }
}
