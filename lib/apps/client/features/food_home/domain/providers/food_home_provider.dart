import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../core/services/isar_service.dart';
import '../../../home/domain/models/meal_item.dart';
import '../../../home/domain/providers/week_provider.dart';
import '../../../register_food/domain/providers/food_provider_detail.dart';
import '../../data/local/food_local_source.dart';
import '../../data/repositories/food_home_repository.dart';
import '../models/food_home_item.dart';

// ── Helpers ─────────────────────────────────────────────────────

String _dateKey(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

// ── Provider ────────────────────────────────────────────────────

final foodHomeProvider =
    NotifierProvider<FoodHomeNotifier, Map<String, List<FoodHomeItem>>>(
  FoodHomeNotifier.new,
);

/// Derived provider: items for the currently selected date.
final currentDateFoodItemsProvider = Provider<List<FoodHomeItem>>((ref) {
  final weekState = ref.watch(weekProvider);
  final foodMap = ref.watch(foodHomeProvider);
  if (weekState is! WeekLoaded) return [];
  final key = _dateKey(weekState.selectedDate);
  return foodMap[key] ?? [];
});

class FoodHomeNotifier extends Notifier<Map<String, List<FoodHomeItem>>> {
  late FoodHomeRepository _repo;
  late FoodLocalSource _local;
  static const _uuid = Uuid();

  /// The currently loaded date range.
  String? _loadedStartKey;
  String? _loadedEndKey;

  /// Track which ranges we've already fetched from network.
  final Set<String> _fetchedRanges = {};

  @override
  Map<String, List<FoodHomeItem>> build() {
    _repo = ref.read(foodHomeRepositoryProvider);
    final isar = ref.read(isarProvider);
    _local = FoodLocalSource(isar);

    // Listen only to actual date/week changes (ignore dot updates).
    ref.listen(weekProvider, (prev, next) {
      if (next is! WeekLoaded) return;
      final prevLoaded = prev is WeekLoaded ? prev : null;
      if (prevLoaded != null &&
          prevLoaded.selectedDate == next.selectedDate &&
          prevLoaded.currentWeekStart == next.currentWeekStart) {
        return; // Only dots changed, skip.
      }
      _ensureDateLoaded(next.selectedDate, next.currentWeekStart);
    });

    // Load on init.
    final weekState = ref.read(weekProvider);
    if (weekState is WeekLoaded) {
      Future.microtask(
        () => _ensureDateLoaded(
          weekState.selectedDate,
          weekState.currentWeekStart,
        ),
      );
    }

    return {};
  }

  // ── Load logic ─────────────────────────────────────────────

  /// Checks if the selected date is within the loaded range.
  /// If not, fetches the visible week range from first/last calendar dates.
  void _ensureDateLoaded(DateTime selectedDate, DateTime weekStart) {
    final selectedKey = _dateKey(selectedDate);

    // If selected date is inside already-loaded range, no fetch needed.
    if (_loadedStartKey != null &&
        _loadedEndKey != null &&
        selectedKey.compareTo(_loadedStartKey!) >= 0 &&
        selectedKey.compareTo(_loadedEndKey!) <= 0) {
      return;
    }

    // Selected date is outside range -> load the visible week.
    final weekNotifier = ref.read(weekProvider.notifier);
    final weekDays = weekNotifier.getWeekDays(weekStart);
    if (weekDays.isEmpty) return;

    final firstDate = weekDays.first.date;
    final lastDate = weekDays.last.date;

    loadFoodsForRange(firstDate, lastDate);
  }

  /// Loads foods for a date range (typically Mon-Sun from the visible week).
  Future<void> loadFoodsForRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final startKey = _dateKey(startDate);
    final endKey = _dateKey(endDate);
    final rangeId = '$startKey|$endKey';
    final todayKey = _dateKey(DateTime.now());

    // Update loaded range.
    _loadedStartKey = startKey;
    _loadedEndKey = endKey;

    // Build all date keys in the range.
    final dayCount = endDate.difference(startDate).inDays + 1;
    final allDates = List.generate(
      dayCount,
      (i) => _dateKey(startDate.add(Duration(days: i))),
    );

    // 1. Show Isar cache immediately for dates we don't have yet.
    for (final key in allDates) {
      if (state.containsKey(key)) continue;
      try {
        final cached = await _local.getFoodsByDate(key);
        if (cached != null) {
          final loadedItems = _repo.fromCachedFoods(cached);
          _updateDateItems(key, loadedItems.cast<FoodHomeItem>());
        }
      } catch (_) {}
    }

    // Update dots from cached data.
    _updateWeekDots(startDate, allDates);

    // 2. Decide if network fetch is needed.
    final rangeContainsToday = allDates.contains(todayKey);

    // Past ranges: fetch once. Current week: always re-fetch.
    if (!rangeContainsToday && _fetchedRanges.contains(rangeId)) return;

    // 3. Fetch from Supabase (single query for the range).
    try {
      final remoteMap = await _repo.fetchFoodsByWeek(startKey, endKey);
      _fetchedRanges.add(rangeId);

      // 4. Update state FIRST (so UI renders immediately).
      for (final key in allDates) {
        final remoteItems = remoteMap[key] ?? [];
        if (key == todayKey) {
          _mergeLoadedItems(key, remoteItems);
        } else {
          _updateDateItems(key, remoteItems.cast<FoodHomeItem>());
        }
      }

      // Update dots with fresh data.
      _updateWeekDots(startDate, allDates);

      // 5. Cache to Isar in background (don't block UI).
      for (final key in allDates) {
        final remoteItems = remoteMap[key] ?? [];
        try {
          final cachedFoods = _repo.toCachedFoods(key, remoteItems);
          await _local.saveFoodsByDate(key, cachedFoods);
        } catch (e) {
          developer.log('zineKey - Isar cache error for $key: $e',
              name: 'FoodHome');
        }
      }
    } catch (e) {
      developer.log('zineKey - Error loading range $startKey..$endKey: $e',
          name: 'FoodHome');
    }
  }

  /// Updates the weekProvider dots for the loaded dates.
  void _updateWeekDots(DateTime startDate, List<String> allDates) {
    final weekNotifier = ref.read(weekProvider.notifier);
    for (var i = 0; i < allDates.length; i++) {
      final date = startDate.add(Duration(days: i));
      final items = state[allDates[i]] ?? [];
      final hasFood = items.whereType<FoodHomeLoaded>().isNotEmpty;
      weekNotifier.updateDayActivity(date: date, hasMeals: hasFood);
    }
  }

  // ── Helpers ─────────────────────────────────────────────────

  void _mergeLoadedItems(String key, List<FoodHomeLoaded> loaded) {
    final current = state[key] ?? [];
    final pendingItems = current
        .where((item) => item is FoodHomeLoading || item is FoodHomeError)
        .toList();
    _updateDateItems(key, [...pendingItems, ...loaded]);
  }

  void _updateDateItems(String key, List<FoodHomeItem> items) {
    state = {...state, key: items};
  }

  // ── Photo flow ──────────────────────────────────────────────

  void addLoadingItem(File imageFile) {
    final tempId = _uuid.v4();
    final todayKey = _dateKey(DateTime.now());
    final current = state[todayKey] ?? [];

    final loadingItem = FoodHomeLoading(tempId: tempId, imageFile: imageFile);
    _updateDateItems(todayKey, [loadingItem, ...current]);

    _processPhoto(tempId, imageFile);
  }

  Future<void> _processPhoto(String tempId, File file) async {
    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser!.id;
      final accessToken = supabase.auth.currentSession?.accessToken;
      if (accessToken == null) throw Exception('No hay sesion activa');

      // 1. Upload image.
      final ext = file.path.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$ext';
      final path = '$userId/$fileName';

      await supabase.storage.from('food-images').upload(path, file);
      final imageUrl =
          supabase.storage.from('food-images').getPublicUrl(path);

      developer.log('zineKey - Image uploaded: $imageUrl', name: 'FoodHome');

      // 2. Call gemini edge function.
      final response = await supabase.functions.invoke(
        'gemini',
        body: {'action': 'recognize-food', 'image_url': imageUrl},
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      final data = response.data as Map<String, dynamic>;
      developer.log('zineKey - Gemini response: $data', name: 'FoodHome');

      if (data['success'] != true) {
        throw Exception(data['error'] as String? ?? 'Error desconocido');
      }

      // 3. Parse result.
      final result = FoodRecognitionResult.fromJson(data);

      // 4. Build MealItem.
      final mealItem = MealItem(
        id: result.id,
        name: result.title,
        description: result.description,
        calories: result.totalCalories.round(),
        imageUrl: result.imageUrl,
        type: MealItemType.meal,
        protein: result.totalProtein.round(),
        carbs: result.totalCarbohydrates.round(),
        fat: result.totalFat.round(),
        isCompleted: true,
      );

      // 5. Resolve loading -> loaded.
      _resolveLoadingItem(tempId, mealItem, result.id, result);

      // 6. Update Isar cache for today.
      final todayKey = _dateKey(DateTime.now());
      final currentLoaded = (state[todayKey] ?? [])
          .whereType<FoodHomeLoaded>()
          .toList();
      final cachedFoods = _repo.toCachedFoods(todayKey, currentLoaded);
      await _local.saveFoodsByDate(todayKey, cachedFoods);

      // 7. Update dot for today.
      ref.read(weekProvider.notifier).updateDayActivity(
            date: DateTime.now(),
            hasMeals: true,
          );
    } catch (e) {
      developer.log('zineKey - Photo processing error: $e', name: 'FoodHome');
      _failLoadingItem(tempId, e.toString().replaceAll('Exception: ', ''));
    }
  }

  void _resolveLoadingItem(
    String tempId,
    MealItem mealItem,
    String foodId,
    FoodRecognitionResult detail,
  ) {
    final todayKey = _dateKey(DateTime.now());
    final current = state[todayKey] ?? [];

    final updated = current.map((item) {
      if (item is FoodHomeLoading && item.tempId == tempId) {
        return FoodHomeLoaded(
          mealItem: mealItem,
          foodId: foodId,
          detail: detail,
        );
      }
      return item;
    }).toList();

    // Deduplicate by foodId (remote fetch may have added the same food
    // while the photo was still processing).
    final seen = <String>{};
    final deduped = updated.where((item) {
      if (item is FoodHomeLoaded) return seen.add(item.foodId);
      return true;
    }).toList();

    _updateDateItems(todayKey, deduped);
  }

  void _failLoadingItem(String tempId, String message) {
    final todayKey = _dateKey(DateTime.now());
    final current = state[todayKey] ?? [];

    final updated = current.map((item) {
      if (item is FoodHomeLoading && item.tempId == tempId) {
        return FoodHomeError(
          tempId: tempId,
          imageFile: item.imageFile,
          message: message,
        );
      }
      return item;
    }).toList();

    _updateDateItems(todayKey, updated);
  }

  void retryItem(String tempId) {
    final todayKey = _dateKey(DateTime.now());
    final current = state[todayKey] ?? [];

    File? imageFile;
    final updated = current.map((item) {
      if (item is FoodHomeError && item.tempId == tempId) {
        imageFile = item.imageFile;
        return FoodHomeLoading(tempId: tempId, imageFile: item.imageFile);
      }
      return item;
    }).toList();

    _updateDateItems(todayKey, updated);

    if (imageFile != null) {
      _processPhoto(tempId, imageFile!);
    }
  }
}
