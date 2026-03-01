import 'package:flutter/material.dart';

import 'app_animated_entry.dart';

/// A Column that staggers [AppAnimatedEntry] on each child automatically.
///
/// Usage:
/// ```dart
/// AppAnimatedColumn(
///   children: [
///     Text('First'),
///     Text('Second'),
///     Text('Third'),
///   ],
/// )
/// ```
class AppAnimatedColumn extends StatelessWidget {
  const AppAnimatedColumn({
    super.key,
    required this.children,
    this.staggerDelay = const Duration(milliseconds: 80),
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeOutCubic,
    this.offsetX = -20,
    this.offsetY = 20,
  });

  final List<Widget> children;

  /// Delay between each child's animation. Defaults to 80ms.
  final Duration staggerDelay;

  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;

  /// Entry animation duration per child. Defaults to 500ms.
  final Duration duration;

  /// Entry animation curve. Defaults to [Curves.easeOutCubic].
  final Curve curve;

  /// Horizontal offset. Defaults to -20.
  final double offsetX;

  /// Vertical offset. Defaults to 20.
  final double offsetY;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: [
        for (var i = 0; i < children.length; i++)
          AppAnimatedEntry(
            delay: staggerDelay * i,
            duration: duration,
            curve: curve,
            offsetX: offsetX,
            offsetY: offsetY,
            enableTapScale: false,
            child: children[i],
          ),
      ],
    );
  }
}
