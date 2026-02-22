import 'package:fio_fut/apps/client/features/repose/presentation/widgets/repose_list_sliders/repose_list_sliders.dart';
import 'package:flutter/material.dart';

class ReposeSliderScreen extends StatelessWidget {
  static const String name = 'repose-slider';
  static const String path = '/repose-slider';

  const ReposeSliderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReposeListSliders(muscles: kFakeMuscles);
  }
}