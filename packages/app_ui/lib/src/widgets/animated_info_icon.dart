import 'package:flutter/material.dart';

import '../colors/app_colors.dart';

class AnimatedInfoIcon extends StatefulWidget {
  const AnimatedInfoIcon({
    super.key,
    this.onTap,
    this.size = 32,
    this.iconSize = 16,
    this.color,
    this.icon = Icons.info_outline,
  });

  final VoidCallback? onTap;
  final double size;
  final double iconSize;
  final Color? color;
  final IconData icon;

  @override
  State<AnimatedInfoIcon> createState() => _AnimatedInfoIconState();
}

class _AnimatedInfoIconState extends State<AnimatedInfoIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = widget.color ?? AppColors.info;

    return GestureDetector(
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: effectiveColor.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            widget.icon,
            color: effectiveColor,
            size: widget.iconSize,
          ),
        ),
      ),
    );
  }
}
