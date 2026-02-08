import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the bottom navigation index with keepAlive.
final bottomNavIndexProvider =
    NotifierProvider<BottomNavNotifier, int>(BottomNavNotifier.new);

/// Notifier that manages the bottom navigation index.
class BottomNavNotifier extends Notifier<int> {
  @override
  int build() {
    // Keep the state alive even when there are no listeners
    ref.keepAlive();
    return 0;
  }

  /// Updates the current navigation index.
  void setIndex(int index) {
    state = index;
  }
}