import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../domain/models/models.dart';
import '../../domain/providers/providers.dart';
import '../widgets/widgets.dart';

/// Pantalla 6: Objetivo de peso
class WeightGoalPage extends ConsumerWidget {
  const WeightGoalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);
    final selectedGoal = state.data.weightGoal;

    return OnboardingScaffold(
      progress: state.progress,
      showBackButton: true,
      title: '¿Cuál es tu peso\nobjetivo?',
      subtitle: 'Selecciona tu meta principal para personalizar tu plan.',
      onBack: () => notifier.previousStep(),
      bottomSection: OnboardingContinueButton(
        onPressed: selectedGoal != null ? () => notifier.nextStep() : null,
        isEnabled: selectedGoal != null,
        backgroundColor: selectedGoal?.getColor(),
      ),
      child: AppAnimatedColumn(
        children: [
          _GoalOptionCard(
            icon: LucideIcons.trendingDown,
            iconBackgroundColor: AppColors.red.withValues(alpha: 0.13),
            iconColor: AppColors.red,
            title: 'Perder peso',
            subtitle: 'Reduce tu peso de forma saludable',
            isSelected: selectedGoal == WeightGoal.lose,
            selectedBorderColor: AppColors.red,
            onTap: () => notifier.updateWeightGoal(WeightGoal.lose),
          ),
          const SizedBox(height: 16),
          _GoalOptionCard(
            icon: LucideIcons.trendingUp,
            iconBackgroundColor: AppColors.green.withValues(alpha: 0.13),
            iconColor: AppColors.green,
            title: 'Ganar peso',
            subtitle: 'Aumenta masa muscular progresivamente',
            isSelected: selectedGoal == WeightGoal.gain,
            selectedBorderColor: AppColors.green,
            onTap: () => notifier.updateWeightGoal(WeightGoal.gain),
          ),
          const SizedBox(height: 16),
          _GoalOptionCard(
            icon: LucideIcons.minus,
            iconBackgroundColor: AppColors.blue.withValues(alpha: 0.13),
            iconColor: AppColors.blue,
            title: 'Mantener peso',
            subtitle: 'Conserva tu peso actual de forma equilibrada',
            isSelected: selectedGoal == WeightGoal.maintain,
            selectedBorderColor: AppColors.blue,
            onTap: () => notifier.updateWeightGoal(WeightGoal.maintain),
          ),
        ],
      ),
    );
  }
}

class _GoalOptionCard extends StatelessWidget {
  const _GoalOptionCard({
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.selectedBorderColor,
    required this.onTap,
  });

  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool isSelected;
  final Color selectedBorderColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppAnimatedEntry(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected?  selectedBorderColor: AppColors.card, width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


