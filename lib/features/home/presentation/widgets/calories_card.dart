import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/features/home/domain/models/models.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Height for the collapsed calories card.
const double _kCaloriesCardCollapsedHeight = 156;

/// Height for the expanded calories card.
const double _kCaloriesCardExpandedHeight = 260;

/// Sliver calories card that can pin during scroll.
class SliverCaloriesCard extends StatelessWidget {
  const SliverCaloriesCard({
    required this.caloriesData,
    this.isExpanded = false,
    this.onExpand,
    this.pinned = true,
    super.key,
  });

  final CaloriesData caloriesData;
  final bool isExpanded;
  final VoidCallback? onExpand;
  final bool pinned;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: pinned,
      delegate: _CaloriesCardDelegate(
        caloriesData: caloriesData,
        isExpanded: isExpanded,
        onExpand: onExpand,
      ),
    );
  }
}

/// Delegate for the calories card.
class _CaloriesCardDelegate extends SliverPersistentHeaderDelegate {
  const _CaloriesCardDelegate({
    required this.caloriesData,
    required this.isExpanded,
    this.onExpand,
  });

  final CaloriesData caloriesData;
  final bool isExpanded;
  final VoidCallback? onExpand;

  double get _cardHeight =>
      isExpanded ? _kCaloriesCardExpandedHeight : _kCaloriesCardCollapsedHeight;

  @override
  double get minExtent => _cardHeight;

  @override
  double get maxExtent => _cardHeight;

  @override
  bool shouldRebuild(covariant _CaloriesCardDelegate oldDelegate) {
    return caloriesData != oldDelegate.caloriesData ||
        isExpanded != oldDelegate.isExpanded;
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: _cardHeight,
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: _CaloriesCardContent(
        caloriesData: caloriesData,
        isExpanded: isExpanded,
        onExpand: onExpand,
      ),
    );
  }
}

/// Internal content widget for CaloriesCard.
class _CaloriesCardContent extends StatelessWidget {
  const _CaloriesCardContent({
    required this.caloriesData,
    required this.isExpanded,
    this.onExpand,
  });

  final CaloriesData caloriesData;
  final bool isExpanded;
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

          // Macros row (only visible when expanded)
          if (isExpanded) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Row(
                children: [
                  Expanded(
                    child: _MacroCard(
                      label: 'Proteína',
                      value: caloriesData.protein,
                      goal: caloriesData.proteinGoal,
                      progress: caloriesData.proteinProgress,
                      progressColor: AppColors.redBright,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MacroCard(
                      label: 'Carbos',
                      value: caloriesData.carbs,
                      goal: caloriesData.carbsGoal,
                      progress: caloriesData.carbsProgress,
                      progressColor: AppColors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MacroCard(
                      label: 'Grasa',
                      value: caloriesData.fat,
                      goal: caloriesData.fatGoal,
                      progress: caloriesData.fatProgress,
                      progressColor: AppColors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Spacer to push button to bottom
          const Spacer(),

          // "Ver más" / "Ver menos" button
          GestureDetector(
            onTap: onExpand,
            child: Container(
              width: double.infinity,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isExpanded ? 'Ver menos' : 'Ver más',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    isExpanded ? LucideIcons.chevronUp : LucideIcons.chevronDown,
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

/// Macro nutrient card widget.
class _MacroCard extends StatelessWidget {
  const _MacroCard({
    required this.label,
    required this.value,
    required this.goal,
    required this.progress,
    required this.progressColor,
  });

  final String label;
  final int value;
  final int goal;
  final double progress;
  final Color progressColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Value row with goal
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$value',
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(width: 1),
              Text(
                '/${goal}g',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          // Label
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          // Progress bar
          Container(
            height: 6,
      width: 200,
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(3),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    Container(
                      width: constraints.maxWidth * progress.clamp(0.0, 1.0),
                      height: 6,
                      decoration: BoxDecoration(
                        color: progressColor,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ],
                );
              },
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
      ..color = AppColors.surfaceAlt
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
