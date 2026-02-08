import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart' as router;

import '../../../../../../core/router/app_routes.dart';
import '../../domain/providers/providers.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginProvider);
    final notifier = ref.read(loginProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),

              // Logo o Icono
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: AppSpacing.borderRadiusXl,
                  ),
                  child: const Icon(
                    Icons.fitness_center,
                    size: 40,
                    color: AppColors.black,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Titulo
              Center(
                child: Text(
                  'Bienvenido de vuelta',
                  style: AppTextStyles.h2,
                ),
              ),

              AppSpacing.verticalXs,

              Center(
                child: Text(
                  'Inicia sesión para continuar',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),

              AppSpacing.verticalXxl,

              // Email
              AppTextField(
                label: 'Correo electrónico',
                hint: 'tu@email.com',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onChanged: notifier.updateEmail,
                errorText: state.errorMessage != null && state.email.isEmpty
                    ? 'Ingresa tu correo'
                    : null,
              ),

              AppSpacing.verticalMd,

              // Password
              AppTextField(
                label: 'Contraseña',
                hint: 'Ingresa tu contraseña',
                prefixIcon: Icons.lock_outline,
                obscureText: !state.isPasswordVisible,
                suffixIcon: state.isPasswordVisible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                onSuffixIconTap: notifier.togglePasswordVisibility,
                textInputAction: TextInputAction.done,
                onChanged: notifier.updatePassword,
                onSubmitted: (_) => _handleLogin(context, ref),
                errorText: state.errorMessage != null && state.password.isEmpty
                    ? 'Ingresa tu contraseña'
                    : null,
              ),

              AppSpacing.verticalSm,

              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: Implementar recuperación de contraseña
                  },
                  child: Text(
                    '¿Olvidaste tu contraseña?',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
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

              // Login button
              AppButton(
                text: 'Iniciar sesión',
                onPressed:
                    state.isLoading ? null : () => _handleLogin(context, ref),
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
                      'o continúa con',
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
                        // TODO: Implementar login con Google
                      },
                    ),
                  ),
                  AppSpacing.horizontalMd,
                  Expanded(
                    child: _SocialButton(
                      icon: Icons.apple,
                      label: 'Apple',
                      onTap: () {
                        // TODO: Implementar login con Apple
                      },
                    ),
                  ),
                ],
              ),

              AppSpacing.verticalXxl,

              // Register link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¿No tienes cuenta? ',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () =>
                        router.GoRouter.of(context).push(AppRoutes.register),
                    child: Text(
                      'Regístrate',
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

  Future<void> _handleLogin(BuildContext context, WidgetRef ref) async {
    final success = await ref.read(loginProvider.notifier).login();
    if (success && context.mounted) {
      router.GoRouter.of(context).go(AppRoutes.home);
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
