import 'package:flutter_riverpod/flutter_riverpod.dart';

final adminBottomNavIndexProvider =
    NotifierProvider<AdminBottomNavNotifier, int>(AdminBottomNavNotifier.new);

class AdminBottomNavNotifier extends Notifier<int> {
  @override
  int build() {
    ref.keepAlive();
    return 0;
  }

  void setIndex(int index) {
    state = index;
  }
}
