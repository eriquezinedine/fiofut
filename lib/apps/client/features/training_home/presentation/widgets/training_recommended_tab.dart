import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'training_card.dart';

class TrainingRecommendedTab extends StatelessWidget {
  const TrainingRecommendedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: AppSpacing.paddingHorizontalMd,
      children: [
        // Personalized section
        _RecommendedHeader(),
        const SizedBox(height: 16),

        TrainingCard(
          title: 'Push Pull Legs',
          subtitle: '6 días · 3 ciclos',
          level: 'Avanzado',
          icon: LucideIcons.repeat,
          iconColor: AppColors.purple,
        ),
        const SizedBox(height: 8),
        TrainingCard(
          title: 'Upper Lower Split',
          subtitle: '4 días · Fuerza',
          level: 'Intermedio',
          icon: LucideIcons.arrowUpDown,
          iconColor: AppColors.blue,
        ),
        const SizedBox(height: 8),
        TrainingCard(
          title: 'Cardio HIIT',
          subtitle: '25 min · Alta intensidad',
          level: 'Intermedio',
          icon: LucideIcons.heartPulse,
          iconColor: AppColors.error,
        ),
        const SizedBox(height: 8),
        TrainingCard(
          title: 'Movilidad & Flexibilidad',
          subtitle: '15 min · Recuperación',
          level: 'Principiante',
          icon: LucideIcons.move,
          iconColor: AppColors.teal,
        ),
        const SizedBox(height: 8),
        TrainingCard(
          title: 'Fuerza Funcional',
          subtitle: '35 min · Compuesto',
          level: 'Avanzado',
          icon: LucideIcons.zap,
          iconColor: AppColors.orange,
        ),

        const SizedBox(height: 80),
      ],
    );
  }
}

class _RecommendedHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.purple.withValues(alpha: 0.15),
            AppColors.blue.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.purple.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.sparkles, color: AppColors.purple, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Para ti',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Basado en tu progreso y objetivos',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
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
