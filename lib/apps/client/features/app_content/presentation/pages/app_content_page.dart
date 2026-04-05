import 'package:fio_fut/apps/client/features/app_content/domain/domain.dart';
import 'package:fio_fut/apps/client/features/app_content/presentation/widgets/app_bottom_nav_bar.dart';
import 'package:fio_fut/apps/client/features/home/home.dart';
import 'package:fio_fut/apps/client/features/profile/presentation/screens/profile_screen.dart';
import 'package:fio_fut/apps/client/features/progress/presentation/screens/progress_screen.dart';
import 'package:fio_fut/apps/client/features/training_home/presentation/screens/training_home_screen.dart';
import 'package:fio_fut/core/services/sync_orchestrator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppContentPage extends ConsumerStatefulWidget {
  static const String name = 'home';
  static const String path = '/';

  const AppContentPage({super.key});

  @override
  ConsumerState<AppContentPage> createState() => _AppContentPageState();
}

class _AppContentPageState extends ConsumerState<AppContentPage>
    with WidgetsBindingObserver {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addObserver(this);

    // Flush pendientes al abrir la app
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(syncOrchestratorProvider.notifier).flushQueue();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(syncOrchestratorProvider.notifier).flushQueue();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    ref.listen<int>(bottomNavIndexProvider, (previous, next) {
      _pageController.jumpToPage(next);
    });

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                HomeScreen(),
                TrainingHomeScreen(),
                ProgressScreen(),
                ProfileScreen(),
              ],
            ),
          ),
          AppBottomNavBar(
            currentIndex: currentIndex,
            onTap: (index) {
              ref.read(bottomNavIndexProvider.notifier).setIndex(index);
            },
          ),
        ],
      ),
    );
  }
}
