import 'package:fio_fut/apps/client/features/repose/presentation/widgets/example_custom_painter.dart';
import 'package:flutter/material.dart';

class ReposeScreen extends StatelessWidget {
  static const String name = 'repose';
  static const String path = '/repose';

  const ReposeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsetsGeometry.only(bottom: 0),
          child: BodyCustomPaint(width: 200)),
      ),
    );
  }
}
