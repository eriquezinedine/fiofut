import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/login_google/login_google.dart';
import 'package:fio_fut/core/extension/widget_ref_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class GoogleButton extends ConsumerWidget {
  const GoogleButton({
    super.key, 
  });


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginGoogleProvider);
    return GestureDetector(
      onTap: state.isLoading ? null : ()async => _handleGoogleSignIn(context,ref),
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
        child: state.isLoading
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
                  // Google Logo SVG
                  SvgPicture.asset(
                    'assets/svg/google.svg',
                    width: 24,
                    height: 24,
                  ),
                  AppSpacing.horizontalMd,
                  // Button text - titleMedium con color negro
                  Text(
                    'Continuar con Google',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _handleGoogleSignIn(BuildContext context, WidgetRef ref) async {
    final profile =
        await ref.read(loginGoogleProvider.notifier).signInWithGoogle();
    if (profile != null && context.mounted) {
      final route =  ref.getRoute(profile);
      context.go(route);
    }
  }
}
