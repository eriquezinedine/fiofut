import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../domain/providers/exercise_folders_provider.dart';
import '../widgets/create_folder_modal.dart';
import '../widgets/folder_card.dart';
import 'exercise_folder_detail_screen.dart';

class TrainerExerciseFoldersScreen extends ConsumerStatefulWidget {
  const TrainerExerciseFoldersScreen({super.key});

  @override
  ConsumerState<TrainerExerciseFoldersScreen> createState() =>
      _TrainerExerciseFoldersScreenState();
}

class _TrainerExerciseFoldersScreenState
    extends ConsumerState<TrainerExerciseFoldersScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(exerciseFoldersProvider.notifier).loadFolders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final foldersState = ref.watch(exerciseFoldersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
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
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: switch (foldersState) {
                ExerciseFoldersInitial() ||
                ExerciseFoldersLoading() =>
                  const Center(
                    child:
                        CircularProgressIndicator(color: AppColors.primary),
                  ),
                ExerciseFoldersError(:final message) => Center(
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
                ExerciseFoldersLoaded(:final folders) => folders.isEmpty
                    ? _EmptyState(onCreateFolder: _createFolder)
                    : RefreshIndicator(
                        color: AppColors.primary,
                        backgroundColor: AppColors.card,
                        onRefresh: () => ref
                            .read(exerciseFoldersProvider.notifier)
                            .loadFolders(),
                        child: ListView.builder(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: folders.length,
                          itemBuilder: (context, index) {
                            final folder = folders[index];
                            return FolderCard(
                              folder: folder,
                              onTap: () => _openFolder(folder.id),
                              onDelete: () =>
                                  _confirmDelete(context, folder.id),
                            );
                          },
                        ),
                      ),
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createFolder,
        backgroundColor: AppColors.primary,
        child: const Icon(LucideIcons.folderPlus, color: AppColors.white),
      ),
    );
  }

  Future<void> _createFolder() async {
    final result = await CreateFolderModal.show(context);
    if (result == null) return;

    await ref.read(exerciseFoldersProvider.notifier).createFolder(
          title: result.title,
          description: result.description,
        );
  }

  void _openFolder(String folderId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExerciseFolderDetailScreen(folderId: folderId),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String folderId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Eliminar carpeta',
          style: AppTextStyles.h3.copyWith(color: AppColors.white),
        ),
        content: Text(
          'Se eliminara la carpeta y su contenido.',
          style:
              AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancelar',
              style:
                  AppTextStyles.body.copyWith(color: AppColors.textMuted),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref
                  .read(exerciseFoldersProvider.notifier)
                  .deleteFolder(folderId);
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

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onCreateFolder});

  final VoidCallback onCreateFolder;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(LucideIcons.folderPlus,
              color: AppColors.textMuted, size: 56),
          const SizedBox(height: 16),
          Text(
            'No hay carpetas',
            style:
                AppTextStyles.h3.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'Crea una carpeta para organizar ejercicios',
            style:
                AppTextStyles.caption.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(height: 24),
          AppButton(
            text: 'Crear Carpeta',
            onPressed: onCreateFolder,
          ),
        ],
      ),
    );
  }
}
