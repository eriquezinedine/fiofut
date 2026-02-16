import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:model/model.dart';

/// Provider that fetches all muscles from the database
final musclesProvider = FutureProvider<List<Muscle>>((ref) async {
  final data = await Supabase.instance.client
      .from('muscle')
      .select()
      .order('name');

  return data.map((json) => Muscle.fromJson(json)).toList();
});
