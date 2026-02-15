import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../apps/client/features/onboarding/data/local/cached_ingredient.dart';
import '../../apps/client/features/onboarding/data/local/cached_search_result.dart';

Future<Isar> initIsar() async {
  final dir = await getApplicationDocumentsDirectory();
  return Isar.open(
    [CachedIngredientSchema, CachedSearchResultSchema],
    directory: dir.path,
  );
}

final isarProvider = Provider<Isar>((ref) {
  throw UnimplementedError('isarProvider must be overridden in ProviderScope');
});
