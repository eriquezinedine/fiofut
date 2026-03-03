import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:model/model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:fio_fut/apps/client/features/home/domain/providers/week_provider.dart';

import '../../data/local/exercise_local_source_provider.dart';
import '../../data/local/pending_schedule.dart';
import '../../data/repositories/exercise_home_repository.dart';
import '../model/exercise.dart';
import '../model/exercise_schedule_item.dart';

/// State for exercise home — caches exercise lists per date.
@immutable
class ExerciseHomeState {
  const ExerciseHomeState({
    this.cache = const {},
    this.selectedDateKey = '',
  });

  /// Exercises per date. Key = "yyyy-MM-dd".
  final Map<String, List<ExerciseScheduleItem>> cache;

  /// Currently selected date key.
  final String selectedDateKey;

  /// Convenience getter — returns exercises for the selected date.
  List<ExerciseScheduleItem> get exercises =>
      cache[selectedDateKey] ?? const [];

  ExerciseHomeState copyWith({
    Map<String, List<ExerciseScheduleItem>>? cache,
    String? selectedDateKey,
  }) {
    return ExerciseHomeState(
      cache: cache ?? this.cache,
      selectedDateKey: selectedDateKey ?? this.selectedDateKey,
    );
  }
}

final exerciseHomeProvider =
    NotifierProvider<ExerciseHomeNotifier, ExerciseHomeState>(
  ExerciseHomeNotifier.new,
);

class ExerciseHomeNotifier extends Notifier<ExerciseHomeState> {
  @override
  ExerciseHomeState build() {
    ref.listen(weekProvider, (prev, next) {
      if (next is WeekLoaded) {
        final prevLoaded = prev is WeekLoaded ? prev : null;
        if (prevLoaded == null ||
            prevLoaded.selectedDate != next.selectedDate) {
          _onDateChanged(next.selectedDate);
        }
      }
    });

    // Initial load + sync pending
    final weekState = ref.read(weekProvider);
    if (weekState is WeekLoaded) {
      final key = _dateKey(weekState.selectedDate);
      Future.microtask(() async {
        await _fetchAndCache(weekState.selectedDate);
        _syncAllPending();
      });
      return ExerciseHomeState(selectedDateKey: key);
    }

    return const ExerciseHomeState();
  }

  /// Converts a DateTime to the map key format.
  static String _dateKey(DateTime date) =>
      date.toIso8601String().split('T').first;

  /// Called when the selected date changes.
  void _onDateChanged(DateTime date) {
    final key = _dateKey(date);

    // Switch date key immediately — cached data shows instantly.
    state = state.copyWith(selectedDateKey: key);

    // Fetch from backend if not already cached.
    if (!state.cache.containsKey(key)) {
      _fetchAndCache(date);
    }
  }

