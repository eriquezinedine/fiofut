import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/models.dart';
import '../../domain/providers/providers.dart';
import '../widgets/widgets.dart';

/// Pantalla 10: Nivel de actividad física
class ActivityLevelPage extends ConsumerWidget {
  const ActivityLevelPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);
    final selected = state.data.activityLevel;

    return OnboardingScaffold(
      progress: state.progress,
      title: '¿Qué tan activo eres?',
      subtitle: 'Esto nos ayuda a personalizar tu plan de entrenamiento',
      onBack: () => notifier.previousStep(),
      bottomSection: OnboardingContinueButton(
        onPressed: selected != null ? () => notifier.nextStep() : null,
        isEnabled: selected != null,
        backgroundColor: selected?.getColor(),
      ),
      child: AppAnimatedColumn(
        children: [
          for (final level in ActivityLevel.values) ...[
            _ActivityCard(
              level: level,
              isSelected: selected == level,
              onTap: () => notifier.updateActivityLevel(level),
            ),
            if (level != ActivityLevel.values.last) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    required this.level,
    required this.isSelected,
    required this.onTap,
  });

  final ActivityLevel level;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = level.getColor();
    return TapScaleAnimation(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : AppColors.card,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.13),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                level.getIcon(),
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    level.label,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: isSelected ? AppColors.white : AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    level.subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMuted,
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
