import 'dart:async';

import 'package:fio_fut/apps/client/features/exercise_home/domain/providers/exercise_home/exercise_home_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:fio_fut/apps/client/features/home/domain/providers/week_provider.dart';

// ISAR disabled
// import '../../../data/local/exercise_local_source_provider.dart';
// import '../../../data/local/pending_schedule.dart';
import '../../../data/repositories/exercise_home_repository.dart';
import '../../model/exercise.dart';
import '../../model/exercise_schedule_item.dart';

final exerciseHomeProvider =
    NotifierProvider<ExerciseHomeNotifier, ExerciseHomeState>(
  ExerciseHomeNotifier.new,
);

class ExerciseHomeNotifier extends Notifier<ExerciseHomeState> {
  ExerciseHomeRepository get _repo => ref.read(exerciseHomeRepositoryProvider);

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
        // _syncAllPending(); // ISAR disabled
      });
      return ExerciseHomeState(selectedDateKey: key);
    }

    return const ExerciseHomeState();
  }

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

      final items = await _repo.fetchExercisesForDate(
        userId: userId,
        date: date,
      );

      // ISAR disabled - no pending items merge
      // final pendingItems = await _getPendingForDate(date);

      final updatedCache =
          Map<String, List<ExerciseScheduleItem>>.from(state.cache);
      updatedCache[key] = items;
      state = state.copyWith(cache: updatedCache);
    } catch (e) {
      // ISAR disabled - no fallback to pending items
      // final pendingItems = await _getPendingForDate(date);
      // if (pendingItems.isNotEmpty) {
      //   final updatedCache =
      //       Map<String, List<ExerciseScheduleItem>>.from(state.cache);
      //   updatedCache[key] = pendingItems;
      //   state = state.copyWith(cache: updatedCache);
      // }
    }
  }

  // ISAR disabled
  // /// Safely get pending items for a date (never throws).
  // Future<List<ExerciseScheduleItem>> _getPendingForDate(DateTime date) async {
  //   try {
  //     final dateStr = date.toIso8601String().split('T').first;
  //     final local = ref.read(exerciseLocalSourceProvider);
  //     final pending = await local.getPendingForDate(dateStr);
  //     return pending.map(_repo.pendingToScheduleItem).toList();
  //   } catch (_) {
  //     return [];
  //   }
  // }

  Future<void> reload() async {
    final weekState = ref.read(weekProvider);
    if (weekState is WeekLoaded) {
      await _fetchAndCache(weekState.selectedDate);
    }
  }

  // ISAR disabled
  // /// Forces sync of all pending items to Supabase and reloads.
  // /// Call this BEFORE navigating to workout flow.
  // Future<void> forceSyncPending() async {
  //   try {
  //     final local = ref.read(exerciseLocalSourceProvider);
  //     final allPending = await local.getAllPending();
  //     if (allPending.isNotEmpty) {
  //       await _syncPendingItems(allPending);
  //     }
  //   } catch (_) {
  //     // Silently fail
  //   }
  // }

  /// Optimistic add: immediately adds to state + syncs to Supabase.
  Future<void> addOptimistic({
    required List<Exercise> exercises,
    required DateTime date,
    Set<int>? daysOfWeek,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    // Build pending items using repository
    final pendingItems = _repo.buildPendingSchedules(
      exercises: exercises,
      userId: userId,
      date: date,
      daysOfWeek: daysOfWeek,
      startDate: startDate,
      endDate: endDate,
    );

    // Convert to schedule items for UI
    final scheduleItems = pendingItems.map(_repo.pendingToScheduleItem).toList();

    // 1. Add to state immediately (optimistic)
    _updateCache(date, (list) => [...list, ...scheduleItems]);

    // ISAR disabled
    // // 2. Persist to Isar (offline safety)
    // try {
    //   final local = ref.read(exerciseLocalSourceProvider);
    //   await local.savePending(pendingItems);
    // } catch (_) {
    //   // Isar not available — still sync directly
    // }

    // 3. Sync to Supabase directly
    for (final item in pendingItems) {
      try {
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

        await _repo.scheduleExercises(
          userId: item.userId,
          exercises: [_repo.pendingToExercise(item)],
          date: DateTime.parse(item.dateStr),
          daysOfWeek: days,
          startDate: start,
          endDate: end,
        );
      } catch (_) {
        // Failed to sync
      }
    }
    // Reload to get real IDs from Supabase
    await reload();
  }

  // ISAR disabled
  // /// Background sync: try to push pending items to Supabase.
  // Future<void> _syncPendingItems(List<PendingSchedule> items) async {
  //   final local = ref.read(exerciseLocalSourceProvider);
  //   final syncedTempIds = <String>[];

  //   for (final item in items) {
  //     try {
  //       Set<int>? days;
  //       DateTime? start;
  //       DateTime? end;

  //       if (item.scheduleType == 'weekly' && item.daysOfWeek != null) {
  //         days = item.daysOfWeek!.split(',').map(int.parse).toSet();
  //         start = item.startDateStr != null
  //             ? DateTime.parse(item.startDateStr!)
  //             : null;
  //         end = item.endDateStr != null
  //             ? DateTime.parse(item.endDateStr!)
  //             : null;
  //       }

  //       await _repo.scheduleExercises(
  //         userId: item.userId,
  //         exercises: [_repo.pendingToExercise(item)],
  //         date: DateTime.parse(item.dateStr),
  //         daysOfWeek: days,
  //         startDate: start,
  //         endDate: end,
  //       );

  //       syncedTempIds.add(item.tempId);
  //     } catch (_) {
  //       // Failed to sync — keep in Isar for later retry
  //       await local.incrementRetry(item.tempId);
  //     }
  //   }

  //   // Remove successfully synced from Isar
  //   if (syncedTempIds.isNotEmpty) {
  //     await local.deletePendingByTempIds(syncedTempIds);
  //     // Reload to replace temp items with real backend items
  //     await reload();
  //   }
  // }

  // /// Sync all pending schedules from Isar (called on app start).
  // Future<void> _syncAllPending() async {
  //   try {
  //     final local = ref.read(exerciseLocalSourceProvider);
  //     final allPending = await local.getAllPending();
  //     if (allPending.isNotEmpty) {
  //       _syncPendingItems(allPending);
  //     }
  //   } catch (_) {
  //     // Silently fail — will retry next time
  //   }
  // }

  Future<void> deleteSchedule(String scheduleId) async {
    // Optimistic remove from current date's cache
    final key = state.selectedDateKey;
    final currentList = state.exercises;
    final updatedCache =
        Map<String, List<ExerciseScheduleItem>>.from(state.cache);
    updatedCache[key] =
        currentList.where((e) => e.scheduleId != scheduleId).toList();
    state = state.copyWith(cache: updatedCache);

    // ISAR disabled
    // // If it's a pending item, just remove from Isar
    // if (scheduleId.startsWith('pending_')) {
    //   final local = ref.read(exerciseLocalSourceProvider);
    //   await local.deletePending(scheduleId);
    //   return;
    // }

    if (scheduleId.startsWith('pending_')) return;

    try {
      await _repo.deleteExerciseSchedule(scheduleId);
    } catch (e) {
      await reload();
    }
  }

  // Future<void> addSet(String scheduleId, String exerciseType) async {
  //   // Pending items can't have sets added via backend
  //   if (scheduleId.startsWith('pending_')) return;

  //   final item = state.exercises.firstWhere((e) => e.scheduleId == scheduleId);
  //   final nextNumber = item.sets.isEmpty ? 1 : item.sets.last.setNumber + 1;
  //   final values = _repo.computeNextSetValues(item.sets, exerciseType);

  //   try {
  //     final newSet = await _repo.addSet(
  //       scheduleId: scheduleId,
  //       setNumber: nextNumber,
  //       repetitions: values.reps,
  //       weight: values.weight,
  //       minutes: values.mins,
  //       seconds: values.secs,
  //     );

  //     _updateCurrentDateList((list) => list.map((e) {
  //           if (e.scheduleId != scheduleId) return e;
  //           return _repo.addSetToItem(e, newSet);
  //         }).toList());
  //   } catch (e) {
  //     await reload();
  //   }
  // }

  // Future<void> toggleSet(String setId, bool isCompleted) async {
  //   // Optimistic update
  //   _updateCurrentDateList((list) => list.map((item) {
  //         final hasSet = item.sets.any((s) => s.id == setId);
  //         if (!hasSet) return item;
  //         return _repo.toggleSetInItem(item, setId, isCompleted);
  //       }).toList());

  //   try {
  //     await _repo.toggleSetCompleted(setId: setId, isCompleted: isCompleted);
  //   } catch (e) {
  //     await reload();
  //   }
  // }

  // ── Helpers ───────────────────────────────────────────────────

  /// Updates cache for a specific date.
  void _updateCache(
    DateTime date,
    List<ExerciseScheduleItem> Function(List<ExerciseScheduleItem>) transform,
  ) {
    final key = _dateKey(date);
    final updatedCache =
        Map<String, List<ExerciseScheduleItem>>.from(state.cache);
    updatedCache[key] = transform(updatedCache[key] ?? []);
    state = state.copyWith(cache: updatedCache);
  }

  void updateState({
    required DateTime date,
    required List<ExerciseScheduleItem> items,
  }){
    final key = _dateKey(date);
    final updatedCache =
        Map<String, List<ExerciseScheduleItem>>.from(state.cache);
    updatedCache[key] = items;
    state = state.copyWith(cache: updatedCache);
  }

  /// Updates the series for a specific exercise in the current selected date.
  void updateExerciseSeries({
    required String scheduleId,
    required List<ExerciseSetData> updatedSeries,
  }) {
    final key = state.selectedDateKey;
    final currentList = state.exercises;

    final updatedList = currentList.map((item) {
      if (item.scheduleId != scheduleId) return item;
      return item.copyWith(sets: updatedSeries);
    }).toList();

    final updatedCache =
        Map<String, List<ExerciseScheduleItem>>.from(state.cache);
    updatedCache[key] = updatedList;
    state = state.copyWith(cache: updatedCache);
  }

  /// Updates the exercise list for the currently selected date.
  // void _updateCurrentDateList(
  //   List<ExerciseScheduleItem> Function(List<ExerciseScheduleItem>) transform,
  // ) {
  //   final key = state.selectedDateKey;
  //   final updatedCache =
  //       Map<String, List<ExerciseScheduleItem>>.from(state.cache);
  //   updatedCache[key] = transform(state.exercises);
  //   state = state.copyWith(cache: updatedCache);
  // }
}
