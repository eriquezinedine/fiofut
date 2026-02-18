import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/add_exercise/add_exercise_item.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/add_exercise/muscle_filter_modal.dart';
import 'package:fio_fut/core/extension/muscle_group_extension.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:model/model.dart';

class AddExerciseModal extends StatefulWidget {
  const AddExerciseModal._({
    required this.exercises,
    required this.recentExercises,
    required this.onConfirm,
  });

  final List<Exercise> exercises;
  final List<Exercise> recentExercises;
  final void Function(List<Exercise> selected) onConfirm;

  static Future<void> show(
    BuildContext context, {
    required List<Exercise> exercises,
    List<Exercise> recentExercises = const [],
    required void Function(List<Exercise> selected) onConfirm,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddExerciseModal._(
        exercises: exercises,
        recentExercises: recentExercises,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<AddExerciseModal> createState() => _AddExerciseModalState();
}

class _AddExerciseModalState extends State<AddExerciseModal> {
  final _searchController = TextEditingController();
  final _selectedIds = <String>{};
  Set<MuscleGroup> _muscleFilter = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Exercise> get _filteredExercises {
    final query = _searchController.text.toLowerCase().trim();
    return widget.exercises.where((e) {
      final matchesSearch =
          query.isEmpty || e.title.toLowerCase().contains(query);
      final matchesMuscle = _muscleFilter.isEmpty ||
          _muscleFilter.contains(e.muscleMain.muscleGroup);
      return matchesSearch && matchesMuscle;
    }).toList();
  }

  List<Exercise> get _selectedExercises =>
      widget.exercises.where((e) => _selectedIds.contains(e.id)).toList();

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _showMuscleFilterMenu(BuildContext context) {
    MuscleFilterModal.show(
      context,
      selected: _muscleFilter,
      onConfirm: (selected) {
        setState(() => _muscleFilter = selected);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.92;
    final filtered = _filteredExercises;
    final hasSearch = _searchController.text.isNotEmpty;
    final showRecents =
        !hasSearch && widget.recentExercises.isNotEmpty && _muscleFilter.isEmpty;
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
            // Drag handle
            _buildDragHandle(),

            // Header
            _buildHeader(context),

            // Search field
            _buildSearchField(),

            // Lista
            Flexible(
              child: _buildContent(filtered, showRecents),
            ),

            // Footer con botón
            _buildFooter(context, count),

            SizedBox(
              height: MediaQuery.of(context).viewPadding.bottom + AppSpacing.xs,
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
        onChanged: (_) => setState(() {}),
        onClear: () => setState(() {}),
      ),
    );
  }

  Widget _buildContent(List<Exercise> filtered, bool showRecents) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // Sección Recientes
        if (showRecents) ...[
          _buildSectionHeader(title: 'Recientes', showFilter: false),
          _buildExerciseList(widget.recentExercises, bottomBorder: true),
        ],

        // Sección Todos los ejercicios
        _buildSectionHeader(title: 'Todos los ejercicios', showFilter: true),

        if (filtered.isEmpty)
          _buildEmptyState()
        else
          _buildExerciseList(filtered),
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
    final label = _muscleFilter.isEmpty
        ? 'Todos'
        : _muscleFilter.length == 1
            ? _muscleFilter.first.getLabel
            : '${_muscleFilter.length} músculos';
    return Row(
      children: [
        Text('Musculos: ', style: AppTextStyles.caption.copyWith(
          color: AppColors.textDescription
        ),),
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

  Widget _buildExerciseList(
    List<Exercise> exercises, {
    bool bottomBorder = false,
  }) {
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

  Widget _buildFooter(BuildContext context, int count) {
    final hasSelection = count > 0;
    final label = hasSelection ? 'Añadir $count ejercicios' : 'Añadir ejercicios';

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
                Navigator.pop(context);
                widget.onConfirm(_selectedExercises);
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

