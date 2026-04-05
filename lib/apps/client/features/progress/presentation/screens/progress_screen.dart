import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/progress/presentation/widgets/progress_exercise_tab.dart';
import 'package:fio_fut/apps/client/features/progress/presentation/widgets/progress_food_tab.dart';
import 'package:flutter/material.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md, AppSpacing.lg, AppSpacing.md, AppSpacing.sm,
              ),
              child: Text(
                'Progreso',
                style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.w900),
              ),
            ),

            // Tab bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: _ProgressTabBar(controller: _tabController),
            ),

            const SizedBox(height: AppSpacing.md),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  ProgressExerciseTab(),
                  ProgressFoodTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressTabBar extends StatelessWidget {
  const _ProgressTabBar({required this.controller});
  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(100),
      ),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(100),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: AppColors.black,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700),
        unselectedLabelStyle: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w500),
        tabs: const [
          Tab(text: 'Ejercicios'),
          Tab(text: 'Alimentación'),
        ],
      ),
    );
  }
}
