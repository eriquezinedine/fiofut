import 'package:flutter_riverpod/flutter_riverpod.dart';

final trainerBottomNavIndexProvider =
    NotifierProvider<TrainerBottomNavNotifier, int>(
  TrainerBottomNavNotifier.new,
);

class TrainerBottomNavNotifier extends Notifier<int> {
  @override
  int build() {
    ref.keepAlive();
    return 0;
  }

  void setIndex(int index) {
    state = index;
  }
}
