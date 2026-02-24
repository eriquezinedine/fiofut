import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:fio_fut/core/widgets/modal/schedule_date_modal.dart';

import '../../data/repositories/trainer_folder_repository.dart';
import '../../domain/models/folder_exercise_item.dart';
import '../../domain/providers/exercise_folders_provider.dart';
import '../../domain/providers/folder_exercises_provider.dart';
import '../widgets/student_selector_modal.dart';
import '../widgets/skipped_exercises_modal.dart';
import 'edit_exercise_config_screen.dart';
import 'exercise_selector_screen.dart';

class ExerciseFolderDetailScreen extends ConsumerWidget {
  const ExerciseFolderDetailScreen({required this.folderId, super.key});

  final String folderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercisesAsync = ref.watch(folderExercisesProvider(folderId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.white),
        ),
        title: Text(
          'Carpeta',
          style: AppTextStyles.h3.copyWith(color: AppColors.white),
        ),
        actions: [
          IconButton(
            onPressed: () => _assignFolder(context, ref),
            icon: const Icon(LucideIcons.send, color: AppColors.primary),
            tooltip: 'Asignar',
          ),
        ],
      ),
      body: exercisesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (e, _) => Center(
          child: Text(
            e.toString(),
            style: AppTextStyles.body.copyWith(color: AppColors.error),
          ),
        ),
        data: (items) => items.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.dumbbell,
                        color: AppColors.textMuted, size: 56),
                    const SizedBox(height: 16),
                    Text(
                      'Carpeta vacia',
                      style: AppTextStyles.h3
                          .copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Agrega ejercicios a esta carpeta',
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
                    .read(folderExercisesProvider(folderId).notifier)
                    .reload(),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _ExerciseItemCard(
                      item: item,
                      onEdit: () => _editExercise(context, ref, item),
                      onAssign: () => _assignExercise(context, ref, item),
                      onDelete: () {
                        ref
                            .read(folderExercisesProvider(folderId).notifier)
                            .removeExercise(item.id);
                        ref
                            .read(exerciseFoldersProvider.notifier)
                            .loadFolders();
                      },
                    );
                  },
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addExercises(context, ref),
        backgroundColor: AppColors.primary,
        child: const Icon(LucideIcons.plus, color: AppColors.white),
      ),
    );
  }

  Future<void> _addExercises(BuildContext context, WidgetRef ref) async {
    final result = await Navigator.push<List<ExerciseSelection>>(
      context,
      MaterialPageRoute(builder: (_) => const ExerciseSelectorScreen()),
    );
    if (result == null || result.isEmpty) return;

    final notifier = ref.read(folderExercisesProvider(folderId).notifier);
    await notifier.addExercises(
      result
          .map((s) => (exerciseId: s.exerciseId, series: s.series))
          .toList(),
    );
    ref.read(exerciseFoldersProvider.notifier).loadFolders();
  }

  Future<void> _editExercise(
    BuildContext context,
    WidgetRef ref,
    FolderExerciseItem item,
  ) async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => EditExerciseConfigScreen(item: item),
      ),
    );
    if (saved == true) {
      ref.read(folderExercisesProvider(folderId).notifier).reload();
    }
  }

  Future<void> _assignExercise(
    BuildContext context,
    WidgetRef ref,
    FolderExerciseItem item,
  ) async {
    final student = await StudentSelectorModal.show(context);
    if (student == null || !context.mounted) return;

    final schedule = await ScheduleDateModal.show(context);
    if (schedule == null) return;

    try {
      final repo = ref.read(trainerFolderRepositoryProvider);
      final skipped = await repo.assignSingleExerciseItem(
        item: item,
        studentId: student.id,
        schedule: schedule,
      );
      if (!context.mounted) return;
      if (skipped != null) {
        await SkippedExercisesModal.show(context, [skipped]);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${item.exercise.name} asignado a ${student.fullName ?? 'alumno'}',
            ),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _assignFolder(BuildContext context, WidgetRef ref) async {
    final student = await StudentSelectorModal.show(context);
    if (student == null || !context.mounted) return;

    final schedule = await ScheduleDateModal.show(context);
    if (schedule == null) return;

    try {
      final repo = ref.read(trainerFolderRepositoryProvider);
      final skipped = await repo.assignExerciseFolder(
        folderId: folderId,
        studentId: student.id,
        schedule: schedule,
      );
      if (!context.mounted) return;
      if (skipped.isNotEmpty) {
        await SkippedExercisesModal.show(context, skipped);
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              skipped.isEmpty
                  ? 'Carpeta asignada a ${student.fullName ?? 'alumno'}'
                  : 'Carpeta asignada parcialmente a ${student.fullName ?? 'alumno'}',
            ),
            backgroundColor:
                skipped.isEmpty ? AppColors.success : AppColors.warning,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}

class _ExerciseItemCard extends StatelessWidget {
  const _ExerciseItemCard({
    required this.item,
    required this.onEdit,
    required this.onAssign,
    required this.onDelete,
  });

  final FolderExerciseItem item;
  final VoidCallback onEdit;
  final VoidCallback onAssign;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(LucideIcons.trash2, color: AppColors.error),
      ),
      onDismissed: (_) => onDelete(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                LucideIcons.dumbbell,
                color: AppColors.textMuted,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.exercise.name,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      _InfoChip(
                        label: '${item.configSets.isNotEmpty ? item.configSets.length : item.sets} series',
                        color: AppColors.primary,
                      ),
                      _InfoChip(
                        label: item.exercise.exerciseType.displayName,
                        color: AppColors.info,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onAssign,
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  LucideIcons.send,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
            ),
            GestureDetector(
              onTap: onEdit,
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  LucideIcons.pencil,
                  color: AppColors.textMuted,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}
