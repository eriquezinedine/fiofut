import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/providers/providers.dart';
import '../widgets/widgets.dart';

/// Pantalla 11: Código de referido (opcional)
class ReferralCodePage extends ConsumerStatefulWidget {
  const ReferralCodePage({super.key});

  @override
  ConsumerState<ReferralCodePage> createState() => _ReferralCodePageState();
}

class _ReferralCodePageState extends ConsumerState<ReferralCodePage> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final state = ref.read(onboardingProvider);
    _controller.text = state.data.referralCode ?? '';
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
      title: 'Introduce el código\nde referido (opcional)',
      subtitle: 'Puedes saltarte este paso',
      onBack: () => notifier.previousStep(),
      bottomSection: OnboardingContinueButton(
        onPressed: () {
          if (_controller.text.isNotEmpty) {
            notifier.updateReferralCode(_controller.text);
          }
          notifier.nextStep();
        },
        text: 'Continuar',
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          AppInputWithAction(
            controller: _controller,
            hint: 'Código de referencia',
            actionText: 'Enviar',
            isActionEnabled: _controller.text.isNotEmpty,
            onChanged: (_) => setState(() {}),
            onAction: () {
              notifier.updateReferralCode(_controller.text);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Código aplicado'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
