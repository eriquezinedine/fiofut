import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'training_card.dart';

class TrainingAppTab extends StatelessWidget {
  const TrainingAppTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: AppSpacing.paddingHorizontalMd,
      children: [
        // Featured
        _FeaturedTrainingCard(
          title: 'Full Body Express',
          subtitle: '30 min · 12 ejercicios',
          level: 'Intermedio',
          imageGradient: AppColors.primaryGradient,
        ),
        const SizedBox(height: 20),

        // Section header
        Text(
          'Populares',
          style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        TrainingCard(
          title: 'Pecho & Tríceps',
          subtitle: '45 min · 8 ejercicios',
          level: 'Intermedio',
          icon: LucideIcons.flame,
          iconColor: AppColors.orange,
        ),
        const SizedBox(height: 8),
        TrainingCard(
          title: 'Pierna Completa',
          subtitle: '50 min · 10 ejercicios',
          level: 'Avanzado',
          icon: LucideIcons.zap,
          iconColor: AppColors.error,
        ),
        const SizedBox(height: 8),
        TrainingCard(
          title: 'Core & Abs',
          subtitle: '20 min · 6 ejercicios',
          level: 'Principiante',
          icon: LucideIcons.target,
          iconColor: AppColors.primary,
        ),
        const SizedBox(height: 8),
        TrainingCard(
          title: 'Espalda & Bíceps',
          subtitle: '40 min · 9 ejercicios',
          level: 'Intermedio',
          icon: LucideIcons.flame,
          iconColor: AppColors.orange,
        ),

        const SizedBox(height: 80),
      ],
    );
  }
}

class _FeaturedTrainingCard extends StatelessWidget {
  const _FeaturedTrainingCard({
    required this.title,
    required this.subtitle,
    required this.level,
    required this.imageGradient,
  });

  final String title;
  final String subtitle;
  final String level;
  final List<Color> imageGradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: imageGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Stack(
        children: [
          // Pattern overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.white.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    level,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: AppTextStyles.h2.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.black.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
