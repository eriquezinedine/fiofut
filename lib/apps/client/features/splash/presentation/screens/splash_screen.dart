import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/login_google/login_google.dart';
import 'package:fio_fut/core/extension/widget_ref_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends ConsumerStatefulWidget {
  static const String name = 'splash';
  static const String path = '/splash';

  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _resolve());
  }

  Future<void> _resolve() async {
    final session = Supabase.instance.client.auth.currentSession;

    if (session == null) {
      if (mounted) context.go(LoginGoogleScreen.path);
      return;
    }

    final profile = await ref.fetchProfile(session);

    if (!mounted) return;

    if (profile == null) {
      context.go(LoginGoogleScreen.path);
      return;
    }

    final route = ref.getRoute(profile);

    context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
            Text(
              'FioFut',
              style: AppTextStyles.h1.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
