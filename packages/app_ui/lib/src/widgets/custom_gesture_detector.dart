import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A GestureDetector that provides haptic feedback and a scale-down
/// animation on tap.
class CustomGestureDetector extends StatefulWidget {
  const CustomGestureDetector({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.behavior,
    this.enableHaptic = true,
    this.enableScale = true,
    this.scaleEnd = 0.95,
    this.scaleDuration = const Duration(milliseconds: 100),
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDoubleTap;
  final HitTestBehavior? behavior;
  final bool enableHaptic;

  /// Whether to animate scale on press. Defaults to true.
  final bool enableScale;

  /// The scale value when pressed. Defaults to 0.95.
  final double scaleEnd;

  /// Duration of the scale animation. Defaults to 100ms.
  final Duration scaleDuration;

  @override
  State<CustomGestureDetector> createState() => _CustomGestureDetectorState();
}

class _CustomGestureDetectorState extends State<CustomGestureDetector>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.scaleDuration,
    );
    _scaleAnimation = Tween<double>(
      begin: 1,
      end: widget.scaleEnd,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.enableScale) _controller.forward();
  }

  Future<void> _onTapUp(TapUpDetails details) async {
    if (widget.enableScale) {
      await _controller.forward();
      _controller.reverse();
    }
    if (widget.enableHaptic) HapticFeedback.lightImpact();
    widget.onTap?.call();
  }

  void _onTapCancel() {
    if (widget.enableScale) _controller.reverse();
  }

  void _handleLongPress() {
    if (widget.enableHaptic) HapticFeedback.mediumImpact();
    widget.onLongPress?.call();
  }

  @override
  Widget build(BuildContext context) {
    final child = GestureDetector(
      behavior: widget.behavior ?? HitTestBehavior.opaque,
      onTapDown: widget.onTap != null ? _onTapDown : null,
      onTapUp: widget.onTap != null ? _onTapUp : null,
      onTapCancel: widget.onTap != null ? _onTapCancel : null,
      onLongPress: widget.onLongPress != null ? _handleLongPress : null,
      onDoubleTap: widget.onDoubleTap,
      child: widget.child,
    );

    if (!widget.enableScale) return child;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, c) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: c,
        );
      },
      child: child,
    );
  }
}
