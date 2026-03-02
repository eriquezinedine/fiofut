import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/providers/available_exercises_provider.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/providers/exercise_home_provider.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/add_exercise/add_exercise_item.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/add_exercise/muscle_filter_modal.dart';
import 'package:fio_fut/core/extension/muscle_group_extension.dart';
import 'package:fio_fut/core/widgets/modal/schedule_date_modal.dart';
import 'package:fio_fut/core/widgets/modal/select_type_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AddExerciseModal extends ConsumerStatefulWidget {
  const AddExerciseModal._();

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddExerciseModal._(),
    );
  }

  @override
  ConsumerState<AddExerciseModal> createState() => _AddExerciseModalState();
}

class _AddExerciseModalState extends ConsumerState<AddExerciseModal> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  final _selectedIds = <String>{};
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

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  Future<void> _showMuscleFilterMenu(BuildContext context) async {
    final current = ref.read(availableExercisesProvider).muscleFilter;
    final result = await MuscleFilterModal.show(
      context,
      selected: current,
    );
    if (result != null) {
      ref.read(availableExercisesProvider.notifier).setMuscleFilter(result);
    }
  }

  Future<void> _onConfirm(List<Exercise> selected) async {
    // Step 1: Ask schedule type
    final scheduleType = await SelectTypeModal.show(
      context,
      title: 'Programar ejercicio',
    );
    if (scheduleType == null || !mounted) return;

    // Step 2: If weekly, ask for days and date range
    Set<int>? daysOfWeek;
    DateTime? startDate;
    DateTime? endDate;

    if (scheduleType == ScheduleType.weekly) {
      final dateResult = await ScheduleDateModal.show(context);
      if (dateResult == null || !mounted) return;
      daysOfWeek = dateResult.selectedDays;
      startDate = dateResult.startDate;
      endDate = dateResult.endDate;
    }

    // Step 3: Optimistic add — fire and forget, no loading UI
    ref.read(exerciseHomeProvider.notifier).addOptimistic(
      exercises: selected,
      date: DateTime.now(),
      daysOfWeek: daysOfWeek,
      startDate: startDate,
      endDate: endDate,
    );

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final providerState = ref.watch(availableExercisesProvider);
    final maxHeight = MediaQuery.of(context).size.height * 0.92;

    // Apply multi-muscle filter locally if needed
    final exercises = providerState.muscleFilter.length > 1
        ? providerState.exercises
            .where((e) =>
                providerState.muscleFilter.contains(e.muscleMain.muscleGroup))
            .toList()
        : providerState.exercises;

    final count = _selectedIds.length;

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
            _buildDragHandle(),
            _buildHeader(context),
            _buildSearchField(),
            Flexible(
              child: _buildContent(exercises, providerState.isLoading,
                  providerState.hasMore),
            ),
            _buildFooter(context, count, exercises),
            SizedBox(
              height:
                  MediaQuery.of(context).viewPadding.bottom + AppSpacing.xs,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Padding(
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
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Añadir ejercicios',
              style: AppTextStyles.h2,
            ),
          ),
          CustomGestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              LucideIcons.x,
              color: AppColors.textPrimary,
              size: AppSpacing.iconMd,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xs,
        AppSpacing.lg,
        AppSpacing.xs,
      ),
      child: AppSearchField(
        controller: _searchController,
        hint: 'Buscar por nombre',
        fillColor: Colors.transparent,
        borderRadius: 99,
        borderColor: AppColors.textMuted,
        onChanged: _onSearchChanged,
        onClear: () {
          ref.read(availableExercisesProvider.notifier).search('');
        },
      ),
    );
  }

  Widget _buildContent(
      List<Exercise> exercises, bool isLoading, bool hasMore) {
    return ListView(
      controller: _scrollController,
      padding: EdgeInsets.zero,
      children: [
        _buildSectionHeader(title: 'Todos los ejercicios', showFilter: true),
        if (exercises.isEmpty && !isLoading)
          _buildEmptyState()
        else
          _buildExerciseList(exercises),
        if (isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
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
          ),
      ],
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required bool showFilter,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.xs,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textDescription,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.24,
              ),
            ),
          ),
          if (showFilter) _buildMuscleFilterButton(),
        ],
      ),
    );
  }

  Widget _buildMuscleFilterButton() {
    final muscleFilter = ref.watch(
      availableExercisesProvider.select((s) => s.muscleFilter),
    );
    final label = muscleFilter.isEmpty
        ? 'Todos'
        : muscleFilter.length == 1
            ? muscleFilter.first.getLabel
            : '${muscleFilter.length} músculos';
    return Row(
      children: [
        Text(
          'Musculos: ',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textDescription,
          ),
        ),
        CustomGestureDetector(
          onTap: () => _showMuscleFilterMenu(context),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.surface),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: AppSpacing.xxs,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Icon(
                  LucideIcons.chevronDown,
                  color: AppColors.white,
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseList(List<Exercise> exercises) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.xs,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: Column(
        spacing: AppSpacing.xs,
        children: exercises
            .map(
              (exercise) => AddExerciseItem(
                exercise: exercise,
                isSelected: _selectedIds.contains(exercise.id),
                onTap: () => _toggleSelection(exercise.id),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: Text(
        'No se encontraron ejercicios',
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textDescription,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildFooter(
      BuildContext context, int count, List<Exercise> exercises) {
    final hasSelection = count > 0;
    final label = hasSelection
        ? 'Añadir $count ejercicios'
        : 'Añadir ejercicios';

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: CustomGestureDetector(
        onTap: hasSelection
            ? () {
                final selected = exercises
                    .where((e) => _selectedIds.contains(e.id))
                    .toList();
                _onConfirm(selected);
              }
            : null,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: hasSelection ? 1.0 : 0.6,
          child: Container(
            width: double.infinity,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(
              label,
              style: AppTextStyles.button.copyWith(
                color: AppColors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
