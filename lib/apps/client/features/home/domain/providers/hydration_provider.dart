import 'package:fio_fut/apps/client/features/home/data/repositories/home_repository_impl.dart';
import 'package:fio_fut/apps/client/features/home/domain/models/models.dart';
import 'package:fio_fut/apps/client/features/home/domain/providers/home_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'week_provider.dart';

part 'hydration_state.dart';

/// Provider for the hydration modal state.
/// Loads data directly from Supabase for the selected date.
/// Every add/delete persists immediately — no "save" step needed.
final hydrationProvider = NotifierProvider<HydrationNotifier, HydrationState>(
  HydrationNotifier.new,
);

class HydrationNotifier extends Notifier<HydrationState> {
  @override
  HydrationState build() {
    return const HydrationInitial();
  }

  /// Loads hydration from Supabase for the selected date.
  Future<void> initialize() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    // Get goal from homeProvider
    final homeState = ref.read(homeProvider);
    final goal =
        homeState is HomeLoaded ? homeState.defaultWaterGoal : 2500;

    // Get selected date
    final weekState = ref.read(weekProvider);
    final date =
        weekState is WeekLoaded ? weekState.selectedDate : DateTime.now();

    try {
      final repo = ref.read(homeRepositoryProvider);
      final water = await repo.getDailyWater(userId, date);

      state = HydrationLoaded(
        consumed: water.totalMl,
        goal: goal,
        records: water.records
            .map((r) => HydrationRecord(
                  id: r.id,
                  amount: r.amountMl,
                  time: _formatTime(r.intakeTime),
                  createdAt: r.createdAt,
                ))
            .toList(),
        customAmount: null,
      );
    } catch (_) {
      // Fallback to home state if Supabase fails
      if (homeState is HomeLoaded) {
        state = HydrationLoaded(
          consumed: homeState.hydrationData.consumed,
          goal: goal,
          records: homeState.hydrationData.records,
          customAmount: null,
        );
      } else {
        state = HydrationLoaded(
          consumed: 0,
          goal: goal,
          records: const [],
          customAmount: null,
        );
      }
    }
  }

  /// Adds water with a preset amount and persists to Supabase immediately.
  Future<void> addPresetWater(int amount) async {
    if (state is! HydrationLoaded) return;
    await _addWaterAndPersist(amount);
  }

  /// Stores a custom amount (doesn't add yet).
  void setCustomAmount(int? amount) {
    if (state is! HydrationLoaded) return;
    final current = state as HydrationLoaded;
    state = current.copyWith(customAmount: amount);
  }

  /// Adds the custom amount and persists to Supabase.
  Future<void> addCustomAmount() async {
    if (state is! HydrationLoaded) return;
    final current = state as HydrationLoaded;
    if (current.customAmount != null && current.customAmount! > 0) {
      await _addWaterAndPersist(current.customAmount!);
    }
  }

  Future<void> _addWaterAndPersist(int amount) async {
    if (state is! HydrationLoaded) return;
    final current = state as HydrationLoaded;

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    final weekState = ref.read(weekProvider);
    final date =
        weekState is WeekLoaded ? weekState.selectedDate : DateTime.now();

    // Optimistic UI update
    final now = DateTime.now();
    final timeString = _formatNow(now);
    final tempId = now.millisecondsSinceEpoch.toString();

    final tempRecord = HydrationRecord(
      id: tempId,
      amount: amount,
      time: timeString,
      createdAt: now,
    );

    state = HydrationLoaded(
      consumed: current.consumed + amount,
      goal: current.goal,
      records: [tempRecord, ...current.records],
      customAmount: null,
    );
    _syncToHome();

    // Persist to Supabase
    try {
      final repo = ref.read(homeRepositoryProvider);
      final saved = await repo.addWaterIntake(
        userId: userId,
        amountMl: amount,
        date: date,
      );

      // Replace temp record with real one from Supabase
      if (state is HydrationLoaded) {
        final s = state as HydrationLoaded;
        state = HydrationLoaded(
          consumed: s.consumed,
          goal: s.goal,
          records: s.records.map((r) {
            if (r.id == tempId) {
              return HydrationRecord(
                id: saved.id,
                amount: saved.amountMl,
                time: timeString,
                createdAt: saved.createdAt,
              );
            }
            return r;
          }).toList(),
          customAmount: s.customAmount,
        );
        _syncToHome();
      }
    } catch (_) {
      // Keep optimistic state
    }
  }

  /// Deletes a water record from Supabase immediately.
  Future<void> deleteRecord(String recordId) async {
    if (state is! HydrationLoaded) return;
    final current = state as HydrationLoaded;

    final recordToDelete = current.records.firstWhere(
      (r) => r.id == recordId,
      orElse: () => const HydrationRecord(id: '', amount: 0, time: ''),
    );
    if (recordToDelete.id.isEmpty) return;

    // Optimistic remove
    state = HydrationLoaded(
      consumed:
          (current.consumed - recordToDelete.amount).clamp(0, 999999),
      goal: current.goal,
      records: current.records.where((r) => r.id != recordId).toList(),
      customAmount: current.customAmount,
    );
    _syncToHome();

    // Delete from Supabase
    try {
      final repo = ref.read(homeRepositoryProvider);
      await repo.deleteWaterIntake(recordId);
    } catch (_) {
      // Keep optimistic state
    }
  }

  /// Sync current modal state back to homeProvider so the home card updates.
  void _syncToHome() {
    if (state is! HydrationLoaded) return;
    final s = state as HydrationLoaded;

    // Get the date key for the currently viewed date.
    final weekState = ref.read(weekProvider);
    final date =
        weekState is WeekLoaded ? weekState.selectedDate : DateTime.now();
    final dateKey = date.toIso8601String().split('T').first;

    ref.read(homeProvider.notifier).updateHydration(
          HydrationData(
            consumed: s.consumed,
            goal: s.goal,
            records: s.records,
          ),
          dateKey: dateKey,
        );
  }

  /// Resets the state. Call when leaving.
  void reset() {
    state = const HydrationInitial();
  }

  // ── Helpers ─────────────────────────────────────────────────

  static String _formatNow(DateTime now) {
    final hour =
        now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  static String _formatTime(String timeStr) {
    final parts = timeStr.split(':');
    if (parts.length < 2) return timeStr;
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts[1];
    final displayHour =
        hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final period = hour >= 12 ? 'PM' : 'AM';
    return '$displayHour:$minute $period';
  }
}