  /// Fetch exercises for a date and store in cache.
  Future<void> _fetchAndCache(DateTime date) async {
    final key = _dateKey(date);

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return;

      final repo = ref.read(exerciseHomeRepositoryProvider);
      final items = await repo.fetchExercisesForDate(
        userId: userId,
        date: date,
      );

      // Merge with pending items for this date
      final pendingItems = await _getPendingForDate(date);

      final updatedCache =
          Map<String, List<ExerciseScheduleItem>>.from(state.cache);
      updatedCache[key] = [...items, ...pendingItems];
      state = state.copyWith(cache: updatedCache);
    } catch (e) {
      // On network error, show only pending items from Isar
      final pendingItems = await _getPendingForDate(date);
      if (pendingItems.isNotEmpty) {
        final updatedCache =
            Map<String, List<ExerciseScheduleItem>>.from(state.cache);
        updatedCache[key] = pendingItems;
        state = state.copyWith(cache: updatedCache);
      }
    }
  }

  /// Safely get pending items for a date (never throws).
  Future<List<ExerciseScheduleItem>> _getPendingForDate(DateTime date) async {
    try {
      final dateStr = date.toIso8601String().split('T').first;
      final local = ref.read(exerciseLocalSourceProvider);
      final pending = await local.getPendingForDate(dateStr);
      return pending.map(_pendingToScheduleItem).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> reload() async {
    final weekState = ref.read(weekProvider);
    if (weekState is WeekLoaded) {
      await _fetchAndCache(weekState.selectedDate);
    }
  }

  /// Forces sync of all pending items to Supabase and reloads.
  /// Call this BEFORE navigating to workout flow.
  Future<void> forceSyncPending() async {
    try {
      final local = ref.read(exerciseLocalSourceProvider);
      final allPending = await local.getAllPending();
      if (allPending.isNotEmpty) {
        await _syncPendingItems(allPending);
      }
    } catch (_) {
      // Silently fail
    }
  }

  /// Optimistic add: immediately adds to state + saves to Isar + syncs in background.
  Future<void> addOptimistic({
    required List<Exercise> exercises,
    required DateTime date,
    Set<int>? daysOfWeek,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    final isWeekly = daysOfWeek != null && daysOfWeek.isNotEmpty;
    final dateStr = date.toIso8601String().split('T').first;
    final now = DateTime.now();

    final pendingItems = <PendingSchedule>[];
    final scheduleItems = <ExerciseScheduleItem>[];

    for (final exercise in exercises) {
      final tempId = 'pending_${now.millisecondsSinceEpoch}_${exercise.id}';
      final type = ExerciseHomeRepository.exerciseTypeString(exercise.metricType);

      // Create pending for Isar
      pendingItems.add(PendingSchedule()
        ..tempId = tempId
        ..exerciseId = exercise.id
        ..exerciseName = exercise.title
        ..exerciseDescription = exercise.description
        ..exerciseImageUrl = exercise.imageUrl
        ..exerciseVideoUrl = exercise.videoUrl
        ..exerciseType = type
        ..userId = userId
        ..dateStr = dateStr
        ..scheduleType = isWeekly ? 'weekly' : 'custom'
        ..daysOfWeek = isWeekly
            ? (daysOfWeek.toList()..sort()).join(',')
            : null
        ..startDateStr = isWeekly
            ? (startDate ?? date).toIso8601String().split('T').first
            : null
        ..endDateStr = isWeekly
            ? (endDate ?? date).toIso8601String().split('T').first
            : null
        ..createdAt = now);

      // Create temp ExerciseScheduleItem for the UI
      scheduleItems.add(_buildTempScheduleItem(
        tempId: tempId,
        exercise: exercise,
        type: type,
        dateStr: dateStr,
        daysOfWeek: isWeekly
            ? (daysOfWeek.toList()..sort()).join(',')
            : null,
        startDate: isWeekly ? (startDate ?? date) : null,
        endDate: isWeekly ? (endDate ?? date) : null,
      ));
    }

    // 1. Add to state immediately (optimistic) for the target date
    final key = _dateKey(date);
    final updatedCache =
        Map<String, List<ExerciseScheduleItem>>.from(state.cache);
    updatedCache[key] = [...(updatedCache[key] ?? []), ...scheduleItems];
    state = state.copyWith(cache: updatedCache);

    // 2. Persist to Isar (offline safety) + sync in background
    try {
      final local = ref.read(exerciseLocalSourceProvider);
      await local.savePending(pendingItems);
    } catch (_) {
      // Isar not available — still sync directly
    }

    // 3. Sync in background (fire-and-forget)
    _syncPendingItems(pendingItems);
  }

  /// Background sync: try to push pending items to Supabase.
  Future<void> _syncPendingItems(List<PendingSchedule> items) async {
    final repo = ref.read(exerciseHomeRepositoryProvider);
    final local = ref.read(exerciseLocalSourceProvider);
    final syncedTempIds = <String>[];

    for (final item in items) {
      try {
        final exerciseForSchedule = Exercise(
          id: item.exerciseId,
          title: item.exerciseName,
          description: item.exerciseDescription ?? '',
          imageUrl: item.exerciseImageUrl,
          videoUrl: item.exerciseVideoUrl,
          muscleMain: const Muscle(
            id: '',
            name: '',
            isMain: true,
            muscleGroup: MuscleGroup.chest,
          ),
          muscleSecundaries: const [],
          instruccion: '',
          currentValue: 0,
          targetValue: 0,
          metricType: _metricTypeFromString(item.exerciseType),
          status: ExerciseStatus.pending,
        );

        Set<int>? days;
        DateTime? start;
        DateTime? end;

        if (item.scheduleType == 'weekly' && item.daysOfWeek != null) {
          days = item.daysOfWeek!.split(',').map(int.parse).toSet();
          start = item.startDateStr != null
              ? DateTime.parse(item.startDateStr!)
              : null;
          end = item.endDateStr != null
              ? DateTime.parse(item.endDateStr!)
              : null;
        }

        await repo.scheduleExercises(
          userId: item.userId,
          exercises: [exerciseForSchedule],
          date: DateTime.parse(item.dateStr),
          daysOfWeek: days,
          startDate: start,
          endDate: end,
        );

        syncedTempIds.add(item.tempId);
      } catch (_) {
        // Failed to sync — keep in Isar for later retry
        await local.incrementRetry(item.tempId);
      }
    }

    // Remove successfully synced from Isar
    if (syncedTempIds.isNotEmpty) {
      await local.deletePendingByTempIds(syncedTempIds);
      // Reload to replace temp items with real backend items
      await reload();
    }
  }

  /// Sync all pending schedules from Isar (called on app start).
  Future<void> _syncAllPending() async {
    try {
      final local = ref.read(exerciseLocalSourceProvider);
      final allPending = await local.getAllPending();
      if (allPending.isNotEmpty) {
        _syncPendingItems(allPending);
      }
    } catch (_) {
      // Silently fail — will retry next time
    }
  }

  Future<void> deleteSchedule(String scheduleId) async {
    // Optimistic remove from current date's cache
    final key = state.selectedDateKey;
    final currentList = state.exercises;
    final updatedCache =
        Map<String, List<ExerciseScheduleItem>>.from(state.cache);
    updatedCache[key] =
        currentList.where((e) => e.scheduleId != scheduleId).toList();
    state = state.copyWith(cache: updatedCache);

    // If it's a pending item, just remove from Isar
    if (scheduleId.startsWith('pending_')) {
      final local = ref.read(exerciseLocalSourceProvider);
      await local.deletePending(scheduleId);
      return;
    }

    try {
      final repo = ref.read(exerciseHomeRepositoryProvider);
      await repo.deleteExerciseSchedule(scheduleId);
    } catch (e) {
      await reload();
    }
  }

  Future<void> addSet(String scheduleId, String exerciseType) async {
    // Pending items can't have sets added via backend
    if (scheduleId.startsWith('pending_')) return;

    final currentList = state.exercises;
    final item = currentList.firstWhere((e) => e.scheduleId == scheduleId);
    final nextNumber = item.sets.isEmpty ? 1 : item.sets.last.setNumber + 1;

    final int? reps;
    final double? weight;
    final int? mins;
    final int? secs;

    switch (exerciseType) {
      case 'strength':
        reps = item.sets.isNotEmpty ? item.sets.last.repetitions ?? 10 : 10;
        weight = item.sets.isNotEmpty ? item.sets.last.weight ?? 0 : 0;
        mins = null;
        secs = null;
      case 'cardio':
        reps = null;
        weight = item.sets.isNotEmpty ? item.sets.last.weight ?? 0 : 0;
        mins = item.sets.isNotEmpty ? item.sets.last.minutes ?? 5 : 5;
        secs = item.sets.isNotEmpty ? item.sets.last.seconds ?? 0 : 0;
      default:
        reps = item.sets.isNotEmpty ? item.sets.last.repetitions ?? 10 : 10;
        weight = null;
        mins = null;
        secs = null;
    }

    try {
      final repo = ref.read(exerciseHomeRepositoryProvider);
      final newSet = await repo.addSet(
        scheduleId: scheduleId,
        setNumber: nextNumber,
        repetitions: reps,
        weight: weight,
        minutes: mins,
        seconds: secs,
      );

      _updateCurrentDateList((list) => list.map((e) {
            if (e.scheduleId != scheduleId) return e;
            return ExerciseScheduleItem(
              scheduleId: e.scheduleId,
              exerciseId: e.exerciseId,
              exerciseName: e.exerciseName,
              exerciseDescription: e.exerciseDescription,
              exerciseImageUrl: e.exerciseImageUrl,
              exerciseVideoUrl: e.exerciseVideoUrl,
              exerciseType: e.exerciseType,
              sets: [...e.sets, newSet],
              daysOfWeek: e.daysOfWeek,
              startDate: e.startDate,
              endDate: e.endDate,
              createdById: e.createdById,
              notes: e.notes,
            );
          }).toList());
    } catch (e) {
      await reload();
    }
  }

  Future<void> toggleSet(String setId, bool isCompleted) async {
    // Optimistic update
    _updateCurrentDateList((list) => list.map((item) {
          final updatedSets = item.sets.map((s) {
            if (s.id == setId) {
              return ExerciseSetData(
                id: s.id,
                setNumber: s.setNumber,
                repetitions: s.repetitions,
                weight: s.weight,
                minutes: s.minutes,
                seconds: s.seconds,
                distance: s.distance,
                isCompleted: isCompleted,
                completedAt: isCompleted ? DateTime.now() : null,
              );
            }
            return s;
          }).toList();
          if (updatedSets != item.sets) {
            return ExerciseScheduleItem(
              scheduleId: item.scheduleId,
              exerciseId: item.exerciseId,
              exerciseName: item.exerciseName,
              exerciseDescription: item.exerciseDescription,
              exerciseImageUrl: item.exerciseImageUrl,
              exerciseVideoUrl: item.exerciseVideoUrl,
              exerciseType: item.exerciseType,
              sets: updatedSets,
              daysOfWeek: item.daysOfWeek,
              startDate: item.startDate,
              endDate: item.endDate,
              createdById: item.createdById,
              notes: item.notes,
            );
          }
          return item;
        }).toList());

    try {
      final repo = ref.read(exerciseHomeRepositoryProvider);
      await repo.toggleSetCompleted(setId: setId, isCompleted: isCompleted);
    } catch (e) {
      await reload();
    }
  }

  // ── Helpers ───────────────────────────────────────────────────

  /// Updates the exercise list for the currently selected date.
  void _updateCurrentDateList(
    List<ExerciseScheduleItem> Function(List<ExerciseScheduleItem>) transform,
  ) {
    final key = state.selectedDateKey;
    final updatedCache =
        Map<String, List<ExerciseScheduleItem>>.from(state.cache);
    updatedCache[key] = transform(state.exercises);
    state = state.copyWith(cache: updatedCache);
  }

  /// Build a temp ExerciseScheduleItem from exercise data for the UI.
  ExerciseScheduleItem _buildTempScheduleItem({
    required String tempId,
    required Exercise exercise,
    required String type,
    required String dateStr,
    String? daysOfWeek,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    // Create 3 default temp sets
    final sets = List.generate(
      3,
      (i) => ExerciseSetData(
        id: '${tempId}_set_$i',
        setNumber: i + 1,
        repetitions: type != 'cardio' ? 10 : null,
        weight: type == 'strength' ? 0.0 : null,
        minutes: type == 'cardio' ? 5 : null,
        seconds: type == 'cardio' ? 0 : null,
        isCompleted: false,
      ),
    );

    return ExerciseScheduleItem(
      scheduleId: tempId,
      exerciseId: exercise.id,
      exerciseName: exercise.title,
      exerciseDescription: exercise.description,
      exerciseImageUrl: exercise.imageUrl,
      exerciseVideoUrl: exercise.videoUrl,
      exerciseType: type,
      sets: sets,
      daysOfWeek: daysOfWeek,
      startDate: startDate ?? DateTime.parse(dateStr),
      endDate: endDate ?? DateTime.parse(dateStr),
    );
  }

  /// Convert a PendingSchedule from Isar → ExerciseScheduleItem for the UI.
  ExerciseScheduleItem _pendingToScheduleItem(PendingSchedule p) {
    final sets = List.generate(
      3,
      (i) => ExerciseSetData(
        id: '${p.tempId}_set_$i',
        setNumber: i + 1,
        repetitions: p.exerciseType != 'cardio' ? 10 : null,
        weight: p.exerciseType == 'strength' ? 0.0 : null,
        minutes: p.exerciseType == 'cardio' ? 5 : null,
        seconds: p.exerciseType == 'cardio' ? 0 : null,
        isCompleted: false,
      ),
    );

    return ExerciseScheduleItem(
      scheduleId: p.tempId,
      exerciseId: p.exerciseId,
      exerciseName: p.exerciseName,
      exerciseDescription: p.exerciseDescription,
      exerciseImageUrl: p.exerciseImageUrl,
      exerciseVideoUrl: p.exerciseVideoUrl,
      exerciseType: p.exerciseType,
      sets: sets,
      daysOfWeek: p.daysOfWeek,
      startDate: p.startDateStr != null
          ? DateTime.parse(p.startDateStr!)
          : DateTime.parse(p.dateStr),
      endDate: p.endDateStr != null
          ? DateTime.parse(p.endDateStr!)
          : DateTime.parse(p.dateStr),
    );
  }

  MetricType _metricTypeFromString(String type) => switch (type) {
        'cardio' => MetricType.distance,
        'strength' => MetricType.weight,
        _ => MetricType.reps,
      };
}
