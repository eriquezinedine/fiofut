import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/providers/available_exercises_provider.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/add_exercise/add_exercise_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Modal de seleccion de un solo ejercicio.
/// Retorna el [Exercise] seleccionado o null si se cierra.
class ExercisePickerModal extends ConsumerStatefulWidget {
  const ExercisePickerModal._({this.buttonText = 'Ver estadísticas'});

  final String buttonText;

  static Future<Exercise?> show(
    BuildContext context, {
    String buttonText = 'Ver estadísticas',
  }) {
    return showModalBottomSheet<Exercise>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ExercisePickerModal._(buttonText: buttonText),
    );
  }

  @override
  ConsumerState<ExercisePickerModal> createState() =>
      _ExercisePickerModalState();
}

class _ExercisePickerModalState extends ConsumerState<ExercisePickerModal> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  String? _selectedId;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(availableExercisesProvider.notifier).loadInitial();
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(availableExercisesProvider.notifier).loadMore();
    }
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      ref.read(availableExercisesProvider.notifier).search(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final providerState = ref.watch(availableExercisesProvider);
    final exercises = providerState.exercises;
    final maxHeight = MediaQuery.of(context).size.height * 0.85;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.xl),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: Text('Seleccionar ejercicio',
                        style: AppTextStyles.h2),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(LucideIcons.x,
                        color: AppColors.textPrimary, size: 24),
                  ),
                ],
              ),
            ),
            // Search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: AppSearchField(
                controller: _searchController,
                hint: 'Buscar ejercicio',
                fillColor: Colors.transparent,
                borderRadius: 99,
                borderColor: AppColors.textMuted,
                onChanged: _onSearchChanged,
                onClear: () {
                  ref.read(availableExercisesProvider.notifier).search('');
                },
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            // List
            Flexible(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                itemCount: exercises.length + (providerState.isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= exercises.length) {
                    return const Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    );
                  }
                  final exercise = exercises[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: AddExerciseItem(
                      exercise: exercise,
                      isSelected: _selectedId == exercise.id,
                      onTap: () {
                        setState(() => _selectedId = exercise.id);
                      },
                    ),
                  );
                },
              ),
            ),
            // Button
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                MediaQuery.of(context).viewPadding.bottom + AppSpacing.md,
              ),
              child: GestureDetector(
                onTap: _selectedId != null
                    ? () {
                        final selected = exercises.firstWhere(
                          (e) => e.id == _selectedId,
                        );
                        Navigator.pop(context, selected);
                      }
                    : null,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _selectedId != null ? 1.0 : 0.5,
                  child: Container(
                    width: double.infinity,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      widget.buttonText,
                      style: AppTextStyles.button.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
