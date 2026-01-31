import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A GestureDetector that provides haptic feedback on tap.
///
/// This widget wraps [GestureDetector] and adds a light haptic vibration
/// (10% intensity) when tapped.
class CustomGestureDetector extends StatelessWidget {
  const CustomGestureDetector({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.behavior,
    this.enableHaptic = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDoubleTap;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final VoidCallback? onTapCancel;
  final HitTestBehavior? behavior;
  final bool enableHaptic;

  void _handleTap() {
    if (enableHaptic) {
      HapticFeedback.lightImpact();
    }
    onTap?.call();
  }

  void _handleLongPress() {
    if (enableHaptic) {
      HapticFeedback.mediumImpact();
    }
    onLongPress?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: behavior,
      onTap: onTap != null ? _handleTap : null,
      onLongPress: onLongPress != null ? _handleLongPress : null,
      onDoubleTap: onDoubleTap,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      child: child,
    );
  }
}
