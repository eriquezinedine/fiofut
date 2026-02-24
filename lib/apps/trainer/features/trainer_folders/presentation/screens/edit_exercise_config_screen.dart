import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../data/repositories/trainer_folder_repository.dart';
import '../../domain/models/folder_exercise_item.dart';
import '../../domain/providers/trainer_serie_config_provider.dart';
import '../widgets/trainer_exercise_config.dart';

class EditExerciseConfigScreen extends ConsumerStatefulWidget {
  const EditExerciseConfigScreen({required this.item, super.key});

  final FolderExerciseItem item;

  @override
  ConsumerState<EditExerciseConfigScreen> createState() =>
      _EditExerciseConfigScreenState();
}

class _EditExerciseConfigScreenState
    extends ConsumerState<EditExerciseConfigScreen> {
  bool _saving = false;

  SerieConfigKey get _configKey => (
        exerciseId: widget.item.exercise.id,
        repiteType: repiteTypeFor(widget.item.exercise.exerciseType),
      );

  @override
  void initState() {
    super.initState();
    if (widget.item.configSets.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(trainerSerieConfigProvider(_configKey).notifier)
            .initWithSeries(widget.item.configSets);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch to keep provider alive
    ref.watch(trainerSerieConfigProvider(_configKey));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.white),
        ),
        title: Text(
          'Editar Series',
          style: AppTextStyles.h3.copyWith(color: AppColors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TrainerExerciseConfig(exercise: widget.item.exercise),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: AppButton(
              text: 'Guardar',
              isLoading: _saving,
              onPressed: _save,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final series = ref.read(trainerSerieConfigProvider(_configKey));
      final repo = ref.read(trainerFolderRepositoryProvider);
      await repo.updateExerciseSeries(
        itemId: widget.item.id,
        series: series,
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
