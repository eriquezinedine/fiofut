import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/models.dart';
import '../../domain/providers/providers.dart';
import '../widgets/widgets.dart';

/// Pantalla 11: Duración de entrenamiento preferida
class TrainingDurationPage extends ConsumerWidget {
  const TrainingDurationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);
    final selected = state.data.trainingDuration;

    return OnboardingScaffold(
      progress: state.progress,
      title: '¿Cuánto tiempo quieres\nentrenar al día?',
      subtitle: 'Elige el tiempo que puedas dedicar de forma constante',
      onBack: () => notifier.previousStep(),
      bottomSection: OnboardingContinueButton(
        onPressed: selected != null ? () => notifier.nextStep() : null,
        isEnabled: selected != null,
        backgroundColor: selected?.getColor(),
      ),
      child: AppAnimatedColumn(
        children: [
          for (final duration in TrainingDuration.values) ...[
            _DurationCard(
              duration: duration,
              isSelected: selected == duration,
              onTap: () => notifier.updateTrainingDuration(duration),
            ),
            if (duration != TrainingDuration.values.last)
              const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _DurationCard extends StatelessWidget {
  const _DurationCard({
    required this.duration,
    required this.isSelected,
    required this.onTap,
  });

  final TrainingDuration duration;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = duration.getColor();
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
                duration.getIcon(),
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
                    duration.label,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: isSelected ? AppColors.white : AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    duration.subtitle,
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
