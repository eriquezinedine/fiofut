import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:fio_fut/apps/client/features/home/domain/providers/week_provider.dart';

import '../../data/repositories/exercise_home_repository.dart';
import '../model/exercise_schedule_item.dart';

final exerciseHomeProvider =
    NotifierProvider<ExerciseHomeNotifier, List<ExerciseScheduleItem>>(
  ExerciseHomeNotifier.new,
);

class ExerciseHomeNotifier extends Notifier<List<ExerciseScheduleItem>> {
  @override
  List<ExerciseScheduleItem> build() {
    ref.listen(weekProvider, (prev, next) {
      if (next is WeekLoaded) {
        final prevLoaded = prev is WeekLoaded ? prev : null;
        if (prevLoaded == null ||
            prevLoaded.selectedDate != next.selectedDate) {
          loadForDate(next.selectedDate);
        }
      }
    });

    // Initial load
    final weekState = ref.read(weekProvider);
    if (weekState is WeekLoaded) {
      Future.microtask(() => loadForDate(weekState.selectedDate));
    }

    return const [];
  }

  Future<void> loadForDate(DateTime date) async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return;

      final repo = ref.read(exerciseHomeRepositoryProvider);
      final items = await repo.fetchExercisesForDate(
        userId: userId,
        date: date,
      );
      state = items;
    } catch (e) {
      // Keep current state on error
    }
  }

  Future<void> reload() async {
    final weekState = ref.read(weekProvider);
    if (weekState is WeekLoaded) {
      await loadForDate(weekState.selectedDate);
    }
  }

  Future<void> deleteSchedule(String scheduleId) async {
    // Optimistic remove
    state = state.where((e) => e.scheduleId != scheduleId).toList();
    try {
      final repo = ref.read(exerciseHomeRepositoryProvider);
      await repo.deleteExerciseSchedule(scheduleId);
    } catch (e) {
      await reload();
    }
  }

  Future<void> addSet(String scheduleId, String exerciseType) async {
    final item = state.firstWhere((e) => e.scheduleId == scheduleId);
    final nextNumber = item.sets.isEmpty ? 1 : item.sets.last.setNumber + 1;

    // Defaults based on exercise type
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
      default: // reps
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

      // Update state
      state = state.map((e) {
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
      }).toList();
    } catch (e) {
      await reload();
    }
  }

  Future<void> toggleSet(String setId, bool isCompleted) async {
    // Optimistic update
    state = state.map((item) {
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
    }).toList();

    try {
      final repo = ref.read(exerciseHomeRepositoryProvider);
      await repo.toggleSetCompleted(setId: setId, isCompleted: isCompleted);
    } catch (e) {
      await reload();
    }
  }
}
