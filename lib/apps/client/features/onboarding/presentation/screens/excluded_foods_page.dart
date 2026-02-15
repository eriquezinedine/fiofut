import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../domain/models/ingredient_category.dart';
import '../../domain/providers/providers.dart';
import '../widgets/widgets.dart';

/// Pantalla 9: Alimentos excluidos
class ExcludedFoodsPage extends ConsumerStatefulWidget {
  const ExcludedFoodsPage({super.key});

  @override
  ConsumerState<ExcludedFoodsPage> createState() => _ExcludedFoodsPageState();
}

class _ExcludedFoodsPageState extends ConsumerState<ExcludedFoodsPage>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  late TabController _tabController;

  static final _tabNames = <Object>[
    'Todos',
    ...IngredientCategory.values,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabNames.length, vsync: this);
    _tabController.addListener(_onTabChanged);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    final index = _tabController.index;
    final category = index == 0 ? null : IngredientCategory.values[index - 1];
    ref.read(excludedFoodsListProvider.notifier).changeCategory(category);
  }

  void _onSearchChanged() {
    ref.read(excludedFoodsListProvider.notifier).search(_searchController.text);
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      final metrics = notification.metrics;
      if (metrics.pixels >= metrics.maxScrollExtent - 200) {
        ref.read(excludedFoodsListProvider.notifier).loadMore();
      }
    }
    return false;
  }

  void _showAddFoodModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.transparent,
      isScrollControlled: true,
      builder: (context) => _AddFoodModal(
        initialText: _searchController.text,
        onAddFood: (food) {
          ref.read(onboardingProvider.notifier).addExcludedFood(food);
          Navigator.pop(context);
          _searchController.clear();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);
    final excludedFoods = onboardingState.data.excludedFoods;
    final listState = ref.watch(excludedFoodsListProvider);

    return NotificationListener<ScrollNotification>(
      onNotification: _onScrollNotification,
      child: OnboardingScaffold(
      progress: onboardingState.progress,
      title: '¿Cual es la comida que\nno te gusta o te hace mal?',
      onBack: () => notifier.previousStep(),
      bottomSection: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_showAddButton(listState)) ...[
            OnboardingSecondaryButton(
              text: 'Agregar',
              icon: LucideIcons.plus,
              onPressed: _showAddFoodModal,
            ),
            const SizedBox(height: 12),
          ],
          OnboardingContinueButton(
            onPressed: () => notifier.nextStep(),
            text: 'Continuar',
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            controller: _searchController,
            hint: 'Buscar...',
            prefixIcon: LucideIcons.search,
          ),
          const SizedBox(height: 20),
          _buildTabBar(),
          const SizedBox(height: 20),
          _buildContent(listState, excludedFoods),
        ],
      ),
    ),
    );
  }

  bool _showAddButton(ExcludedFoodsListState listState) {
    return _searchController.text.isNotEmpty &&
        !listState.isLoading &&
        !listState.isSearching &&
        listState.ingredients.isEmpty;
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        padding: const EdgeInsets.all(4),
        labelPadding: const EdgeInsets.symmetric(horizontal: 4),
        indicator: BoxDecoration(
          color: AppColors.green,
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: AppColors.transparent,
        labelColor: AppColors.black,
        unselectedLabelColor: AppColors.white,
        labelStyle: AppTextStyles.labelMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextStyles.labelMedium.copyWith(
          fontWeight: FontWeight.w500,
        ),
        tabs: _tabNames.map((tab) {
          final label = tab is IngredientCategory ? tab.displayName : tab as String;
          return Tab(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(label),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContent(
    ExcludedFoodsListState listState,
    List<String> excludedFoods,
  ) {
    if (listState.isLoading || listState.isSearching) {
      return const Padding(
        padding: EdgeInsets.only(top: 40),
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (listState.error != null) {
      return SizedBox(
        height: 150,
        child: AppEmptyState(
          icon: LucideIcons.wifiOff,
          title: 'Error al cargar ingredientes',
          iconSize: 48,
          iconColor: AppColors.textMuted,
        ),
      );
    }

    if (listState.ingredients.isEmpty) {
      return SizedBox(
        height: 150,
        child: AppEmptyState(
          icon: LucideIcons.searchX,
          title: 'No se encontraron resultados',
          iconSize: 48,
          iconColor: AppColors.textMuted,
        ),
      );
    }

    final notifier = ref.read(onboardingProvider.notifier);

    return Column(
      children: [
        ...listState.ingredients.map((ingredient) {
          final isExcluded = excludedFoods.contains(ingredient.name);
          return _FoodListItem(
            name: ingredient.name,
            isExcluded: isExcluded,
            onTap: () {
              if (isExcluded) {
                notifier.removeExcludedFood(ingredient.name);
              } else {
                notifier.addExcludedFood(ingredient.name);
              }
            },
          );
        }),
        if (listState.isLoadingMore)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ── Private Widgets ──────────────────────────────────────────────

class _FoodListItem extends StatelessWidget {
  const _FoodListItem({
    required this.name,
    required this.isExcluded,
    required this.onTap,
  });

  final String name;
  final bool isExcluded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomGestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isExcluded ? AppColors.green : AppColors.card,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isExcluded ? AppColors.black : AppColors.white,
                  fontWeight: isExcluded ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
            if (isExcluded)
              const Icon(
                LucideIcons.check,
                color: AppColors.black,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

class _Suggestion {
  final String emoji;
  final String name;
  const _Suggestion({required this.emoji, required this.name});
}

class _AddFoodModal extends StatefulWidget {
  const _AddFoodModal({
    required this.onAddFood,
    this.initialText = '',
  });

  final ValueChanged<String> onAddFood;
  final String initialText;

  @override
  State<_AddFoodModal> createState() => _AddFoodModalState();
}

class _AddFoodModalState extends State<_AddFoodModal> {
  late TextEditingController _inputController;

  static const _suggestions = [
    _Suggestion(emoji: '🍕', name: 'Pizza'),
    _Suggestion(emoji: '🍔', name: 'Hamburguesa'),
    _Suggestion(emoji: '🍟', name: 'Papas'),
    _Suggestion(emoji: '🌮', name: 'Tacos'),
    _Suggestion(emoji: '🧀', name: 'Queso'),
    _Suggestion(emoji: '🥚', name: 'Huevo'),
  ];

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _addFood() {
    final text = _inputController.text.trim();
    if (text.isNotEmpty) {
      widget.onAddFood(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.only(bottom: 34),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Agregar alimento',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                CustomGestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceAlt,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      LucideIcons.x,
                      color: AppColors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  controller: _inputController,
                  hint: 'Escribe el nombre del alimento...',
                  prefixIcon: LucideIcons.utensils,
                  onSubmitted: (_) => _addFood(),
                ),
                const SizedBox(height: 20),
                Text(
                  'Sugerencias populares',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _suggestions.map((suggestion) {
                    return CustomGestureDetector(
                      onTap: () {
                        _inputController.text = suggestion.name;
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              suggestion.emoji,
                              style: AppTextStyles.caption,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              suggestion.name,
                              style: AppTextStyles.labelMedium.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),
                AppButton(
                  text: 'Agregar',
                  icon: LucideIcons.plus,
                  onPressed: _addFood,
                  size: AppButtonSize.large,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
