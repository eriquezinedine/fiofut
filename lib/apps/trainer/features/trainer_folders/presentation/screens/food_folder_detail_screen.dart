import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:fio_fut/apps/admin/features/meals/presentation/widgets/food_card.dart';
import 'package:fio_fut/apps/client/features/register_food/pages/food_detail_page.dart';
import 'package:fio_fut/core/widgets/modal/schedule_date_modal.dart';

import '../../data/repositories/trainer_folder_repository.dart';
import '../../domain/providers/folder_foods_provider.dart';
import '../../domain/providers/food_folders_provider.dart';
import '../widgets/student_selector_modal.dart';
import 'food_selector_screen.dart';

class FoodFolderDetailScreen extends ConsumerWidget {
  const FoodFolderDetailScreen({required this.folderId, super.key});

  final String folderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foodsAsync = ref.watch(folderFoodsProvider(folderId));

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
      body: foodsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (e, _) => Center(
          child: Text(
            e.toString(),
            style: AppTextStyles.body.copyWith(color: AppColors.error),
          ),
        ),
        data: (foods) => foods.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.utensilsCrossed,
                        color: AppColors.textMuted, size: 56),
                    const SizedBox(height: 16),
                    Text(
                      'Carpeta vacia',
                      style: AppTextStyles.h3
                          .copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Agrega comidas a esta carpeta',
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                color: AppColors.primary,
                backgroundColor: AppColors.card,
                onRefresh: () =>
                    ref.read(folderFoodsProvider(folderId).notifier).reload(),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: foods.length,
                  itemBuilder: (context, index) {
                    final food = foods[index];
                    return Dismissible(
                      key: ValueKey(food.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(LucideIcons.trash2,
                            color: AppColors.error),
                      ),
                      onDismissed: (_) {
                        ref
                            .read(folderFoodsProvider(folderId).notifier)
                            .removeFood(food.id);
                        ref
                            .read(foodFoldersProvider.notifier)
                            .loadFolders();
                      },
                      child: FoodCard(
                        food: food,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                FoodDetailPage(foodId: food.id),
                          ),
                        ),
                        onDelete: () {
                          ref
                              .read(folderFoodsProvider(folderId).notifier)
                              .removeFood(food.id);
                          ref
                              .read(foodFoldersProvider.notifier)
                              .loadFolders();
                        },
                      ),
                    );
                  },
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addFoods(context, ref),
        backgroundColor: AppColors.primary,
        child: const Icon(LucideIcons.plus, color: AppColors.white),
      ),
    );
  }

  Future<void> _addFoods(BuildContext context, WidgetRef ref) async {
    final selectedIds = await Navigator.push<List<String>>(
      context,
      MaterialPageRoute(builder: (_) => const FoodSelectorScreen()),
    );
    if (selectedIds == null || selectedIds.isEmpty) return;

    await ref.read(folderFoodsProvider(folderId).notifier).addFoods(selectedIds);
    ref.read(foodFoldersProvider.notifier).loadFolders();
  }

  Future<void> _assignFolder(BuildContext context, WidgetRef ref) async {
    final student = await StudentSelectorModal.show(context);
    if (student == null || !context.mounted) return;

    final schedule = await ScheduleDateModal.show(context);
    if (schedule == null) return;

    try {
      final repo = ref.read(trainerFolderRepositoryProvider);
      await repo.assignFoodFolder(
        folderId: folderId,
        studentId: student.id,
        schedule: schedule,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Carpeta asignada a ${student.fullName ?? 'alumno'}',
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
}
