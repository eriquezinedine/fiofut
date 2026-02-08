import 'package:fio_fut/apps/client/features/home/domain/models/models.dart';
import 'package:fio_fut/apps/client/features/home/domain/providers/home_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'hydration_state.dart';

/// Provider for the hydration modal state.
/// Shows current total from home, but only syncs NEW water when saved.
final hydrationProvider = NotifierProvider<HydrationNotifier, HydrationState>(
  HydrationNotifier.new,
);

/// Notifier that manages the hydration modal state.
class HydrationNotifier extends Notifier<HydrationState> {

  @override
  HydrationState build() {
    return const HydrationInitial();
  }

  /// Initializes the hydration state with current data from home.
  void initialize() {
    final homeState = ref.read(homeProvider);

    if (homeState is HomeLoaded) {
      // Load existing data from home
      state = HydrationLoaded(
        consumed: homeState.hydrationData.consumed,
        goal: homeState.hydrationData.goal,
        records: homeState.hydrationData.records,
        customAmount: null,
      );
    } else {
      state = HydrationLoaded(
        consumed: 0,
        goal: 2500,
        records: const [],
        customAmount: null,
      );
    }
  }

  /// Adds water with a preset amount (250, 500, 1000 ml).
  void addPresetWater(int amount) {
    if (state is! HydrationLoaded) return;
    _addWaterLocally(amount);
  }

  /// Sets a custom amount (doesn't add yet, just stores it).
  void setCustomAmount(int? amount) {
    if (state is! HydrationLoaded) return;
    final currentState = state as HydrationLoaded;
    state = currentState.copyWith(customAmount: amount);
  }

  /// Adds the custom amount to local state.
  void addCustomAmount() {
    if (state is! HydrationLoaded) return;
    final currentState = state as HydrationLoaded;

    if (currentState.customAmount != null && currentState.customAmount! > 0) {
      _addWaterLocally(currentState.customAmount!);
    }
  }

  /// Internal method to add water to local state only.
  void _addWaterLocally(int amount) {
    if (state is! HydrationLoaded) return;
    final currentState = state as HydrationLoaded;

    // Create new record for this session
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';
    final timeString = '$hour:$minute $period';

    final newRecord = HydrationRecord(
      id: now.millisecondsSinceEpoch.toString(),
      amount: amount,
      time: timeString,
      createdAt: now,
    );

    // Update local state
    final newConsumed = currentState.consumed + amount;
    state = HydrationLoaded(
      consumed: newConsumed,
      goal: currentState.goal,
      records: [newRecord, ...currentState.records],
      customAmount: null,
    );
  }

  /// Deletes a water record. Updates local state.
  void deleteRecord(String recordId) {
    if (state is! HydrationLoaded) return;
    final currentState = state as HydrationLoaded;

    // Find the record to delete
    final recordToDelete = currentState.records.firstWhere(
      (r) => r.id == recordId,
      orElse: () => const HydrationRecord(id: '', amount: 0, time: ''),
    );

    if (recordToDelete.id.isEmpty) return;

    // Remove from records
    final updatedRecords =
        currentState.records.where((r) => r.id != recordId).toList();

    // Update consumed amount (can go below initial if deleting home records)
    final newConsumed = (currentState.consumed - recordToDelete.amount).clamp(0, 999999);

    state = HydrationLoaded(
      consumed: newConsumed,
      goal: currentState.goal,
      records: updatedRecords,
      customAmount: currentState.customAmount,
    );
  }

  /// Saves the current hydration state to home provider.
  void saveToHome() {
    if (state is! HydrationLoaded) return;
    final currentState = state as HydrationLoaded;

    // Sync the complete current state to home
    ref.read(homeProvider.notifier).updateHydration(
          HydrationData(
            consumed: currentState.consumed,
            goal: currentState.goal,
            records: currentState.records,
          ),
        );
  }

  /// Resets the state. Call when leaving.
  void reset() {
    state = const HydrationInitial();
  }
}
