import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/trainer_detail/presentation/screens/trainer_detail_page.dart';
import 'package:fio_fut/core/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/models.dart';
import '../../domain/providers/providers.dart';
import '../widgets/widgets.dart';
import 'hydration_screen.dart';

/// Home screen showing the user's daily progress and meal plan.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isCaloriesExpanded = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(homeProvider.notifier).loadHomeData();
    });
  }

  void _toggleCaloriesExpanded() {
    setState(() {
      _isCaloriesExpanded = !_isCaloriesExpanded;
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
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          HomeError(:final message) => Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Error: $message',
                style: AppTextStyles.body.copyWith(color: AppColors.error),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          HomeLoaded(
            :final caloriesData,
            :final hydrationData,
            :final mealItems,
            :final streak,
          ) =>
            Column(
              children: [
                const SizedBox(height: 8),

                // Header (widget normal)
                HomeHeader(streak: streak),

                const SizedBox(height: 20),

                // Week calendar (widget normal con PageView)
                const SizedBox(height: 88, child: WeekCalendarWidget()),

                // NestedScrollView para el resto del contenido
                Expanded(
                  child: NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) => [
                      const SliverToBoxAdapter(child: SizedBox(height: 20)),

                      // Calories card
                      SliverCaloriesCard(
                        caloriesData: caloriesData,
                        isExpanded: _isCaloriesExpanded,
                        onExpand: _toggleCaloriesExpanded,
                        pinned: false,
                      ),

                      const SliverToBoxAdapter(child: SizedBox(height: 20)),

                      // Hydration card
                      SliverHydrationCard(
                        hydrationData: hydrationData,
                        pinned: false,
                        onAddWater: (amount) {
                          ref.read(homeProvider.notifier).addWater(amount);
                        },
                        onTap: () =>
                            GoRouter.of(context).push(HydrationScreen.path),
                      ),

                      const SliverToBoxAdapter(child: SizedBox(height: 20)),

                      // Trainer banner
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TrainerBanner(
                            onTap: () {
                              final trainerProfile = ref
                                  .read(userProfileProvider)
                                  .valueOrNull;
                              if (trainerProfile != null) {
                                GoRouter.of(context).push(
                                  TrainerDetailPage.path,
                                  extra: trainerProfile,
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                    body: Padding(
                      padding: EdgeInsetsGeometry.only(top: 20),
                      child: MealTabs(
                        exerciseItems: mealItems
                            .where((i) => i.type == MealItemType.exercise)
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        },
      ),
    );
  }
}
