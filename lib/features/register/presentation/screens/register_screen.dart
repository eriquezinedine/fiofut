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
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Titulo
              Text(
                'Crear cuenta',
                style: AppTextStyles.h2.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Completa tus datos para comenzar',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 32),

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

              const SizedBox(height: 20),

              // Email
              AppTextField(
                label: 'Correo electronico',
                hint: 'tu@email.com',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onChanged: notifier.updateEmail,
              ),

              const SizedBox(height: 20),

              // Password
              AppTextField(
                label: 'Contrasena',
                hint: 'Minimo 6 caracteres',
                prefixIcon: Icons.lock_outline,
                obscureText: !state.isPasswordVisible,
                suffixIcon: state.isPasswordVisible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                onSuffixIconTap: notifier.togglePasswordVisibility,
                textInputAction: TextInputAction.next,
                onChanged: notifier.updatePassword,
              ),

              const SizedBox(height: 20),

              // Confirm Password
              AppTextField(
                label: 'Confirmar contrasena',
                hint: 'Repite tu contrasena',
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
                    ? 'Las contrasenas no coinciden'
                    : null,
              ),

              const SizedBox(height: 24),

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
                    const SizedBox(width: 12),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          children: [
                            const TextSpan(text: 'Acepto los '),
                            TextSpan(
                              text: 'Terminos y Condiciones',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const TextSpan(text: ' y la '),
                            TextSpan(
                              text: 'Politica de Privacidad',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Error message
              if (state.errorMessage != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.error.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: AppColors.error,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
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

              const SizedBox(height: 24),

              // Divider
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.border)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'o registrate con',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.border)),
                ],
              ),

              const SizedBox(height: 24),

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
                  const SizedBox(width: 16),
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

              const SizedBox(height: 32),

              // Login link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Ya tienes cuenta? ',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => router.GoRouter.of(context).pop(),
                    child: Text(
                      'Inicia sesion',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleRegister(BuildContext context, WidgetRef ref) async {
    final success = await ref.read(registerProvider.notifier).register();
    if (success && context.mounted) {
      // Navegar al onboarding despues de registrarse
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
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.textPrimary, size: 24),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
