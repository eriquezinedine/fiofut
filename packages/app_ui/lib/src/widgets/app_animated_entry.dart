import 'package:flutter/material.dart';

/// A widget that combines fade-in, slide and tap-scale animations.
///
/// Usage:
/// ```dart
/// // Entry animation + tap scale
/// AppAnimatedEntry(
///   onTap: () => print('tapped'),
///   child: MyWidget(),
/// )
///
/// // Staggered list
/// for (var i = 0; i < items.length; i++)
///   AppAnimatedEntry(
///     delay: Duration(milliseconds: i * 100),
///     onTap: () {},
///     child: ItemWidget(items[i]),
///   )
///
/// // Entry only, no tap effect
/// AppAnimatedEntry(
///   enableTapScale: false,
///   child: MyWidget(),
/// )
/// ```
class AppAnimatedEntry extends StatefulWidget {
  const AppAnimatedEntry({
    super.key,
    required this.child,
    this.onTap,
    this.duration = const Duration(milliseconds: 500),
    this.delay = Duration.zero,
    this.curve = Curves.easeOutCubic,
    this.offsetX = -20,
    this.offsetY = 20,
    this.enableTapScale = true,
    this.scaleEnd = 0.95,
    this.scaleDuration = const Duration(milliseconds: 100),
  });

  final Widget child;
  final VoidCallback? onTap;

  /// Entry animation duration. Defaults to 500ms.
  final Duration duration;

  /// Delay before the entry animation starts. Defaults to zero.
  final Duration delay;

  /// Entry animation curve. Defaults to [Curves.easeOutCubic].
  final Curve curve;

  /// Horizontal offset to start from. Negative = left. Defaults to -20.
  final double offsetX;

  /// Vertical offset to start from. Positive = below. Defaults to 20.
  final double offsetY;

  /// Whether to enable the tap scale effect. Defaults to true.
  final bool enableTapScale;

  /// The scale value when pressed. Defaults to 0.95.
  final double scaleEnd;

  /// Tap scale animation duration. Defaults to 100ms.
  final Duration scaleDuration;

  @override
  State<AppAnimatedEntry> createState() => _AppAnimatedEntryState();
}

class _AppAnimatedEntryState extends State<AppAnimatedEntry>
    with TickerProviderStateMixin {
  // Entry animation
  late final AnimationController _entryController;
  late final Animation<Offset> _position;
  late final Animation<double> _opacity;

  // Tap scale animation
  late final AnimationController _scaleController;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    final curved = CurvedAnimation(
      parent: _entryController,
      curve: widget.curve,
    );
    _position = Tween<Offset>(
      begin: Offset(widget.offsetX, widget.offsetY),
      end: Offset.zero,
    ).animate(curved);
    _opacity = Tween<double>(begin: 0, end: 1).animate(curved);

    _scaleController = AnimationController(
      vsync: this,
      duration: widget.scaleDuration,
    );
    _scale = Tween<double>(begin: 1, end: widget.scaleEnd).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    _startEntry();
  }

  Future<void> _startEntry() async {
    if (widget.delay > Duration.zero) {
      await Future<void>.delayed(widget.delay);
      if (!mounted) return;
    }
    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _scaleController.forward();
  }

  Future<void> _onTapUp(TapUpDetails details) async {
    await _scaleController.forward();
    _scaleController.reverse();
    widget.onTap?.call();
  }

  void _onTapCancel() {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = widget.child;

    // Tap scale layer
    if (widget.enableTapScale && widget.onTap != null) {
      child = GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: _scale,
          builder: (context, c) {
            return Transform.scale(scale: _scale.value, child: c);
          },
          child: child,
        ),
      );
    }

    // Entry animation layer
    return AnimatedBuilder(
      animation: _entryController,
      builder: (context, c) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.translate(
            offset: _position.value,
            child: c,
          ),
        );
      },
      child: child,
    );
  }
}
