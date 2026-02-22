import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/repose/domain/models/muscle_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

/// Default list of muscles shown for development / preview.
const kFakeMuscles = [
  // Large
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
  // Small
  MuscleGroup.shoulderLeft,
  MuscleGroup.shoulderRight,
  MuscleGroup.bicepLeft,
  MuscleGroup.bicepRight,
  MuscleGroup.tricepLeft,
  MuscleGroup.tricepRight,
  MuscleGroup.forearmLeft,
  MuscleGroup.forearmRight,
  MuscleGroup.abs,
  MuscleGroup.calfLeft,
  MuscleGroup.calfRight,
];

// ---------------------------------------------------------------------------
// Main widget
// ---------------------------------------------------------------------------

/// Displays muscle groups organized by size with rest-progress sliders.
///
/// Each [MuscleGroup] reads from its own [muscleReposeProvider] instance
/// (autoDispose family) so every card has independent state.
class ReposeListSliders extends ConsumerWidget {
  const ReposeListSliders({
    required this.muscles,
    super.key,
  });

  final List<MuscleGroup> muscles;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final large =
        muscles.where((m) => _largeMuscleGroups.contains(m)).toList();
    final small =
        muscles.where((m) => !_largeMuscleGroups.contains(m)).toList();

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

  final List<MuscleGroup> muscles;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < muscles.length; i++) ...[
          MuscleReposeGroupCard(muscle: muscles[i],sliderEnabled: true,),
          if (i < muscles.length - 1) const SizedBox(height: AppSpacing.xs),
        ],
      ],
    );
  }
}
