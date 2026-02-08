import 'package:fio_fut/apps/client/features/home/domain/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'home_state.dart';

/// Provider for the home screen state.
final homeProvider = NotifierProvider<HomeNotifier, HomeState>(
  HomeNotifier.new,
);

/// Notifier that manages the home screen state.
class HomeNotifier extends Notifier<HomeState> {
  @override
  HomeState build() {
    // TODO: Initialize with actual data from repository
    return const HomeInitial();
  }

  /// Loads the home data for the current user.
  Future<void> loadHomeData() async {
    state = const HomeLoading();

    try {
      // TODO: Fetch data from repository
      // final data = await ref.read(homeRepositoryProvider).getHomeData();

      // Placeholder data
      state = HomeLoaded(
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
          goal: 2500,
        ),
        weekDays: [],
        mealItems: const [
          MealItem(
            id: '1',
            name: 'Pollo Frito...',
            description: 'Pollo frito crujiente con especias',
            calories: 988,
            imageUrl:
                'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=400',
            type: MealItemType.meal,
            protein: 54,
            carbs: 39,
            fat: 60,
            isCompleted: true,
            time: '10:10 PM',
          ),
          MealItem(
            id: '2',
            name: 'Ensalada César',
            description: 'Ensalada fresca con pollo y aderezo',
            calories: 320,
            imageUrl:
                'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=400',
            type: MealItemType.meal,
            protein: 28,
            carbs: 12,
            fat: 18,
            isCompleted: false,
            time: '1:30 PM',
          ),
          MealItem(
            id: '3',
            name: 'Cardio Matutino',
            description: '30 minutos de trote',
            calories: 250,
            imageUrl:
                'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=400',
            type: MealItemType.exercise,
            protein: 0,
            carbs: 0,
            fat: 0,
            isCompleted: true,
            time: '7:00 AM',
          ),
          MealItem(
            id: '4',
            name: 'Entrenamiento de Fuerza',
            description: '45 minutos de pesas',
            calories: 350,
            imageUrl:
                'https://images.unsplash.com/photo-1581009146145-b5ef050c149a?w=400',
            type: MealItemType.exercise,
            protein: 0,
            carbs: 0,
            fat: 0,
            isCompleted: false,
            time: '6:00 PM',
          ),
        ],
        streak: 7,
      );
    } catch (e) {
      state = HomeError(message: e.toString());
    }
  }

  /// Selects a specific day in the week calendar.
  void selectDay(DateTime date) {
    if (state is! HomeLoaded) return;

    final currentState = state as HomeLoaded;
    final updatedDays = currentState.weekDays.map((day) {
      return day.copyWith(
        isSelected: day.date.year == date.year &&
            day.date.month == date.month &&
            day.date.day == date.day,
      );
    }).toList();

    state = currentState.copyWith(weekDays: updatedDays);

    // TODO: Load data for the selected date
  }

  /// Updates the calories data.
  void updateCalories(CaloriesData caloriesData) {
    if (state is! HomeLoaded) return;
    final currentState = state as HomeLoaded;
    state = currentState.copyWith(caloriesData: caloriesData);
  }

  /// Updates the hydration data.
  void updateHydration(HydrationData hydrationData) {
    if (state is! HomeLoaded) return;
    final currentState = state as HomeLoaded;
    state = currentState.copyWith(hydrationData: hydrationData);
  }

  /// Adds water intake (in ml) with optional records.
  void addWater(int amount, {List<HydrationRecord>? newRecords}) {
    if (state is! HomeLoaded) return;
    final currentState = state as HomeLoaded;
    final currentHydration = currentState.hydrationData;

    // Merge existing records with new records
    final updatedRecords = newRecords != null
        ? [...newRecords, ...currentHydration.records]
        : currentHydration.records;

    state = currentState.copyWith(
      hydrationData: currentHydration.copyWith(
        consumed: currentHydration.consumed + amount,
        records: updatedRecords,
      ),
    );
  }

  /// Refreshes all home data.
  Future<void> refresh() async {
    await loadHomeData();
  }
}
