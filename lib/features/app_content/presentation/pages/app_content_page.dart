import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/features/app_content/domain/domain.dart';
import 'package:fio_fut/features/app_content/presentation/widgets/app_bottom_nav_bar.dart';
import 'package:fio_fut/features/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppContentPage extends ConsumerStatefulWidget {
  const AppContentPage({super.key});

  @override
  ConsumerState<AppContentPage> createState() => _AppContentPageState();
}

class _AppContentPageState extends ConsumerState<AppContentPage> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
                _PlaceholderScreen(title: 'Rutina'),
                _PlaceholderScreen(title: 'Progreso'),
                _PlaceholderScreen(title: 'Perfil'),
              ],
            ),
          ),
          AppBottomNavBar(
            currentIndex: currentIndex,
            onTap: (index) {
              ref.read(bottomNavIndexProvider.notifier).setIndex(index);
            },
            onAddTap: () {
              // TODO: Open add meal/exercise modal
            },
          ),
        ],
      ),
    );
  }
}


class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          title,
          style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
        ),
      ),
      body: Center(
        child: Text(
          title,
          style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
