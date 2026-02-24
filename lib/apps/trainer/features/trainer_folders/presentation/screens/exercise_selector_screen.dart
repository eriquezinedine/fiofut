import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:fio_fut/apps/admin/features/exercises/domain/models/exercise.dart';
import 'package:fio_fut/apps/admin/features/exercises/domain/providers/exercises_provider.dart';
import 'package:fio_fut/apps/client/features/exercise_detail/domain/models/serie_set.dart';

import '../../domain/providers/trainer_serie_config_provider.dart';
import '../widgets/trainer_exercise_config.dart';

class ExerciseSelection {
  const ExerciseSelection({
    required this.exerciseId,
    required this.exerciseType,
    required this.series,
  });

  final String exerciseId;
  final ExerciseType exerciseType;
  final List<SerieSet> series;
}

class ExerciseSelectorScreen extends ConsumerStatefulWidget {
  const ExerciseSelectorScreen({super.key});

  @override
  ConsumerState<ExerciseSelectorScreen> createState() =>
      _ExerciseSelectorScreenState();
}

class _ExerciseSelectorScreenState
    extends ConsumerState<ExerciseSelectorScreen> {
  final _searchController = TextEditingController();

  // Track selected exercise IDs and their types
  final _selectedTypes = <String, ExerciseType>{};

  bool _showConfig = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(exercisesProvider.notifier).loadExercises();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exercisesState = ref.watch(exercisesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          onPressed: () {
            if (_showConfig) {
              setState(() => _showConfig = false);
            } else {
              Navigator.pop(context);
            }
          },
          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.white),
        ),
        title: Text(
          _showConfig ? 'Configurar Series' : 'Seleccionar Ejercicios',
          style: AppTextStyles.h3.copyWith(color: AppColors.white),
        ),
        actions: [
          if (_showConfig && _selectedTypes.isNotEmpty)
            TextButton(
              onPressed: _confirm,
              child: Text(
                'Agregar',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.primary),
              ),
            )
          else if (!_showConfig && _selectedTypes.isNotEmpty)
            TextButton(
              onPressed: _goToConfig,
              child: Text(
                'Siguiente (${_selectedTypes.length})',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.primary),
              ),
            ),
        ],
      ),
      body: _showConfig
          ? _buildConfigView(exercisesState)
          : _buildSelectionView(exercisesState),
    );
  }

  Widget _buildSelectionView(ExercisesState exercisesState) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: AppSearchField(
            controller: _searchController,
            hint: 'Buscar ejercicios...',
            onChanged: (query) {
              ref.read(exercisesProvider.notifier).searchExercises(query);
            },
            onClear: () {
              _searchController.clear();
              ref.read(exercisesProvider.notifier).loadExercises();
            },
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: switch (exercisesState) {
            ExercisesInitial() ||
            ExercisesLoading() =>
              const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ExercisesError(:final message) => Center(
                child: Text(
                  message,
                  style: AppTextStyles.body.copyWith(color: AppColors.error),
                ),
              ),
            ExercisesLoaded(:final exercises) => ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exercises[index];
                  final isSelected =
                      _selectedTypes.containsKey(exercise.id);
                  return _SelectableExerciseCard(
                    exercise: exercise,
                    isSelected: isSelected,
                    onToggle: () {
                      setState(() {
                        if (isSelected) {
                          _selectedTypes.remove(exercise.id);
                        } else {
                          _selectedTypes[exercise.id] =
                              exercise.exerciseType;
                        }
                      });
                    },
                  );
                },
              ),
          },
        ),
      ],
    );
  }

  Widget _buildConfigView(ExercisesState exercisesState) {
    final exercises = switch (exercisesState) {
      ExercisesLoaded(:final exercises) => exercises,
      _ => <Exercise>[],
    };

    final selectedExercises = exercises
        .where((e) => _selectedTypes.containsKey(e.id))
        .toList();

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: selectedExercises.length,
            itemBuilder: (context, index) {
              return TrainerExerciseConfig(
                  exercise: selectedExercises[index]);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: AppButton(
            text: 'Guardar',
            onPressed: _confirm,
          ),
        ),
      ],
    );
  }

  void _goToConfig() {
    setState(() => _showConfig = true);
  }

  void _confirm() {
    final result = _selectedTypes.entries.map((e) {
      final key = (
        exerciseId: e.key,
        repiteType: repiteTypeFor(e.value),
      );
      final series = ref.read(trainerSerieConfigProvider(key));
      return ExerciseSelection(
        exerciseId: e.key,
        exerciseType: e.value,
        series: series,
      );
    }).toList();
    Navigator.pop(context, result);
  }
}

class _SelectableExerciseCard extends StatelessWidget {
  const _SelectableExerciseCard({
    required this.exercise,
    required this.isSelected,
    required this.onToggle,
  });

  final Exercise exercise;
  final bool isSelected;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 1.5)
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                LucideIcons.dumbbell,
                color: AppColors.textMuted,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${exercise.exerciseType.displayName} · ${exercise.location.displayName}',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? LucideIcons.checkCircle2 : LucideIcons.circle,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
