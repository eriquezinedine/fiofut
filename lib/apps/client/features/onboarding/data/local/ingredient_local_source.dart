import 'package:isar/isar.dart';

import '../../data/repositories/ingredient_repository.dart';
import 'cached_ingredient.dart';
import 'cached_search_result.dart';

class IngredientLocalSource {
  IngredientLocalSource(this._isar);

  final Isar _isar;

  static const _pageSize = 20;

  // ── Ingredients by category ─────────────────────────────────────

  Future<List<IngredientItem>> getByCategory(
    String? category,
    int page,
  ) async {
    final query = category != null
        ? _isar.cachedIngredients
            .filter()
            .categoryEqualTo(category)
            .sortByName()
        : _isar.cachedIngredients.where().sortByName();

    final results = await query
        .offset(page * _pageSize)
        .limit(_pageSize)
        .findAll();

    return results
        .map((c) => IngredientItem(
              id: c.ingredientId,
              name: c.name,
              category: c.category,
            ))
        .toList();
  }

  Future<bool> hasCachedCategory(String? category) async {
    final count = category != null
        ? await _isar.cachedIngredients
            .filter()
            .categoryEqualTo(category)
            .count()
        : await _isar.cachedIngredients.count();
    return count > 0;
  }

  Future<void> saveIngredients(List<IngredientItem> items) async {
    await _isar.writeTxn(() async {
      for (final item in items) {
        final existing = await _isar.cachedIngredients
            .filter()
            .ingredientIdEqualTo(item.id)
            .findFirst();

        final cached = existing ?? CachedIngredient();
        cached.ingredientId = item.id;
        cached.name = item.name;
        cached.category = item.category;

        await _isar.cachedIngredients.put(cached);
      }
    });
  }

  // ── Search results ──────────────────────────────────────────────

  Future<List<IngredientItem>?> getSearchResult(
    String query,
    String? category,
  ) async {
    final cat = category ?? '';
    final result = await _isar.cachedSearchResults
        .filter()
        .queryEqualTo(query)
        .categoryEqualTo(cat)
        .findFirst();

    if (result == null) return null;

    return List.generate(
      result.ingredientNames.length,
      (i) => IngredientItem(
        id: result.ingredientIds[i],
        name: result.ingredientNames[i],
        category: category,
      ),
    );
  }

  Future<void> saveSearchResult(
    String query,
    String? category,
    List<IngredientItem> items,
  ) async {
    await _isar.writeTxn(() async {
      final cat = category ?? '';

      // Remove existing result for this query+category
      final existing = await _isar.cachedSearchResults
          .filter()
          .queryEqualTo(query)
          .categoryEqualTo(cat)
          .findAll();
      if (existing.isNotEmpty) {
        await _isar.cachedSearchResults
            .deleteAll(existing.map((e) => e.isarId).toList());
      }

      final cached = CachedSearchResult()
        ..query = query
        ..category = cat
        ..ingredientNames = items.map((i) => i.name).toList()
        ..ingredientIds = items.map((i) => i.id).toList()
        ..cachedAt = DateTime.now();

      await _isar.cachedSearchResults.put(cached);
    });

    // Also cache individual ingredients
    await saveIngredients(items);
  }
}
