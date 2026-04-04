import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Valor entre 0.0 y 1.0 que representa el progreso del scroll entre páginas.
/// 0.0 = página centrada, 1.0 = entre dos páginas.
/// Se usa para controlar la opacidad de elementos según el arrastre del PageView.
final pageScrollProgressProvider = AutoDisposeStateProvider<double>((ref) => 0.0);
