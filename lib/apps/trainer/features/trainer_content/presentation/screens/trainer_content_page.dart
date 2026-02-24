import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fio_fut/apps/client/features/profile/presentation/screens/profile_screen.dart';
import 'package:fio_fut/apps/trainer/features/trainer_folders/presentation/screens/trainer_exercise_folders_screen.dart';
import 'package:fio_fut/apps/trainer/features/trainer_folders/presentation/screens/trainer_food_folders_screen.dart';

import '../../domain/providers/trainer_bottom_nav_provider.dart';
import '../widgets/trainer_bottom_nav.dart';

class TrainerContentPage extends ConsumerStatefulWidget {
  static const String name = 'trainer';
  static const String path = '/trainer';

  const TrainerContentPage({super.key});

  @override
  ConsumerState<TrainerContentPage> createState() =>
      _TrainerContentPageState();
}

class _TrainerContentPageState extends ConsumerState<TrainerContentPage> {
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
    final currentIndex = ref.watch(trainerBottomNavIndexProvider);

    ref.listen<int>(trainerBottomNavIndexProvider, (previous, next) {
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
                TrainerFoodFoldersScreen(),
                TrainerExerciseFoldersScreen(),
                _PlaceholderScreen(title: 'Clientes'),
                ProfileScreen(),
              ],
            ),
          ),
          TrainerBottomNav(
            currentIndex: currentIndex,
            onTap: (index) {
              ref
                  .read(trainerBottomNavIndexProvider.notifier)
                  .setIndex(index);
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
