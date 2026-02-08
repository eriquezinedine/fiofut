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
    final selectedLocations = state.data.workoutLocations;

    return OnboardingScaffold(
      progress: state.progress,
      title: '¿Dónde prefieres\nentrenar?',
      subtitle: '¡Tenemos un programa para tu espacio de entrenamiento!',
      onBack: () => notifier.previousStep(),
      bottomSection: OnboardingContinueButton(
        onPressed: selectedLocations.isNotEmpty ? () => notifier.nextStep() : null,
        isEnabled: selectedLocations.isNotEmpty,
      ),
      child: Row(
        children: [
          Expanded(
            child: _LocationCard(
              icon: LucideIcons.home,
              iconBackgroundColor: AppColors.red.withValues(alpha: 0.13),
              iconColor: AppColors.red,
              title: 'Casa',
              isSelected: selectedLocations.contains(WorkoutLocation.home),
              selectedBorderColor: AppColors.red,
              onTap: () => notifier.toggleWorkoutLocation(WorkoutLocation.home),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _LocationCard(
              icon: LucideIcons.dumbbell,
              iconBackgroundColor: AppColors.blue.withValues(alpha: 0.13),
              iconColor: AppColors.blue,
              title: 'Gym',
              isSelected: selectedLocations.contains(WorkoutLocation.gym),
              selectedBorderColor: AppColors.blue,
              onTap: () => notifier.toggleWorkoutLocation(WorkoutLocation.gym),
            ),
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
    required this.isSelected,
    required this.selectedBorderColor,
    required this.onTap,
  });

  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;
  final String title;
  final bool isSelected;
  final Color selectedBorderColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomGestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: selectedBorderColor, width: 2)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

