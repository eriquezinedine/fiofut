import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/providers/providers.dart';
import '../widgets/widgets.dart';

class _MotivationalContent {
  const _MotivationalContent({
    required this.observation,
    required this.description,
  });

  final String observation;
  final String description;
}

_MotivationalContent _getLoseContent(int kgDiff) {
  if (kgDiff <= 5) {
    return const _MotivationalContent(
      observation: 'es un objetivo realista. \u00a1Lo tienes f\u00e1cil!',
      description:
          'Un peque\u00f1o ajuste en tu rutina es todo lo que necesitas. '
          'FioFit te gu\u00eda cada paso',
    );
  } else if (kgDiff <= 10) {
    return const _MotivationalContent(
      observation:
          'es un objetivo alcanzable. \u00a1Vas por buen camino!',
      description:
          'Con un plan personalizado y h\u00e1bitos consistentes, los '
          'resultados llegar\u00e1n antes de lo que piensas',
    );
  } else if (kgDiff <= 20) {
    return const _MotivationalContent(
      observation:
          'es un gran reto, \u00a1pero totalmente posible!',
      description:
          'Tu compromiso es lo m\u00e1s importante. FioFit se encarga de '
          'darte el plan, t\u00fa pones la actitud',
    );
  } else if (kgDiff <= 30) {
    return const _MotivationalContent(
      observation:
          'es un desaf\u00edo ambicioso. \u00a1Nada es imposible con constancia!',
      description:
          'Las grandes metas se logran un d\u00eda a la vez. '
          'Conf\u00eda en el proceso y s\u00e9 paciente contigo',
    );
  } else {
    return const _MotivationalContent(
      observation:
          'es una transformaci\u00f3n. \u00a1Dif\u00edcil, pero no imposible!',
      description:
          'Para cambios de este nivel, te sugerimos complementar tu plan '
          'con el acompa\u00f1amiento de un profesional',
    );
  }
}

_MotivationalContent _getGainContent(int kgDiff) {
  if (kgDiff <= 5) {
    return const _MotivationalContent(
      observation:
          'es un objetivo sencillo. \u00a1Lo lograr\u00e1s r\u00e1pido!',
      description:
          'Peque\u00f1os cambios en tu alimentaci\u00f3n pueden hacer una '
          'gran diferencia en poco tiempo',
    );
  } else if (kgDiff <= 10) {
    return const _MotivationalContent(
      observation: 'es un objetivo alcanzable. \u00a1T\u00fa puedes!',
      description:
          'FioFit te arma un plan para que ganes peso de forma gradual '
          'y sin descuidar tu salud',
    );
  } else if (kgDiff <= 20) {
    return const _MotivationalContent(
      observation:
          'es un buen reto. \u00a1La constancia es clave!',
      description:
          'Construir tu cuerpo ideal lleva tiempo, pero con el plan '
          'correcto cada semana suma',
    );
  } else {
    return const _MotivationalContent(
      observation:
          'es un objetivo ambicioso. \u00a1Paso a paso lo lograr\u00e1s!',
      description:
          'Metas grandes requieren acompa\u00f1amiento. Te sugerimos '
          'trabajar junto a un profesional de salud',
    );
  }
}

/// Pantalla 8: Pantalla motivacional
class MotivationalPage extends ConsumerWidget {
  const MotivationalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    final currentWeight = state.data.currentWeight ?? 0;
    final desiredWeight = state.data.desiredWeight ?? 0;
    final isKg = state.data.useKgUnit;
    final unit = isKg ? 'kg' : 'lb';

    final weightDiffKg = (currentWeight - desiredWeight).abs().round();
    final displayDiff =
        isKg ? weightDiffKg : (weightDiffKg * 2.20462).round();
    final displayCurrentWeight =
        isKg ? currentWeight.round() : (currentWeight * 2.20462).round();

    // Determine actual direction from the weight difference, not user selection
    final bool isLosing = desiredWeight < currentWeight;
    final bool isGaining = desiredWeight > currentWeight;

    final String goalWord;
    final String weightText;
    final String observation;
    final String description;
    final Color goalColor;

    if (isLosing) {
      goalWord = 'Perdiendo';
      weightText = '$displayDiff $unit';
      goalColor = AppColors.red;
      final content = _getLoseContent(weightDiffKg);
      observation = content.observation;
      description = content.description;
    } else if (isGaining) {
      goalWord = 'Ganando';
      weightText = '$displayDiff $unit';
      goalColor = AppColors.green;
      final content = _getGainContent(weightDiffKg);
      observation = content.observation;
      description = content.description;
    } else {
      goalWord = 'Tu peso actual';
      weightText = '$displayCurrentWeight $unit';
      goalColor = AppColors.blue;
      observation =
          'es la mejor decisi\u00f3n. \u00a1El equilibrio es clave!';
      description =
          'Mantener es tan importante como cambiar. FioFit te ayuda '
          'a no perder lo que ya lograste';
    }

    return OnboardingScaffold(
      progress: state.progress,
      onBack: () => notifier.previousStep(),
      centerContent: true,
      bottomSection: OnboardingContinueButton(
        onPressed: () => notifier.nextStep(),
        text: 'Continuar',
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          AppAnimatedColumn(
            children: [
              // Goal word or "Tu peso actual" for maintain
              AppAnimatedEntry(
                child: Text(
                  goalWord,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h2,
                ),
              ),
              const SizedBox(height: 8),
              // Weight display
              AppAnimatedEntry(
                child: Text(
                  weightText,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h1.copyWith(
                    color: goalColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Observation
              AppAnimatedEntry(
                child: SizedBox(
                  width: 320,
                  child: Text(
                    observation,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.h2.copyWith(
                      height: 1.3,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Description
              AppAnimatedEntry(
                child: SizedBox(
                  width: 320,
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
