import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfigurationExerciseScreen extends ConsumerWidget {
  const ConfigurationExerciseScreen({super.key});

  static const String path = '/configuration-exercise';
  static const String name = 'configuration-exercise';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          'Configuración de ejercicios',
          style: AppTextStyles.titleMedium,
        ),
      ),
      body: const SizedBox.shrink(),
    );
  }
}
