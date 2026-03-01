import 'package:flutter/material.dart';

/// A widget that scales down its child on press and returns to normal on release.
///
/// Usage:
/// ```dart
/// TapScaleAnimation(
///   onTap: () => print('tapped'),
///   child: MyWidget(),
/// )
/// ```
class TapScaleAnimation extends StatefulWidget {
  const TapScaleAnimation({
    super.key,
    required this.child,
    this.onTap,
    this.scaleEnd = 0.95,
    this.duration = const Duration(milliseconds: 100),
    this.curve = Curves.easeInOut,
  });

  final Widget child;
  final VoidCallback? onTap;

  /// The scale value when pressed. Defaults to 0.8.
  final double scaleEnd;

  /// Animation duration. Defaults to 100ms.
  final Duration duration;

  /// Animation curve. Defaults to [Curves.easeInOut].
  final Curve curve;

  @override
  State<TapScaleAnimation> createState() => _TapScaleAnimationState();
}

class _TapScaleAnimationState extends State<TapScaleAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _scaleAnimation = Tween<double>(
      begin: 1,
      end: widget.scaleEnd,
    ).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  Future<void> _onTapUp(TapUpDetails details) async {
    // Wait for forward to complete so the scale effect is always visible,
    // even on quick taps.
    await _controller.forward();
    _controller.reverse();
    widget.onTap?.call();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
