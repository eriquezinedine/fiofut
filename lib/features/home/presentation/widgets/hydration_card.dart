import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/features/home/domain/models/models.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Height for the hydration card.
const double _kHydrationCardHeight = 80;

/// Sliver hydration card that can pin during scroll.
class SliverHydrationCard extends StatelessWidget {
  const SliverHydrationCard({
    required this.hydrationData,
    required this.onAddWater,
    this.onTap,
    this.pinned = true,
    super.key,
  });

  final HydrationData hydrationData;
  final ValueChanged<int> onAddWater;
  final VoidCallback? onTap;
  final bool pinned;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: pinned,
      delegate: _HydrationCardDelegate(
        hydrationData: hydrationData,
        onAddWater: onAddWater,
        onTap: onTap,
      ),
    );
  }
}

/// Delegate for the hydration card.
class _HydrationCardDelegate extends SliverPersistentHeaderDelegate {
  const _HydrationCardDelegate({
    required this.hydrationData,
    required this.onAddWater,
    this.onTap,
  });

  final HydrationData hydrationData;
  final ValueChanged<int> onAddWater;
  final VoidCallback? onTap;

  @override
  double get minExtent => _kHydrationCardHeight;

  @override
  double get maxExtent => _kHydrationCardHeight;

  @override
  bool shouldRebuild(covariant _HydrationCardDelegate oldDelegate) {
    return hydrationData != oldDelegate.hydrationData;
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: _kHydrationCardHeight,
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: _HydrationCardContent(
        hydrationData: hydrationData,
        onAddWater: onAddWater,
        onTap: onTap,
      ),
    );
  }
}

/// Internal content widget for HydrationCard.
class _HydrationCardContent extends StatelessWidget {
  const _HydrationCardContent({
    required this.hydrationData,
    required this.onAddWater,
    this.onTap,
  });

  final HydrationData hydrationData;
  final ValueChanged<int> onAddWater;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final progressPercent =
        (hydrationData.progress * 100).clamp(0.0, 100.0).toInt();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            // Left: Circular progress with percentage
            SizedBox(
              width: 48,
              height: 48,
              child: CustomPaint(
                painter: _HydrationProgressPainter(
                  progress: hydrationData.progress,
                ),
                child: Center(
                  child: Text(
                    '$progressPercent%',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blue,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Middle: Hydration info
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hidratación',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${hydrationData.consumed} / ${hydrationData.goal} ml',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            // Right: Chevron arrow
            Icon(
              LucideIcons.chevronRight,
              color: AppColors.textSecondary,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

class _HydrationProgressPainter extends CustomPainter {
  final double progress;

  _HydrationProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 3.0;

    // Background circle
    final bgPaint = Paint()
      ..color = AppColors.card
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius - strokeWidth / 2, bgPaint);

    // Progress arc (blue)
    final progressPaint = Paint()
      ..color = AppColors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress.clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _HydrationProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
