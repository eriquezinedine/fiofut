import 'package:fio_fut/apps/client/features/repose/presentation/widgets/repose_list_sliders/repose_list_sliders.dart';
import 'package:flutter/material.dart';

class ReposeScreen extends StatelessWidget {
  static const String name = 'repose';
  static const String path = '/repose';

  const ReposeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReposeListSliders(muscles: kFakeMuscles);
  }
}
