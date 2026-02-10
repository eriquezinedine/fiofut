import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../admin_home/presentation/screens/admin_home_screen.dart';
import '../../../exercises/presentation/screens/exercises_list_screen.dart';
import '../../../meals/presentation/screens/meals_list_screen.dart';
import '../../domain/providers/admin_bottom_nav_provider.dart';
import '../widgets/admin_bottom_nav.dart';

class AdminContentPage extends ConsumerStatefulWidget {
  const AdminContentPage({super.key});

  @override
  ConsumerState<AdminContentPage> createState() => _AdminContentPageState();
}

class _AdminContentPageState extends ConsumerState<AdminContentPage> {
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
    final currentIndex = ref.watch(adminBottomNavIndexProvider);

    ref.listen<int>(adminBottomNavIndexProvider, (previous, next) {
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
                AdminHomeScreen(),
                ExercisesListScreen(),
                MealsListScreen(),
              ],
            ),
          ),
          AdminBottomNav(
            currentIndex: currentIndex,
            onTap: (index) {
              ref
                  .read(adminBottomNavIndexProvider.notifier)
                  .setIndex(index);
            },
          ),
        ],
      ),
    );
  }
}
