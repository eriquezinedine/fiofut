import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../../core/services/isar_service.dart';
import '../local/ingredient_local_source.dart';

// ── Model ────────────────────────────────────────────────────────

class IngredientItem {
  const IngredientItem({
    required this.id,
    required this.name,
    this.category,
  });

  final String id;
  final String name;
  final String? category;

  factory IngredientItem.fromJson(Map<String, dynamic> json) {
    return IngredientItem(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      category: json['category'] as String?,
    );
  }
}

// ── Repository ───────────────────────────────────────────────────

final ingredientRepositoryProvider = Provider<IngredientRepository>((ref) {
  final isar = ref.read(isarProvider);
  return IngredientRepository(isar: isar);
});

class IngredientRepository {
  IngredientRepository({
    required Isar isar,
    SupabaseClient? client,
  })  : _client = client ?? Supabase.instance.client,
        _local = IngredientLocalSource(isar);

  final SupabaseClient _client;
  final IngredientLocalSource _local;

  static const pageSize = 20;

  /// Loads ingredients with cache-first strategy.
  /// Returns cached data immediately if available,
  /// then fetches from network to update cache.
  Future<List<IngredientItem>> getIngredients({
    String? category,
    String? search,
    int page = 0,
  }) async {
    // For search queries, check search result cache
    if (search != null && search.isNotEmpty) {
      final cached = await _local.getSearchResult(search, category);
      if (cached != null && cached.isNotEmpty) return cached;
    }

    // For category browsing, check ingredient cache
    if (search == null || search.isEmpty) {
      final hasCached = await _local.hasCachedCategory(category);
      if (hasCached) {
        final cached = await _local.getByCategory(category, page);
        if (cached.isNotEmpty) return cached;
      }
    }

    // Cache miss — fetch from Supabase
    return _fetchAndCache(category: category, search: search, page: page);
  }

  /// Fetches fresh data from Supabase in background and updates cache.
  /// Returns the fresh items.
  Future<List<IngredientItem>> refreshFromNetwork({
    String? category,
    String? search,
    int page = 0,
  }) async {
    return _fetchAndCache(category: category, search: search, page: page);
  }

  Future<List<IngredientItem>> _fetchAndCache({
    String? category,
    String? search,
    int page = 0,
  }) async {
    var query = _client.from('ingredient').select('id, name, category');

    if (category != null) {
      query = query.eq('category', category);
    }

    if (search != null && search.isNotEmpty) {
      query = query.ilike('name', '%$search%');
    }

    final from = page * pageSize;
    final to = from + pageSize - 1;

    final data = await query.order('name').range(from, to);
    final items = data.map((json) => IngredientItem.fromJson(json)).toList();

    // Cache results
    if (search != null && search.isNotEmpty) {
      await _local.saveSearchResult(search, category, items);
    } else {
      await _local.saveIngredients(items);
    }

    return items;
  }
}
