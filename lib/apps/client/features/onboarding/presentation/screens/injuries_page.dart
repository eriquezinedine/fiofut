import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/providers/providers.dart';
import '../widgets/widgets.dart';

/// Pantalla 10: Lesiones o limitaciones físicas
class InjuriesPage extends ConsumerStatefulWidget {
  const InjuriesPage({super.key});

  @override
  ConsumerState<InjuriesPage> createState() => _InjuriesPageState();
}

class _InjuriesPageState extends ConsumerState<InjuriesPage> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final state = ref.read(onboardingProvider);
    _controller.text = state.data.injuries ?? '';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return OnboardingScaffold(
      progress: state.progress,
      title: '¿Tienes alguna lesión o\nlimitación física que\ndebamos considerar?',
      onBack: () => notifier.previousStep(),
      bottomSection: OnboardingContinueButton(
        onPressed: () {
          if (_controller.text.isNotEmpty) {
            notifier.updateInjuries(_controller.text);
          }
          notifier.nextStep();
        },
      ),
      child: Column(
        children: [
          AppTextArea(
            controller: _controller,
          ),
        ],
      ),
    );
  }
}
