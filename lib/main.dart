import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zentoast/zentoast.dart';

import 'core/core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: const String.fromEnvironment(
      'SUPABASE_URL',
      defaultValue: 'https://wxiehggemcmlpidweplk.supabase.co',
    ),
    anonKey: const String.fromEnvironment(
      'SUPABASE_ANON_KEY',
      defaultValue:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind4aWVoZ2dlbWNtbHBpZHdlcGxrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzA0ODU2MjQsImV4cCI6MjA4NjA2MTYyNH0.F2K_tGCPi0KRp4q1HgfBtE-nilimmBMhP0kY2i2lCT4',
    ),
  );

  final isar = await initIsar();

  // Set system UI overlay style for dark theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    ProviderScope(
      overrides: [
        isarProvider.overrideWithValue(isar),
      ],
      child: const FioFutApp(),
    ),
  );
}

class FioFutApp extends ConsumerWidget {
  const FioFutApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return ToastProvider.create(
      child: MaterialApp.router(
        title: 'FioFut',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        routerConfig: router,
        builder: (context, child) {
          return Stack(
            children: [
              Positioned.fill(child: child ?? const SizedBox()),
              // Top: success/general toasts
              SafeArea(
                child: ToastViewer(
                  alignment: Alignment.topCenter,
                  delay: const Duration(seconds: 2),
                  visibleCount: 1,
                  // categories: const [
                  //   ToastCategory.success,
                  //   ToastCategory.general,
                  // ],
                ),
              ),
              // Bottom: error/warning toasts
              // SafeArea(
              //   child: ToastViewer(
              //     alignment: Alignment.bottomCenter,
              //     delay: const Duration(seconds: 3),
              //     visibleCount: 3,
              //     categories: const [
              //       ToastCategory.error,
              //       ToastCategory.warning,
              //     ],
              //   ),
              // ),
            ],
          );
        },
      ),
    );
  }
}
