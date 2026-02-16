import 'package:isar/isar.dart';

import 'cached_food.dart';

class FoodLocalSource {
  const FoodLocalSource(this._isar);

  final Isar _isar;

  Future<List<CachedFood>?> getFoodsByDate(String dateKey) async {
    final results = await _isar.cachedFoods
        .filter()
        .dateKeyEqualTo(dateKey)
        .findAll();
    return results.isEmpty ? null : results;
  }

  Future<void> saveFoodsByDate(String dateKey, List<CachedFood> items) async {
    await _isar.writeTxn(() async {
      // Delete old cache for this date
      await _isar.cachedFoods.filter().dateKeyEqualTo(dateKey).deleteAll();
      // Insert new
      await _isar.cachedFoods.putAll(items);
    });
  }

  Future<void> clearDate(String dateKey) async {
    await _isar.writeTxn(() async {
      await _isar.cachedFoods.filter().dateKeyEqualTo(dateKey).deleteAll();
    });
  }
}
