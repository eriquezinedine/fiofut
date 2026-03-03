import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/login_google/presentation/widgets/goolgle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../domain/providers/providers.dart';

class LoginGoogleScreen extends ConsumerWidget {
  static const String name = 'login-google';
  static const String path = '/login-google';

  const LoginGoogleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginGoogleProvider);
    final notifier = ref.read(loginGoogleProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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

                      AppSpacing.verticalLg,

                      // App Title - h1 con weight 800
                      Text(
                        'FioFit',
                        style: AppTextStyles.h1.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      AppSpacing.verticalLg,

                      // Tagline - titleMedium con weight 400
                      Text(
                        'Tu entrenador de fitness',
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 56),

                  // ========== LOGIN SECTION ==========
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    child: Column(
                      children: [
                        // Welcome text - h2
                        Text(
                          'Bienvenido',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.h2,
                        ),

                        AppSpacing.verticalXl,

                        // Subtitle - body con color secundario
                        Text(
                          'Inicia sesión para continuar',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),

                        AppSpacing.verticalXl,

                        // Error message
                        if (state.errorMessage != null)
                          Container(
                            width: double.infinity,
                            padding: AppSpacing.paddingAllSm,
                            margin: const EdgeInsets.only(bottom: AppSpacing.md),
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.1),
                              borderRadius: AppSpacing.borderRadiusMd,
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
                                AppSpacing.horizontalSm,
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
                        GoogleButton(),

                        AppSpacing.verticalXl,

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

  
}

class _TermsSection extends StatelessWidget {
  const _TermsSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.xl,
      ),
      child: FittedBox(
        child: Column(
          children: [
            // caption con color textMuted
            Text(
              'Al continuar, aceptas nuestros',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textMuted,
                height: 1.4,
              ),
            ),
            AppSpacing.verticalSm,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    // TODO: Navegar a términos de servicio
                  },
                  // labelLarge con color primary
                  child: Text(
                    'Términos de servicio',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                AppSpacing.horizontalXxs,
                // caption con color textMuted
                Text(
                  'y',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 13,
                  ),
                ),
                AppSpacing.horizontalXxs,
                GestureDetector(
                  onTap: () {
                    // TODO: Navegar a política de privacidad
                  },
                  // labelLarge con color primary
                  child: Text(
                    'Política de privacidad',
                    style: AppTextStyles.labelLarge.copyWith(
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
