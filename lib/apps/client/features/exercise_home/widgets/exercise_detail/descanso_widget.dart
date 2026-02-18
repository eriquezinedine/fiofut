import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class DescansoWidget extends StatelessWidget {
  const DescansoWidget({
    required this.seconds,
    required this.isRunning,
    required this.onToggle,
    required this.onAdjust,
    super.key,
  });

  final int seconds;
  final bool isRunning;
  final VoidCallback onToggle;

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
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: AppSpacing.md,
              children: [
                // -15s
                _AdjustButton(
                  label: '-15s',
                  onTap: () => onAdjust(-15),
                ),

                // Timer display
                Text(
                  _label,
                  style: AppTextStyles.h2.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                // +15s
                _AdjustButton(
                  label: '+15s',
                  onTap: () => onAdjust(15),
                ),
              ],
            ),
          ),

          // Toggle switch
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 40,
              height: 24,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: isRunning ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
              alignment:
                  isRunning ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusFull),
                ),
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
