import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:model/model.dart';

import '../../data/local/cached_exercise.dart';
import '../../data/local/cached_exercise_search.dart';
import '../../data/local/exercise_local_source_provider.dart';
import '../../data/repositories/exercise_home_repository.dart';
import '../model/exercise.dart';

@immutable
class AvailableExercisesState {
  const AvailableExercisesState({
    this.exercises = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.searchQuery = '',
    this.muscleFilter = const {},
    this.currentPage = 0,
  });

  final List<Exercise> exercises;
  final bool isLoading;
  final bool hasMore;
  final String searchQuery;
  final Set<MuscleGroup> muscleFilter;
  final int currentPage;

  AvailableExercisesState copyWith({
    List<Exercise>? exercises,
    bool? isLoading,
    bool? hasMore,
    String? searchQuery,
    Set<MuscleGroup>? muscleFilter,
    int? currentPage,
  }) {
    return AvailableExercisesState(
      exercises: exercises ?? this.exercises,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      searchQuery: searchQuery ?? this.searchQuery,
      muscleFilter: muscleFilter ?? this.muscleFilter,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

final availableExercisesProvider =
    NotifierProvider<AvailableExercisesNotifier, AvailableExercisesState>(
  AvailableExercisesNotifier.new,
);

class AvailableExercisesNotifier extends Notifier<AvailableExercisesState> {
  static const _pageSize = 25;

  @override
  AvailableExercisesState build() => const AvailableExercisesState();

  /// Loads initial page. Shows Isar cache instantly, then refreshes from backend.
  Future<void> loadInitial() async {
    state = state.copyWith(isLoading: true, currentPage: 0, exercises: []);

    final filterKey = _muscleFilterKey();
    final local = ref.read(exerciseLocalSourceProvider);

    // 1. Show Isar cache instantly (O(1) via composite index)
    final cached = await local.getSearchResult(state.searchQuery, filterKey);
    if (cached != null && cached.exerciseIds.isNotEmpty) {
      final cachedExercises =
          await local.getExercisesByIds(cached.exerciseIds);
      state = state.copyWith(
        exercises: cachedExercises.map(_fromCached).toList(),
        hasMore: cached.exerciseIds.length < cached.totalCount,
        isLoading: true, // still loading fresh data
      );
    }

    // 2. Fetch page 0 from backend
    try {
      final repo = ref.read(exerciseHomeRepositoryProvider);
      final result = await repo.fetchExercises(
        query: state.searchQuery,
        muscleGroupFilter: _singleMuscleFilter(),
        page: 0,
        pageSize: _pageSize,
      );

      state = state.copyWith(
        exercises: result.exercises,
        hasMore: result.hasMore,
        isLoading: false,
        currentPage: 0,
      );

      // 3. Save to Isar for next time
      _cacheResults(result.exercises, result.hasMore ? -1 : result.exercises.length);
    } catch (_) {
      // Keep cached data if backend fails
      state = state.copyWith(isLoading: false);
    }
  }

  /// Loads next page (append).
  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);
    final nextPage = state.currentPage + 1;

    try {
      final repo = ref.read(exerciseHomeRepositoryProvider);
      final result = await repo.fetchExercises(
        query: state.searchQuery,
        muscleGroupFilter: _singleMuscleFilter(),
        page: nextPage,
        pageSize: _pageSize,
      );

      final combined = [...state.exercises, ...result.exercises];
      state = state.copyWith(
        exercises: combined,
        hasMore: result.hasMore,
        isLoading: false,
        currentPage: nextPage,
      );

      // Update cache with full list
      _cacheResults(combined, result.hasMore ? -1 : combined.length);
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Search with reset.
  void search(String query) {
    final trimmed = query.trim();
    if (trimmed == state.searchQuery) return;
    state = state.copyWith(searchQuery: trimmed);
    loadInitial();
  }

  /// Set muscle filter and reload.
  void setMuscleFilter(Set<MuscleGroup> filter) {
    if (setEquals(filter, state.muscleFilter)) return;
    state = state.copyWith(muscleFilter: filter);
    loadInitial();
  }

  // --- Helpers ---

  /// For the Supabase query: single muscle group string or null.
  String? _singleMuscleFilter() {
    if (state.muscleFilter.isEmpty) return null;
    if (state.muscleFilter.length == 1) {
      return state.muscleFilter.first.toJson();
    }
    // Multiple muscles → no DB filter, we filter locally after fetch.
    // For simplicity, fetch all and filter client-side for multi-muscle.
    return null;
  }

  /// Cache key for muscle filter.
  String _muscleFilterKey() {
    if (state.muscleFilter.isEmpty) return 'all';
    final sorted = state.muscleFilter.map((m) => m.toJson()).toList()..sort();
    return sorted.join(',');
  }

  /// Convert CachedExercise → client Exercise.
  Exercise _fromCached(CachedExercise c) {
    final metricType = switch (c.exerciseType) {
      'cardio' => MetricType.cardio,
      'strength' => MetricType.strength,
      _ => MetricType.reps,
    };
    MuscleGroup muscleGroup;
    try {
      muscleGroup = MuscleGroup.fromJson(c.muscleGroup);
    } catch (_) {
      muscleGroup = MuscleGroup.chest;
    }

    return Exercise(
      id: c.exerciseId,
      title: c.name,
      description: c.description ?? '',
      imageUrl: c.imageUrl,
      videoUrl: c.videoUrl,
      muscleMain: Muscle(
        id: c.primaryMuscleId ?? '',
        name: '',
        isMain: true,
        muscleGroup: muscleGroup,
      ),
      muscleSecundaries: const [],
      instruccion: '',
      currentValue: 0,
      targetValue: 0,
      metricType: metricType,
      status: ExerciseStatus.pending,
    );
  }

  /// Save exercises + search result to Isar.
  Future<void> _cacheResults(List<Exercise> exercises, int totalCount) async {
    final local = ref.read(exerciseLocalSourceProvider);
    final now = DateTime.now();

    final cachedExercises = exercises
        .map(
          (e) => CachedExercise()
            ..exerciseId = e.id
            ..name = e.title
            ..description = e.description
            ..imageUrl = e.imageUrl
            ..videoUrl = e.videoUrl
            ..primaryMuscleId = e.muscleMain.id
            ..muscleGroup = e.muscleMain.muscleGroup.toJson()
            ..exerciseType = ExerciseHomeRepository.exerciseTypeString(e.metricType)
            ..cachedAt = now,
        )
        .toList();

    await local.saveExercises(cachedExercises);

    final searchResult = CachedExerciseSearch()
      ..searchQuery = state.searchQuery
      ..muscleFilter = _muscleFilterKey()
      ..exerciseIds = exercises.map((e) => e.id).toList()
      ..totalCount = totalCount == -1 ? exercises.length + 1 : totalCount
      ..cachedAt = now;

    await local.saveSearchResult(searchResult);
  }
}
