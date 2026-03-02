import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../domain/models/models.dart';
import '../../domain/providers/providers.dart';
import '../widgets/widgets.dart';

/// Pantalla 3: Lugar de entrenamiento
class WorkoutLocationPage extends ConsumerWidget {
  const WorkoutLocationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);
    final selected = state.data.workoutLocation;

    return OnboardingScaffold(
      progress: state.progress,
      title: '\u00bfD\u00f3nde prefieres\nentrenar?',
      subtitle: '\u00a1Tenemos un programa para tu espacio de entrenamiento!',
      onBack: () => notifier.previousStep(),
      bottomSection: OnboardingContinueButton(
        onPressed: selected != null ? () => notifier.nextStep() : null,
        isEnabled: selected != null,
      ),
      child: AppAnimatedColumn(
        children: [
          const SizedBox(height: 8),
          _LocationCard(
            icon: LucideIcons.home,
            iconBackgroundColor: AppColors.red.withValues(alpha: 0.13),
            iconColor: AppColors.red,
            title: 'Casa',
            subtitle: 'Entrena desde la comodidad de tu hogar',
            isSelected: selected == WorkoutLocation.home,
            selectedBorderColor: AppColors.red,
            onTap: () =>
                notifier.updateWorkoutLocation(WorkoutLocation.home),
          ),
          const SizedBox(height: 16),
          _LocationCard(
            icon: LucideIcons.dumbbell,
            iconBackgroundColor: AppColors.blue.withValues(alpha: 0.13),
            iconColor: AppColors.blue,
            title: 'Gym',
            subtitle: 'Aprovecha al m\u00e1ximo el equipo del gimnasio',
            isSelected: selected == WorkoutLocation.gym,
            selectedBorderColor: AppColors.blue,
            onTap: () =>
                notifier.updateWorkoutLocation(WorkoutLocation.gym),
          ),
          const SizedBox(height: 16),
          _LocationCard(
            icon: LucideIcons.repeat,
            iconBackgroundColor: AppColors.green.withValues(alpha: 0.13),
            iconColor: AppColors.green,
            title: 'Ambos',
            subtitle: 'Combina entrenamientos en casa y gimnasio',
            isSelected: selected == WorkoutLocation.both,
            selectedBorderColor: AppColors.green,
            onTap: () =>
                notifier.updateWorkoutLocation(WorkoutLocation.both),
          ),
        ],
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard({
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
          border: Border.all(
            color: isSelected ? selectedBorderColor : AppColors.card,
            width: 2,
          ),
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
              child: Icon(icon, color: iconColor, size: 24),
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
