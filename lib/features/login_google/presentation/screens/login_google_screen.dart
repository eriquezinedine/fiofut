import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart' as router;
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/router/app_routes.dart';
import '../../domain/providers/providers.dart';

class LoginGoogleScreen extends ConsumerWidget {
  const LoginGoogleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginGoogleProvider);
    final notifier = ref.read(loginGoogleProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),

              // Center content
              Column(
                children: [
                  // ========== LOGO SECTION ==========
                  Column(
                    children: [
                      // Logo Container
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: const Center(
                          child: Icon(
                            LucideIcons.activity,
                            size: 72,
                            color: AppColors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // App Title
                      const Text(
                        'FioFut',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 48,
                          fontWeight: FontWeight.w800,
                          color: AppColors.white,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Tagline
                      const Text(
                        'Tu entrenador de fitness',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 56),

                  // ========== LOGIN SECTION ==========
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        // Welcome text
                        const Text(
                          'Bienvenido',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Subtitle
                        const Text(
                          'Inicia sesión para continuar',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Error message
                        if (state.errorMessage != null)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
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
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    state.errorMessage!,
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.error,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: notifier.clearError,
                                  child: const Icon(
                                    Icons.close,
                                    color: AppColors.error,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Google Button
                        _GoogleButton(
                          isLoading: state.isLoading,
                          onPressed: () => _handleGoogleSignIn(context, ref),
                        ),

                        const SizedBox(height: 32),

                        // Terms Section
                        const _TermsSection(),
                      ],
                    ),
                  ),
                ],
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleGoogleSignIn(BuildContext context, WidgetRef ref) async {
    final success =
        await ref.read(loginGoogleProvider.notifier).signInWithGoogle();
    if (success && context.mounted) {
      router.GoRouter.of(context).go(AppRoutes.onboarding);
    }
  }
}

class _GoogleButton extends StatelessWidget {
  const _GoogleButton({
    required this.isLoading,
    required this.onPressed,
  });

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        height: 64,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: const [
            BoxShadow(
              color: Color(0x25000000),
              blurRadius: 20,
              offset: Offset(0, 6),
            ),
            BoxShadow(
              color: Color(0x10000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.black,
                    ),
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Google "G"
                  SvgPicture.asset(
                    'assets/svg/google.svg',
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 16),
                  // Button text
                  const Text(
                    'Continuar con Google',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _TermsSection extends StatelessWidget {
  const _TermsSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      child: FittedBox(
        child: Column(
          children: [
            const Text(
              'Al continuar, aceptas nuestros',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF6B7280),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    // TODO: Navegar a términos de servicio
                  },
                  child: const Text(
                    'Términos de servicio',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  'y',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () {
                    // TODO: Navegar a política de privacidad
                  },
                  child: const Text(
                    'Política de privacidad',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
