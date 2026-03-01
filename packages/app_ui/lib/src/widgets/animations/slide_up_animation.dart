import 'package:flutter/material.dart';

/// A widget that slides in from the left-bottom to its original position
/// with a fade-in effect.
///
/// Usage:
/// ```dart
/// SlideUpAnimation(
///   child: MyWidget(),
/// )
/// ```
class SlideUpAnimation extends StatefulWidget {
  const SlideUpAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.delay = Duration.zero,
    this.curve = Curves.easeOutCubic,
    this.offsetX = -20,
    this.offsetY = 20,
  });

  final Widget child;

  /// Animation duration. Defaults to 500ms.
  final Duration duration;

  /// Delay before the animation starts. Defaults to zero.
  final Duration delay;

  /// Animation curve. Defaults to [Curves.easeOutCubic].
  final Curve curve;

  /// Horizontal offset to start from. Negative = left. Defaults to -20.
  final double offsetX;

  /// Vertical offset to start from. Positive = below. Defaults to 20.
  final double offsetY;

  @override
  State<SlideUpAnimation> createState() => _SlideUpAnimationState();
}

class _SlideUpAnimationState extends State<SlideUpAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _position;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    final curved = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );
    _position = Tween<Offset>(
      begin: Offset(widget.offsetX, widget.offsetY),
      end: Offset.zero,
    ).animate(curved);
    _opacity = Tween<double>(begin: 0, end: 1).animate(curved);
    _start();
  }

  Future<void> _start() async {
    if (widget.delay > Duration.zero) {
      await Future<void>.delayed(widget.delay);
      if (!mounted) return;
    }
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.translate(
            offset: _position.value,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
