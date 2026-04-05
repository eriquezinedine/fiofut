import 'dart:math' as math;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HydrationCircle extends StatelessWidget {
  const HydrationCircle({
    super.key,
    required this.consumed,
    required this.goal,
    required this.progress,
    required this.progressPercent,
  });

  final int consumed;
  final int goal;
  final double progress;
  final int progressPercent;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            width: 180,
            height: 180,
            child: CustomPaint(
              painter: _HydrationCirclePainter(progress: progress),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      LucideIcons.droplets,
                      color: AppColors.blue,
                      size: 32,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$consumed ml',
                      style: AppTextStyles.h1.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 30,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'de $goal ml',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '$progressPercent% completado',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.blue,
            ),
          ),
        ],
      ),
    );
  }
}

class _HydrationCirclePainter extends CustomPainter {
  final double progress;

  _HydrationCirclePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 12.0;

    final bgPaint = Paint()
      ..color = AppColors.surfaceAlt
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius - strokeWidth / 2, bgPaint);

    if (progress > 0) {
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
  }

  @override
  bool shouldRepaint(covariant _HydrationCirclePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
