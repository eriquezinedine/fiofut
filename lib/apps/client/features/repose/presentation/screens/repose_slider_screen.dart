import 'package:fio_fut/apps/client/features/repose/domain/providers/all_muscles_repose_provider.dart';
import 'package:fio_fut/apps/client/features/repose/presentation/widgets/repose_list_sliders/repose_list_sliders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReposeSliderScreen extends ConsumerWidget {
  static const String name = 'repose-slider';
  static const String path = '/repose-slider';

  const ReposeSliderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final muscles = ref.watch(allMusclesReposeProvider).asList;
    return ReposeListSliders(muscles: muscles);
  }
}
