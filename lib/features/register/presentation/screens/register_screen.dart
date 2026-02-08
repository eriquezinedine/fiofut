import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart' as router;

import '../../../../core/router/app_routes.dart';
import '../../domain/providers/providers.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(registerProvider);
    final notifier = ref.read(registerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => router.GoRouter.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpacing.verticalMd,

              // Titulo
              Text(
                'Crear cuenta',
                style: AppTextStyles.h2,
              ),

              AppSpacing.verticalXs,

              Text(
                'Completa tus datos para comenzar',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              AppSpacing.verticalXl,

              // Name
              AppTextField(
                label: 'Nombre completo',
                hint: 'Tu nombre',
                prefixIcon: Icons.person_outline,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                onChanged: notifier.updateName,
              ),

              AppSpacing.verticalMd,

              // Email
              AppTextField(
                label: 'Correo electrónico',
                hint: 'tu@email.com',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onChanged: notifier.updateEmail,
              ),

              AppSpacing.verticalMd,

              // Password
              AppTextField(
                label: 'Contraseña',
                hint: 'Mínimo 6 caracteres',
                prefixIcon: Icons.lock_outline,
                obscureText: !state.isPasswordVisible,
                suffixIcon: state.isPasswordVisible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                onSuffixIconTap: notifier.togglePasswordVisibility,
                textInputAction: TextInputAction.next,
                onChanged: notifier.updatePassword,
              ),

              AppSpacing.verticalMd,

              // Confirm Password
              AppTextField(
                label: 'Confirmar contraseña',
                hint: 'Repite tu contraseña',
                prefixIcon: Icons.lock_outline,
                obscureText: !state.isConfirmPasswordVisible,
                suffixIcon: state.isConfirmPasswordVisible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                onSuffixIconTap: notifier.toggleConfirmPasswordVisibility,
                textInputAction: TextInputAction.done,
                onChanged: notifier.updateConfirmPassword,
                onSubmitted: (_) => _handleRegister(context, ref),
                errorText: state.confirmPassword.isNotEmpty &&
                        !state.passwordsMatch
                    ? 'Las contraseñas no coinciden'
                    : null,
              ),

              AppSpacing.verticalLg,

              // Terms checkbox
              GestureDetector(
                onTap: notifier.toggleAcceptedTerms,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: state.acceptedTerms
                            ? AppColors.primary
                            : AppColors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: state.acceptedTerms
                              ? AppColors.primary
                              : AppColors.border,
                          width: 2,
                        ),
                      ),
                      child: state.acceptedTerms
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: AppColors.black,
                            )
                          : null,
                    ),
                    AppSpacing.horizontalSm,
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          children: [
                            const TextSpan(text: 'Acepto los '),
                            TextSpan(
                              text: 'Términos y Condiciones',
                              style: AppTextStyles.labelLarge.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            const TextSpan(text: ' y la '),
                            TextSpan(
                              text: 'Política de Privacidad',
                              style: AppTextStyles.labelLarge.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              AppSpacing.verticalLg,

              // Error message
              if (state.errorMessage != null)
                Container(
                  width: double.infinity,
                  padding: AppSpacing.paddingAllSm,
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: AppSpacing.borderRadiusSm,
                    border: Border.all(
                      color: AppColors.error.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: AppColors.error,
                        size: AppSpacing.iconSm,
                      ),
                      AppSpacing.horizontalXs,
                      Expanded(
                        child: Text(
                          state.errorMessage!,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Register button
              AppButton(
                text: 'Crear cuenta',
                onPressed:
                    state.isLoading ? null : () => _handleRegister(context, ref),
                isLoading: state.isLoading,
                type: AppButtonType.primary,
              ),

              AppSpacing.verticalLg,

              // Divider
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.border)),
                  Padding(
                    padding: AppSpacing.paddingHorizontalMd,
                    child: Text(
                      'o regístrate con',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.border)),
                ],
              ),

              AppSpacing.verticalLg,

              // Social buttons
              Row(
                children: [
                  Expanded(
                    child: _SocialButton(
                      icon: Icons.g_mobiledata,
                      label: 'Google',
                      onTap: () {
                        // TODO: Implementar registro con Google
                      },
                    ),
                  ),
                  AppSpacing.horizontalMd,
                  Expanded(
                    child: _SocialButton(
                      icon: Icons.apple,
                      label: 'Apple',
                      onTap: () {
                        // TODO: Implementar registro con Apple
                      },
                    ),
                  ),
                ],
              ),

              AppSpacing.verticalXl,

              // Login link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¿Ya tienes cuenta? ',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => router.GoRouter.of(context).pop(),
                    child: Text(
                      'Inicia sesión',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),

              AppSpacing.verticalXl,
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleRegister(BuildContext context, WidgetRef ref) async {
    final success = await ref.read(registerProvider.notifier).register();
    if (success && context.mounted) {
      router.GoRouter.of(context).go(AppRoutes.onboarding);
    }
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.surfaceAlt,
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.textPrimary, size: AppSpacing.iconMd),
            AppSpacing.horizontalXs,
            Text(
              label,
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
