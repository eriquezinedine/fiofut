import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../apps/client/features/onboarding/data/repositories/ingredient_repository.dart';
import '../../../apps/client/features/onboarding/domain/models/ingredient_category.dart';
import '../../../apps/client/features/onboarding/domain/providers/excluded_foods_provider.dart';
import 'ingredient_category_tab_bar.dart';
import 'ingredient_list_tile.dart';

/// Widget reutilizable con search + tabs + lista paginada de ingredientes.
///
/// Usado en ExcludedFoodsPage (toggle exclusion) y SelectIngredientPage (seleccion).
class IngredientSearchBody extends ConsumerStatefulWidget {
  const IngredientSearchBody({
    super.key,
    required this.onIngredientTap,
    this.selectedNames = const {},
    this.onAddNew,
  });

  /// Callback al tocar un ingrediente de la lista.
  final void Function(IngredientItem item) onIngredientTap;

  /// Nombres de ingredientes seleccionados (para mostrar check marks).
  final Set<String> selectedNames;

  /// Callback cuando el usuario quiere agregar un ingrediente que no existe.
  /// Si es null, no se muestra el boton "Agregar".
  final void Function(String name)? onAddNew;

  @override
  ConsumerState<IngredientSearchBody> createState() =>
      _IngredientSearchBodyState();
}

class _IngredientSearchBodyState extends ConsumerState<IngredientSearchBody>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: IngredientCategoryTabBar.tabNames.length,
      vsync: this,
    );
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

  bool _showAddButton(ExcludedFoodsListState listState) {
    return widget.onAddNew != null &&
        _searchController.text.isNotEmpty &&
        !listState.isLoading &&
        !listState.isSearching &&
        listState.ingredients.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final listState = ref.watch(excludedFoodsListProvider);

    return NotificationListener<ScrollNotification>(
      onNotification: _onScrollNotification,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              controller: _searchController,
              hint: 'Buscar...',
              prefixIcon: LucideIcons.search,
            ),
            const SizedBox(height: 20),
            IngredientCategoryTabBar(tabController: _tabController),
            const SizedBox(height: 20),
            _buildContent(listState),
            if (_showAddButton(listState)) ...[
              const SizedBox(height: 16),
              AppButton(
                text: 'Agregar ingrediente',
                icon: LucideIcons.plus,
                onPressed: () => widget.onAddNew?.call(_searchController.text),
                size: AppButtonSize.large,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContent(ExcludedFoodsListState listState) {
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

    return Column(
      children: [
        ...listState.ingredients.map((ingredient) {
          final isSelected = widget.selectedNames.contains(ingredient.name);
          return IngredientListTile(
            name: ingredient.name,
            isSelected: isSelected,
            onTap: () => widget.onIngredientTap(ingredient),
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
