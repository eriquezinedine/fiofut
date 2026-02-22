import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

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
