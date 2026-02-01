import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/features/home/domain/models/models.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Height for the calories card.
const double _kCaloriesCardHeight = 164;

/// Sliver calories card that can pin during scroll.
class SliverCaloriesCard extends StatelessWidget {
  const SliverCaloriesCard({
    required this.caloriesData,
    this.onExpand,
    this.pinned = true,
    super.key,
  });

  final CaloriesData caloriesData;
  final VoidCallback? onExpand;
  final bool pinned;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: pinned,
      delegate: _CaloriesCardDelegate(
        caloriesData: caloriesData,
        onExpand: onExpand,
      ),
    );
  }
}

/// Delegate for the calories card.
class _CaloriesCardDelegate extends SliverPersistentHeaderDelegate {
  const _CaloriesCardDelegate({
    required this.caloriesData,
    this.onExpand,
  });

  final CaloriesData caloriesData;
  final VoidCallback? onExpand;

  @override
  double get minExtent => _kCaloriesCardHeight;

  @override
  double get maxExtent => _kCaloriesCardHeight;

  @override
  bool shouldRebuild(covariant _CaloriesCardDelegate oldDelegate) {
    return caloriesData != oldDelegate.caloriesData;
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: _kCaloriesCardHeight,
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: _CaloriesCardContent(
        caloriesData: caloriesData,
        onExpand: onExpand,
      ),
    );
  }
}

/// Internal content widget for CaloriesCard.
class _CaloriesCardContent extends StatelessWidget {
  const _CaloriesCardContent({
    required this.caloriesData,
    this.onExpand,
  });

  final CaloriesData caloriesData;
  final VoidCallback? onExpand;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          // Top section with calories and progress circle
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left: Calories display
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${caloriesData.consumed}',
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 42,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '/',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 20,
                            color: AppColors.textMuted,
                          ),
                        ),
                        Text(
                          '${caloriesData.goal}',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Calorías restantes',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),

                // Right: Progress circle with flame icon
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CustomPaint(
                    painter: _CaloriesProgressPainter(
                      progress: caloriesData.progress,
                    ),
                    child: const Center(
                      child: Icon(
                        LucideIcons.flame,
                        color: AppColors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // "Ver más" button
          GestureDetector(
            onTap: onExpand,
            child: Container(
              width: double.infinity,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFF2A2A2A),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Ver más',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    LucideIcons.chevronDown,
                    color: AppColors.textMuted,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CaloriesProgressPainter extends CustomPainter {
  final double progress;

  _CaloriesProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 6.0;

    // Background circle
    final bgPaint = Paint()
      ..color = const Color(0xFF2A2A2A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius - strokeWidth / 2, bgPaint);

    // Progress arc (green)
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = AppColors.primary
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
  }

  @override
  bool shouldRepaint(covariant _CaloriesProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
