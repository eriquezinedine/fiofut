import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/ingredient_repository.dart';
import '../models/ingredient_category.dart';

// ── State ────────────────────────────────────────────────────────

class ExcludedFoodsListState {
  const ExcludedFoodsListState({
    this.ingredients = const [],
    this.isLoading = false,
    this.isSearching = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.currentPage = 0,
    this.searchQuery = '',
    this.selectedCategory,
    this.error,
  });

  final List<IngredientItem> ingredients;
  final bool isLoading;
  final bool isSearching;
  final bool isLoadingMore;
  final bool hasMore;
  final int currentPage;
  final String searchQuery;
  final IngredientCategory? selectedCategory;
  final String? error;

  ExcludedFoodsListState copyWith({
    List<IngredientItem>? ingredients,
    bool? isLoading,
    bool? isSearching,
    bool? isLoadingMore,
    bool? hasMore,
    int? currentPage,
    String? searchQuery,
    IngredientCategory? Function()? selectedCategory,
    String? Function()? error,
  }) {
    return ExcludedFoodsListState(
      ingredients: ingredients ?? this.ingredients,
      isLoading: isLoading ?? this.isLoading,
      isSearching: isSearching ?? this.isSearching,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory:
          selectedCategory != null ? selectedCategory() : this.selectedCategory,
      error: error != null ? error() : this.error,
    );
  }
}

// ── Provider ─────────────────────────────────────────────────────

final excludedFoodsListProvider =
    NotifierProvider<ExcludedFoodsListNotifier, ExcludedFoodsListState>(
  ExcludedFoodsListNotifier.new,
);

class ExcludedFoodsListNotifier extends Notifier<ExcludedFoodsListState> {
  Timer? _debounceTimer;

  @override
  ExcludedFoodsListState build() {
    ref.onDispose(() => _debounceTimer?.cancel());
    Future.microtask(() => loadIngredients());
    return const ExcludedFoodsListState(isLoading: true);
  }

  Future<void> loadIngredients() async {
    final category = state.selectedCategory?.value;
    final search = state.searchQuery.isEmpty ? null : state.searchQuery;

    state = state.copyWith(
      isLoading: true,
      isSearching: false,
      ingredients: [],
      currentPage: 0,
      hasMore: true,
      error: () => null,
    );

    try {
      final repo = ref.read(ingredientRepositoryProvider);

      // Cache-first: returns cached data if available, otherwise fetches
      final items = await repo.getIngredients(
        category: category,
        search: search,
        page: 0,
      );

      state = state.copyWith(
        ingredients: items,
        isLoading: false,
        hasMore: items.length >= IngredientRepository.pageSize,
      );

      // Background refresh: fetch fresh data from Supabase
      _refreshInBackground(repo, category, search);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: () => e.toString(),
      );
    }
  }

  void _refreshInBackground(
    IngredientRepository repo,
    String? category,
    String? search,
  ) async {
    try {
      final freshItems = await repo.refreshFromNetwork(
        category: category,
        search: search,
        page: 0,
      );

      // Only update if data actually changed and we're still on the same view
      final currentCategory = state.selectedCategory?.value;
      final currentSearch =
          state.searchQuery.isEmpty ? null : state.searchQuery;

      if (currentCategory != category || currentSearch != search) return;
      if (state.currentPage != 0) return;

      // Compare: if fresh data differs from current, update UI
      if (_listsAreDifferent(state.ingredients, freshItems)) {
        state = state.copyWith(
          ingredients: freshItems,
          hasMore: freshItems.length >= IngredientRepository.pageSize,
        );
      }
    } catch (_) {
      // Silent fail — we already have cached data showing
    }
  }

  bool _listsAreDifferent(
    List<IngredientItem> a,
    List<IngredientItem> b,
  ) {
    if (a.length != b.length) return true;
    for (var i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id || a[i].name != b[i].name) return true;
    }
    return false;
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore || state.isLoading) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final nextPage = state.currentPage + 1;
      final repo = ref.read(ingredientRepositoryProvider);
      final items = await repo.getIngredients(
        category: state.selectedCategory?.value,
        search: state.searchQuery.isEmpty ? null : state.searchQuery,
        page: nextPage,
      );
      state = state.copyWith(
        ingredients: [...state.ingredients, ...items],
        currentPage: nextPage,
        hasMore: items.length >= IngredientRepository.pageSize,
        isLoadingMore: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false);
    }
  }

  void changeCategory(IngredientCategory? category) {
    if (state.selectedCategory == category) return;
    state = state.copyWith(selectedCategory: () => category);
    loadIngredients();
  }

  void search(String query) {
    _debounceTimer?.cancel();

    state = state.copyWith(
      searchQuery: query,
      isSearching: query.isNotEmpty,
    );

    if (query.isEmpty) {
      loadIngredients();
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      loadIngredients();
    });
  }
}
