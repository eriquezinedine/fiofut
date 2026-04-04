import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Timer global del entrenamiento (no autoDispose).
/// Cuenta los segundos transcurridos desde que se inicia.
final trainingTimerProvider =
    NotifierProvider<TrainingTimerNotifier, int>(TrainingTimerNotifier.new);

class TrainingTimerNotifier extends Notifier<int> {
  Timer? _timer;

  @override
  int build() => 0;

  void start() {
    if (_timer != null) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state++;
    });
  }

  void pause() {
    _timer?.cancel();
    _timer = null;
  }

  void reset() {
    _timer?.cancel();
    _timer = null;
    state = 0;
  }

  String get formatted {
    final h = state ~/ 3600;
    final m = (state % 3600) ~/ 60;
    final s = state % 60;
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}
