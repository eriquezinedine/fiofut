import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/repose/domain/models/muscle_group.dart';
import 'package:fio_fut/apps/client/features/repose/domain/providers/muscle_repose_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        onPressed: () => Navigator.of(context).maybePop(),
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
// Section header
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

// ---------------------------------------------------------------------------
// Muscle group list (no scroll – embedded in parent ListView)
// ---------------------------------------------------------------------------

class _MuscleGroupList extends StatelessWidget {
  const _MuscleGroupList({required this.muscles});

  final List<MuscleGroup> muscles;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < muscles.length; i++) ...[
          MuscleGroupCard(muscle: muscles[i]),
          if (i < muscles.length - 1) const SizedBox(height: AppSpacing.xs),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// MuscleGroupCard – reads from its own provider instance
// ---------------------------------------------------------------------------

/// Card showing a muscle group's image, name, remaining time, progress bar
/// and percentage badge. State comes from [muscleReposeProvider].
class MuscleGroupCard extends ConsumerWidget {
  const MuscleGroupCard({required this.muscle, super.key});

  final MuscleGroup muscle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(muscleReposeProvider(muscle));

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: AppSpacing.borderRadiusXl,
      ),
      padding: const EdgeInsets.only(
        left: AppSpacing.xs,
        right: AppSpacing.md,
        top: AppSpacing.sm,
        bottom: AppSpacing.sm,
      ),
      child: Row(
        children: [
          _MuscleImage(muscle: muscle),
          AppSpacing.horizontalMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            muscle.label,
                            style: AppTextStyles.bodyMedium.copyWith(
                              letterSpacing: -0.32,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppSpacing.xxs),
                          Text(
                            state.remainingText,
                            style: AppTextStyles.caption.copyWith(
                              letterSpacing: -0.28,
                              color: AppColors.textDescription,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    ProgressBadge(
                      text: state.progressText,
                      color: state.progressColor,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                MuscleProgressBar(
                  progress: state.progress,
                  color: state.progressColor,
                  showKnob: state.sliderEnabled,
                  onChanged: state.sliderEnabled
                      ? (value) {
                          ref
                              .read(muscleReposeProvider(muscle).notifier)
                              .updateProgress(value);
                        }
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Muscle image placeholder
// ---------------------------------------------------------------------------

class _MuscleImage extends StatelessWidget {
  const _MuscleImage({required this.muscle});

  final MuscleGroup muscle;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppSpacing.borderRadiusLg,
      child: Container(
        width: AppSpacing.xxxl,
        height: AppSpacing.xxxl,
        color: AppColors.surfaceAlt,
        child: Center(
          child: Icon(
            Icons.fitness_center_rounded,
            color: muscle.defaultColor,
            size: AppSpacing.iconLg,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ProgressBadge – pill-shaped percentage badge
// ---------------------------------------------------------------------------

class ProgressBadge extends StatelessWidget {
  const ProgressBadge({
    required this.text,
    required this.color,
    super.key,
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.lg,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: AppSpacing.borderRadiusFull,
      ),
      child: Center(
        widthFactor: 1,
        child: Text(
          text,
          style: AppTextStyles.titleSmall.copyWith(
            letterSpacing: -0.28,
            color: color,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// MuscleProgressBar – interactive slider with circular knob
// ---------------------------------------------------------------------------

/// A thin horizontal progress bar with an optional draggable circular knob.
///
/// When [showKnob] is `false` the knob is hidden and gestures are disabled,
/// turning the widget into a read-only progress indicator.
class MuscleProgressBar extends StatelessWidget {
  const MuscleProgressBar({
    required this.progress,
    required this.color,
    this.showKnob = true,
    this.onChanged,
    super.key,
  });

  final double progress;
  final Color color;

  /// Whether to show the circular knob and allow interaction.
  final bool showKnob;

  /// Called when the user drags the knob to a new position.
  final ValueChanged<double>? onChanged;

  static const double _trackHeight = 4;
  static const double _knobSize = 14;
  static const double _knobBorder = 2;

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);
    final interactive = showKnob && onChanged != null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final trackWidth = constraints.maxWidth;
        final progressWidth = trackWidth * clamped;
        final knobLeft = (progressWidth - _knobSize / 2)
            .clamp(0.0, trackWidth - _knobSize);

        final bar = SizedBox(
          height: showKnob ? _knobSize : _trackHeight,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              // Track background
              Container(
                height: _trackHeight,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceAlt,
                  borderRadius: AppSpacing.borderRadiusFull,
                ),
              ),
              // Progress fill
              Container(
                height: _trackHeight,
                width: progressWidth,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: AppSpacing.borderRadiusFull,
                ),
              ),
              // Circular knob (only when enabled)
              if (showKnob)
                Positioned(
                  left: knobLeft,
                  child: Container(
                    width: _knobSize,
                    height: _knobSize,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: color,
                        width: _knobBorder,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );

        if (!interactive) return bar;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragUpdate: (details) {
            final v =
                (details.localPosition.dx / trackWidth).clamp(0.0, 1.0);
            onChanged!(v);
          },
          onTapDown: (details) {
            final v =
                (details.localPosition.dx / trackWidth).clamp(0.0, 1.0);
            onChanged!(v);
          },
          child: SizedBox(
            height: 32,
            child: Center(child: bar),
          ),
        );
      },
    );
  }
}
