import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// A button displaying the current playback speed with a gauge icon.
///
/// Used in video player interfaces to allow users to cycle through
/// different playback speeds (e.g., 0.5x, 1.0x, 1.5x).
class PlaybackSpeedButton extends StatelessWidget {
  const PlaybackSpeedButton({
    required this.speed,
    required this.onTap,
    super.key,
  });

  /// Current playback speed value (e.g., 1.0, 1.5).
  final double speed;

  /// Callback when the button is tapped to change speed.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomGestureDetector(
      onTap: onTap,
      child: ColoredBox(
        color: Colors.transparent,
        child: Column(
          spacing: 7,
          children: [
            Icon(LucideIcons.playCircle,size: 24,),
            Text('${speed}x', style: AppTextStyles.small.copyWith(color: AppColors.white),)
          ],
        ),
      ),
    );
  }
}
