import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/services/isar_service.dart';
import 'exercise_local_source.dart';

final exerciseLocalSourceProvider = Provider<ExerciseLocalSource>((ref) {
  final isar = ref.watch(isarProvider);
  return ExerciseLocalSource(isar);
});
