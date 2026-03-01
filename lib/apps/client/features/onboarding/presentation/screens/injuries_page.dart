import 'package:fio_fut/apps/client/features/onboarding/presentation/widgets/animation_color_muscle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:model/model.dart';

import '../../domain/providers/providers.dart';
import '../widgets/widgets.dart';

/// Pantalla 10: Lesiones o limitaciones físicas
class InjuriesPage extends ConsumerStatefulWidget {
  const InjuriesPage({super.key});

  @override
  ConsumerState<InjuriesPage> createState() => _InjuriesPageState();
}

class _InjuriesPageState extends ConsumerState<InjuriesPage> {
  Set<MuscleGroup> _selectedMuscles = {};

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);
    final hasSelection = _selectedMuscles.isNotEmpty;

    return Stack(
      children: [OnboardingScaffold(
        progress: state.progress,
        title: '¿Qué parte del cuerpo quieres trabajar?',
        scrollable: false,
        onBack: () => notifier.previousStep(),
        // bottomSection: 
        child: AnimationColorMuscle(
          onSelectionChanged: (muscles) {
            setState(() => _selectedMuscles = muscles);
          },
        ),
      ),
      Align(
       alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 16).copyWith(bottom: MediaQuery.paddingOf(context).bottom + 8),
          child: OnboardingContinueButton(
          isEnabled: hasSelection,
          onPressed: () => notifier.nextStep(),
                ),
        ),
      )
      ],
    );
  }
}

