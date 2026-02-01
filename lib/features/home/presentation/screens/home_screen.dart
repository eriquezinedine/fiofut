import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/providers/providers.dart';
import '../widgets/widgets.dart';

/// Home screen showing the user's daily progress and meal plan.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(homeProvider.notifier).loadHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: switch (homeState) {
          HomeInitial() || HomeLoading() => const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
          HomeError(:final message) => Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Error: $message',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.error,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          HomeLoaded(
            :final caloriesData,
            :final hydrationData,
            :final mealItems,
            :final streak
          ) =>
            NestedScrollView(
              
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                // Spacing at top
                const SliverToBoxAdapter(
                  child: SizedBox(height: 8),
                ),

                // Header with logo and streak badge
                // SliverHomeHeader(streak: streak),
                SliverHomeHeader(streak: streak,pinned: false,),

                // Spacing
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),

                // Week calendar with horizontal scroll
                const SliverWeekCalendar(),

                // Spacing
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),

                // Calories card (pinned)
                SliverCaloriesCard(caloriesData: caloriesData,pinned: false,),

                // Spacing
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),

                // Hydration card (pinned)
                SliverHydrationCard(
                  hydrationData: hydrationData,
                  pinned: false,
                  onAddWater: (amount) {
                    ref.read(homeProvider.notifier).addWater(amount);
                  },
                ),

                // Spacing
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),

                // Trainer banner
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    
                    child: TrainerBanner(),
                  ),
                ),

                // Spacing
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
              ],
              body: Stack(
                children: [MealTabs(mealItems: mealItems)],
              ),
            ),
        },
      ),
    );
  }
}
