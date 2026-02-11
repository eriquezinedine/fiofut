import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart' as router;
import 'package:lucide_icons/lucide_icons.dart';

import 'package:fio_fut/core/router/app_routes.dart';
import '../../domain/providers/exercises_provider.dart';
import '../../domain/providers/muscles_provider.dart';
import '../widgets/exercise_card.dart';

class ExercisesListScreen extends ConsumerStatefulWidget {
  const ExercisesListScreen({super.key});

  @override
  ConsumerState<ExercisesListScreen> createState() =>
      _ExercisesListScreenState();
}

class _ExercisesListScreenState extends ConsumerState<ExercisesListScreen> {
  final _searchController = TextEditingController();

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
    final musclesAsync = ref.watch(musclesProvider);
    final muscleMap = musclesAsync.whenOrNull(
      data: (muscles) => {for (final m in muscles) m.id: m.name},
    ) ?? {};

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Row(
                children: [
                  Text(
                    'Ejercicios',
                    style: AppTextStyles.h2.copyWith(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () =>
                        router.GoRouter.of(context).push(AppRoutes.adminExerciseNew),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        LucideIcons.plus,
                        color: AppColors.black,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AppSearchField(
                controller: _searchController,
                hint: 'Buscar ejercicios...',
                onChanged: (query) {
                  ref
                      .read(exercisesProvider.notifier)
                      .searchExercises(query);
                },
                onClear: () {
                  _searchController.clear();
                  ref.read(exercisesProvider.notifier).loadExercises();
                },
              ),
            ),

            const SizedBox(height: 16),

            // List
            Expanded(
              child: switch (exercisesState) {
                ExercisesInitial() ||
                ExercisesLoading() =>
                  const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primary),
                  ),
                ExercisesError(:final message) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(LucideIcons.alertTriangle,
                            color: AppColors.error, size: 48),
                        const SizedBox(height: 12),
                        Text(
                          message,
                          style: AppTextStyles.body
                              .copyWith(color: AppColors.error),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ExercisesLoaded(:final exercises) => exercises.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(LucideIcons.dumbbell,
                                color: AppColors.textMuted, size: 56),
                            const SizedBox(height: 16),
                            Text(
                              'No hay ejercicios',
                              style: AppTextStyles.h3
                                  .copyWith(color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Agrega tu primer ejercicio',
                              style: AppTextStyles.caption
                                  .copyWith(color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        color: AppColors.primary,
                        backgroundColor: AppColors.card,
                        onRefresh: () => ref
                            .read(exercisesProvider.notifier)
                            .loadExercises(),
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: exercises.length,
                          itemBuilder: (context, index) {
                            final exercise = exercises[index];
                            return ExerciseCard(
                              exercise: exercise,
                              primaryMuscleName: exercise.primaryMuscleId != null
                                  ? muscleMap[exercise.primaryMuscleId]
                                  : null,
                              onTap: () => router.GoRouter.of(context).push(
                                '/admin/exercises/${exercise.id}',
                              ),
                              onDelete: () =>
                                  _confirmDelete(context, exercise.id),
                            );
                          },
                        ),
                      ),
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Eliminar ejercicio',
          style: AppTextStyles.h3.copyWith(color: AppColors.white),
        ),
        content: Text(
          'Esta accion no se puede deshacer.',
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancelar',
              style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(exercisesProvider.notifier).deleteExercise(id);
            },
            child: Text(
              'Eliminar',
              style: AppTextStyles.body.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
