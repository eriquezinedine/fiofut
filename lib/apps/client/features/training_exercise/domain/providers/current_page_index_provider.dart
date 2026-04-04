import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentPageIndexProvider = AutoDisposeStateProvider<int>((ref) => 0);
