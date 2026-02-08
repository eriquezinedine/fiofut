import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart' as router;

import '../../../../core/router/app_routes.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 24),
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
                    borderRadius: BorderRadius.circular(20),
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
                  style: AppTextStyles.h2.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Center(
                child: Text(
                  'Inicia sesion para continuar',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),

              const SizedBox(height: 48),

              // Email
              AppTextField(
                label: 'Correo electronico',
                hint: 'tu@email.com',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onChanged: notifier.updateEmail,
                errorText: state.errorMessage != null && state.email.isEmpty
                    ? 'Ingresa tu correo'
                    : null,
              ),

              const SizedBox(height: 20),

              // Password
              AppTextField(
                label: 'Contrasena',
                hint: 'Ingresa tu contrasena',
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
                    ? 'Ingresa tu contrasena'
                    : null,
              ),

              const SizedBox(height: 12),

              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: Implementar recuperacion de contrasena
                  },
                  child: Text(
                    'Olvidaste tu contrasena?',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
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

              // Login button
              AppButton(
                text: 'Iniciar sesion',
                onPressed: state.isLoading ? null : () => _handleLogin(context, ref),
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
                      'o continua con',
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
                        // TODO: Implementar login con Google
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
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

              const SizedBox(height: 48),

              // Register link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No tienes cuenta? ',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => router.GoRouter.of(context).push(AppRoutes.register),
                    child: Text(
                      'Registrate',
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
