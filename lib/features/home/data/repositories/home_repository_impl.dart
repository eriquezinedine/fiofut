import 'package:fio_fut/features/home/data/repositories/home_repository.dart';
import 'package:fio_fut/features/home/domain/models/models.dart';

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
        consumed: 1500,
        goal: 2000,
        protein: 120,
        carbs: 180,
        fat: 55,
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
    // TODO: Implement actual API call
    await Future.delayed(const Duration(milliseconds: 500));
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
