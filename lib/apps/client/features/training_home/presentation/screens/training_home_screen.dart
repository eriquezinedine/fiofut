import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/training_home/presentation/widgets/training_app_tab.dart';
import 'package:fio_fut/apps/client/features/training_home/presentation/widgets/training_mine_tab.dart';
import 'package:fio_fut/apps/client/features/training_home/presentation/widgets/training_recommended_tab.dart';
import 'package:flutter/material.dart';

class TrainingHomeScreen extends StatefulWidget {
  const TrainingHomeScreen({super.key});

  @override
  State<TrainingHomeScreen> createState() => _TrainingHomeScreenState();
}

class _TrainingHomeScreenState extends State<TrainingHomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
              padding: AppSpacing.paddingHorizontalMd.add(
                const EdgeInsets.only(top: 16, bottom: 8),
              ),
              child: Text(
                'Entrenamiento',
                style: AppTextStyles.h2.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),

            // Tab bar
            Padding(
              padding: AppSpacing.paddingHorizontalMd,
              child: _TrainingTabBar(controller: _tabController),
            ),

            const SizedBox(height: 16),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  TrainingAppTab(),
                  TrainingMineTab(),
                  TrainingRecommendedTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrainingTabBar extends StatelessWidget {
  const _TrainingTabBar({required this.controller});

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
        labelStyle: AppTextStyles.bodySmall.copyWith(
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: AppTextStyles.bodySmall.copyWith(
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(text: 'App'),
          Tab(text: 'Míos'),
          Tab(text: 'Recomendados'),
        ],
      ),
    );
  }
}
