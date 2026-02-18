import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DescansoWidget extends StatelessWidget {
  const DescansoWidget({
    required this.seconds,
    required this.isRunning,
    required this.onToggle,
    required this.onAdjust,
    this.onStop,
    super.key,
  });

  final int seconds;
  final bool isRunning;
  final VoidCallback onToggle;
  final VoidCallback? onStop;

  /// [delta] is +15 or -15
  final void Function(int delta) onAdjust;

  String get _label {
    final m = (seconds ~/ 60).toString().padLeft(1, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary),
      ),
      child: Row(
        children: [
          // Play / Pause toggle
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                isRunning ? LucideIcons.pause : LucideIcons.play,
                color: AppColors.black,
                size: 18,
              ),
            ),
          ),

          // Timer area
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: AppSpacing.md,
              children: [
                _AdjustButton(
                  label: '-15s',
                  onTap: () => onAdjust(-15),
                ),
                Text(
                  _label,
                  style: AppTextStyles.h2.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                _AdjustButton(
                  label: '+15s',
                  onTap: () => onAdjust(15),
                ),
              ],
            ),
          ),

          // Stop button
          GestureDetector(
            onTap: onStop,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                LucideIcons.square,
                color: AppColors.white,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdjustButton extends StatelessWidget {
  const _AdjustButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomGestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textDescription,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
