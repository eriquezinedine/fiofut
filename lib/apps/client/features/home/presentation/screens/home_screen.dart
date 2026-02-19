import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/trainer_detail/presentation/screens/trainer_detail_page.dart';
import 'package:fio_fut/core/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

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
            Column(
              children: [
                const SizedBox(height: 8),

                // Header (widget normal)
                _HomeHeader(streak: streak),

                const SizedBox(height: 20),

                // Week calendar (widget normal con PageView)
                const SizedBox(
                  height: 88,
                  child: _WeekCalendarWidget(),
                ),

                // NestedScrollView para el resto del contenido
                Expanded(
                  child: NestedScrollView(
                    headerSliverBuilder: (context, innerBoxIsScrolled) => [
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 20),
                      ),

                      // Calories card
                      SliverCaloriesCard(
                        caloriesData: caloriesData,
                        isExpanded: _isCaloriesExpanded,
                        onExpand: _toggleCaloriesExpanded,
                        pinned: false,
                      ),

                      const SliverToBoxAdapter(
                        child: SizedBox(height: 20),
                      ),

                      // Hydration card
                      SliverHydrationCard(
                        hydrationData: hydrationData,
                        pinned: false,
                        onAddWater: (amount) {
                          ref.read(homeProvider.notifier).addWater(amount);
                        },
                        onTap: () => GoRouter.of(context).push(HydrationScreen.path),
                      ),

                      const SliverToBoxAdapter(
                        child: SizedBox(height: 20),
                      ),

                      // Trainer banner
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TrainerBanner(
                            onTap: () {
                              final trainerProfile =
                                  ref.read(userProfileProvider).valueOrNull;
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

/// Home header widget (normal, no Sliver).
class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                LucideIcons.apple,
                color: AppColors.white,
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(
                'FioFit',
                style: AppTextStyles.h2.copyWith(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  LucideIcons.flame,
                  color: AppColors.orange,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  '$streak',
                  style: AppTextStyles.body.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Week calendar widget with horizontal PageView (normal, no Sliver).
class _WeekCalendarWidget extends ConsumerStatefulWidget {
  const _WeekCalendarWidget();

  @override
  ConsumerState<_WeekCalendarWidget> createState() =>
      _WeekCalendarWidgetState();
}

class _WeekCalendarWidgetState extends ConsumerState<_WeekCalendarWidget> {
  late PageController _pageController;
  static const int _initialPage = 10000;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weekState = ref.watch(weekProvider);

    if (weekState is! WeekLoaded) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        final pageIndex = index - _initialPage;
        final weekStart =
            ref.read(weekProvider.notifier).getWeekStartForPage(pageIndex);
        ref.read(weekProvider.notifier).updateCurrentWeek(weekStart);
      },
      itemBuilder: (context, index) {
        final pageIndex = index - _initialPage;
        final notifier = ref.read(weekProvider.notifier);
        final weekStart = notifier.getWeekStartForPage(pageIndex);
        final weekDays = notifier.getWeekDays(weekStart);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final day in weekDays)
                _WeekDayItem(
                  weekDay: day,
                  onTap: () => notifier.selectDay(day.date),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Week day item widget.
class _WeekDayItem extends StatelessWidget {
  const _WeekDayItem({required this.weekDay, required this.onTap});

  final WeekDay weekDay;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = weekDay.isSelected;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.card : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              weekDay.dayName,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.white : AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${weekDay.dayNumber}',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? AppColors.white : AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 6),
            _buildDots(),
          ],
        ),
      ),
    );
  }

  Widget _buildDots() {
    if (!weekDay.hasMeals && !weekDay.hasExercise) {
      return const SizedBox(height: 6);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (weekDay.hasMeals)
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
        if (weekDay.hasMeals && weekDay.hasExercise) const SizedBox(width: 4),
        if (weekDay.hasExercise)
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.blue,
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }
}
