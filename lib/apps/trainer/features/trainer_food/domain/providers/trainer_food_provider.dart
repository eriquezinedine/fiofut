import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:fio_fut/apps/admin/features/meals/data/repositories/food_repository.dart';
import 'package:fio_fut/apps/admin/features/meals/domain/models/food.dart';

enum TrainerFoodTab { app, mine }

class TrainerFoodState {
  const TrainerFoodState({
    this.appFoods = const [],
    this.myFoods = const [],
    this.isLoading = false,
    this.error,
  });

  final List<Food> appFoods;
  final List<Food> myFoods;
  final bool isLoading;
  final String? error;

  TrainerFoodState copyWith({
    List<Food>? appFoods,
    List<Food>? myFoods,
    bool? isLoading,
    String? error,
  }) {
    return TrainerFoodState(
      appFoods: appFoods ?? this.appFoods,
      myFoods: myFoods ?? this.myFoods,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

final trainerFoodProvider =
    NotifierProvider<TrainerFoodNotifier, TrainerFoodState>(
  TrainerFoodNotifier.new,
);

class TrainerFoodNotifier extends Notifier<TrainerFoodState> {
  String get _userId => Supabase.instance.client.auth.currentUser!.id;

  @override
  TrainerFoodState build() => const TrainerFoodState();

  Future<void> loadAll() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = ref.read(foodRepositoryProvider);
      final results = await Future.wait([
        repo.getAdminFoods(),
        repo.getFoodsByCreator(_userId),
      ]);
      state = TrainerFoodState(
        appFoods: results[0],
        myFoods: results[1],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> search(String query, TrainerFoodTab tab) async {
    if (query.isEmpty) {
      await loadAll();
      return;
    }
    state = state.copyWith(isLoading: true, error: null);
    try {
      final repo = ref.read(foodRepositoryProvider);
      if (tab == TrainerFoodTab.app) {
        final foods = await repo.searchAdminFoods(query);
        state = state.copyWith(appFoods: foods, isLoading: false);
      } else {
        final foods = await repo.searchFoodsByCreator(query, _userId);
        state = state.copyWith(myFoods: foods, isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> deleteFood(String id) async {
    try {
      final repo = ref.read(foodRepositoryProvider);
      await repo.deleteFood(id);
      await loadAll();
      return true;
    } catch (e) {
      return false;
    }
  }
}
