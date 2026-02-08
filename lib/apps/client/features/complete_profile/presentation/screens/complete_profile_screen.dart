import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nation_code_picker/nation_code_picker.dart';

import '../../../../../../core/router/app_routes.dart';
import '../../domain/providers/providers.dart';
import '../widgets/widgets.dart';

class CompleteProfileScreen extends ConsumerStatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  ConsumerState<CompleteProfileScreen> createState() =>
      _CompleteProfileScreenState();
}

class _CompleteProfileScreenState
    extends ConsumerState<CompleteProfileScreen> {
  final _controller = TextEditingController();
  NationCodes _selectedCountry = NationCodes.mx;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPhoneChanged(String value) {
    final fullNumber = '${_selectedCountry.dialCode} $value';
    ref.read(completeProfileProvider.notifier).updateWhatsappNumber(fullNumber);
  }

  void _onCountryChanged(NationCodes nation) {
    setState(() {
      _selectedCountry = nation;
    });
    _onPhoneChanged(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(completeProfileProvider);
    final notifier = ref.read(completeProfileProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              const Spacer(),

              // Icon
              const IconBox(
                icon: LucideIcons.messageCircle,
              ),

              AppSpacing.verticalXl,

              // Title
              Text(
                'Completa tu perfil',
                style: AppTextStyles.h2,
              ),

              AppSpacing.verticalMd,

              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Text(
                  'Para finalizar tu registro, necesitamos tu numero de WhatsApp.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),

              AppSpacing.verticalXxl,

              // Error message
              if (state.errorMessage != null)
                ErrorMessageBox(
                  message: state.errorMessage!,
                  onDismiss: notifier.clearError,
                ),

              // Label
              const FieldLabel(
                text: 'Numero de WhatsApp',
              ),

              // Phone input with country picker
              PhoneInputField(
                controller: _controller,
                selectedCountry: _selectedCountry,
                onCountryChanged: _onCountryChanged,
                onPhoneChanged: _onPhoneChanged,
              ),

              AppSpacing.verticalSm,

              // Helper text
              const InfoHintRow(
                text: 'Selecciona tu pais y escribe tu numero',
              ),

              AppSpacing.verticalXl,

              // Submit button
              AppButton(
                text: 'Continuar',
                onPressed: () => _handleSubmit(context, ref),
                isLoading: state.isLoading,
                isDisabled: !state.isValid,
                size: AppButtonSize.large,
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit(BuildContext context, WidgetRef ref) async {
    final success =
        await ref.read(completeProfileProvider.notifier).submitProfile();
    if (success && context.mounted) {
      context.go(AppRoutes.home);
    }
  }
}
