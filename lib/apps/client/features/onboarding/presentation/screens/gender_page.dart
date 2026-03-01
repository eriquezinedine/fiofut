import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../domain/models/models.dart';
import '../../domain/providers/providers.dart';
import '../widgets/widgets.dart';

/// Pantalla 2: Género del usuario
class GenderPage extends ConsumerWidget {
  const GenderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);
    final selectedGender = state.data.gender;

    return OnboardingScaffold(
      progress: state.progress,
      title: '¿Cuál es tu género?',
      onBack: () => notifier.previousStep(),
      bottomSection: OnboardingContinueButton(
        onPressed: selectedGender != null ? () => notifier.nextStep() : null,
        isEnabled: selectedGender != null,
        backgroundColor: selectedGender?.getColor(),
      ),
      child: AppAnimatedColumn(
        children: [
          const SizedBox(height: 8),
          _GenderCard(
            icon: LucideIcons.user,
            iconBackgroundColor: AppColors.blue.withValues(alpha: 0.13),
            iconColor: AppColors.blue,
            label: 'Masculino',
            isSelected: selectedGender == Gender.male,
            onTap: () => notifier.updateGender(Gender.male),
          ),
          const SizedBox(height: 16),
          _GenderCard(
            icon: LucideIcons.user,
            iconBackgroundColor: AppColors.pink.withValues(alpha: 0.13),
            iconColor: AppColors.pink,
            label: 'Femenino',
            isSelected: selectedGender == Gender.female,
            onTap: () => notifier.updateGender(Gender.female),
          ),
        ],
      ),
    );
  }
}

class _GenderCard extends StatelessWidget {
  const _GenderCard({
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TapScaleAnimation(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected? iconColor : AppColors.card, width: 2),
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
            Text(
              label,
              style: AppTextStyles.titleMedium.copyWith(
                color: isSelected ? AppColors.white : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
