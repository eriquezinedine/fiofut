import 'package:fio_fut/apps/client/features/home/data/repositories/home_repository.dart';
import 'package:fio_fut/apps/client/features/home/domain/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Provider for HomeRepository.
final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return const HomeRepositoryImpl();
});

/// Implementation of the HomeRepository.
class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl();

  @override
  Future<HomeData> getHomeData() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock data matching the design
    return HomeData(
      caloriesData: const CaloriesData(
        consumed: 1300,
        goal: 2000,
        protein: 50,
        proteinGoal: 150,
        carbs: 50,
        carbsGoal: 250,
        fat: 50,
        fatGoal: 70,
      ),
      hydrationData: const HydrationData(
        consumed: 0,
        goal: 3250,
      ),
      weekDays: _generateWeekDays(),
      mealItems: _getMockMealItems(),
      streak: 7,
    );
  }

  @override
  Future<HomeData> getHomeDataForDate(DateTime date) async {
    // TODO: Implement actual API call with date parameter
    return getHomeData();
  }

  @override
  Future<void> updateCalories(CaloriesData caloriesData) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> updateHydration(HydrationData hydrationData) async {
    // No longer used — hydration is now per-record via addWaterIntake/deleteWaterIntake.
  }

  @override
  Future<List<MealItem>> getMealItems() async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(milliseconds: 500));
    return _getMockMealItems()
        .where((item) => item.type == MealItemType.meal)
        .toList();
  }

  @override
  Future<List<MealItem>> getExerciseItems() async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(milliseconds: 500));
    return _getMockMealItems()
        .where((item) => item.type == MealItemType.exercise)
        .toList();
  }

  // Helper methods for mock data
  List<WeekDay> _generateWeekDays() {
    final today = DateTime.now();
    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));

    return List.generate(7, (index) {
      final date = startOfWeek.add(Duration(days: index));
      final isToday = date.day == today.day &&
          date.month == today.month &&
          date.year == today.year;

      // Saturday selected by default (index 5 = Saturday)
      final isSelected = index == 5;

      return WeekDay(
        date: date,
        dayName: _getDayName(date.weekday),
        dayNumber: date.day,
        isSelected: isSelected,
        isToday: isToday,
        hasMeals: index == 5 || index == 4, // Friday and Saturday have meals
        hasExercise: index == 5, // Saturday has exercise
      );
    });
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Lun';
      case 2:
        return 'Mar';
      case 3:
        return 'Mié';
      case 4:
        return 'Jue';
      case 5:
        return 'Vie';
      case 6:
        return 'Sáb';
      case 7:
        return 'Dom';
      default:
        return '';
    }
  }

  @override
  Future<DailyNutritionSummary> getDailyNutrition(
    String userId,
    DateTime date,
  ) async {
    final result = await Supabase.instance.client.rpc(
      'get_daily_nutrition',
      params: {
        'p_user_id': userId,
        'p_date': date.toIso8601String().split('T').first,
      },
    );
    final list = result as List<dynamic>? ?? [];
    if (list.isEmpty) return DailyNutritionSummary.empty;
    return DailyNutritionSummary.fromJson(list[0] as Map<String, dynamic>);
  }

  @override
  Future<List<DailyMealItem>> getDailyMeals(
    String userId,
    DateTime date,
  ) async {
    final result = await Supabase.instance.client.rpc(
      'get_daily_meals',
      params: {
        'p_user_id': userId,
        'p_date': date.toIso8601String().split('T').first,
      },
    );
    final list = result as List<dynamic>? ?? [];
    return list
        .map((e) => DailyMealItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<DailyWaterSummary> getDailyWater(String userId, DateTime date) async {
    final client = Supabase.instance.client;
    final dateStr = date.toIso8601String().split('T').first;

    final rows = await client
        .from('water_intake')
        .select()
        .eq('id_user_profile', userId)
        .eq('intake_date', dateStr)
        .order('created_at', ascending: false);

    final records =
        rows.map((r) => WaterIntakeRecord.fromJson(r)).toList();
    final totalMl = records.fold<int>(0, (sum, r) => sum + r.amountMl);

    return DailyWaterSummary(totalMl: totalMl, records: records);
  }

  @override
  Future<WaterIntakeRecord> addWaterIntake({
    required String userId,
    required int amountMl,
    required DateTime date,
  }) async {
    final client = Supabase.instance.client;
    final now = DateTime.now();
    final dateStr = date.toIso8601String().split('T').first;
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

    final data = await client
        .from('water_intake')
        .insert({
          'id_user_profile': userId,
          'amount_ml': amountMl,
          'intake_date': dateStr,
          'intake_time': timeStr,
        })
        .select()
        .single();

    return WaterIntakeRecord.fromJson(data);
  }

  @override
  Future<void> deleteWaterIntake(String recordId) async {
    await Supabase.instance.client
        .from('water_intake')
        .delete()
        .eq('id', recordId);
  }

  List<MealItem> _getMockMealItems() {
    return [
      const MealItem(
        id: '1',
        name: 'Pollo Frito...',
        description: 'Pollo frito crujiente con especias',
        calories: 988,
        imageUrl: 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=400',
        type: MealItemType.meal,
        protein: 54,
        carbs: 28,
        fat: 60,
        isCompleted: true,
        time: '10:10 PM',
      ),
      const MealItem(
        id: '2',
        name: 'Ensalada César',
        description: 'Ensalada fresca con pollo y aderezo',
        calories: 320,
        imageUrl: 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=400',
        type: MealItemType.meal,
        protein: 20,
        carbs: 12,
        fat: 9,
        isCompleted: false,
        time: '1:30 PM',
      ),
      const MealItem(
        id: '3',
        name: 'Cardio Matutino',
        description: '30 minutos de trote',
        calories: 250,
        imageUrl: 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=400',
        type: MealItemType.exercise,
        protein: 0,
        carbs: 0,
        fat: 0,
        isCompleted: true,
        time: '7:00 AM',
      ),
      const MealItem(
        id: '4',
        name: 'Entrenamiento de Fuerza',
        description: '45 minutos de pesas',
        calories: 350,
        imageUrl: 'https://images.unsplash.com/photo-1581009146145-b5ef050c149a?w=400',
        type: MealItemType.exercise,
        protein: 0,
        carbs: 0,
        fat: 0,
        isCompleted: false,
        time: '6:00 PM',
      ),
    ];
  }
}
