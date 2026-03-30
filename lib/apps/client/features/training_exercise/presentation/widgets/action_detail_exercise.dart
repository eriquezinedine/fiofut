import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/training_exercise/training_exercise.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ActionDetailExercise extends ConsumerWidget {
  const ActionDetailExercise({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isStarted = ref.watch(trainingSessionProvider).isStarted;

    return isStarted? AnimatedHeartIcon()  : AnimatedInfoIcon(
          icon: LucideIcons.info,
          onTap: () => TrainingTopBar.showInfoDialog(context),
        );
  }
}
