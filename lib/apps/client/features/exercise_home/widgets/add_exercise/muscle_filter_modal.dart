import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/core/extension/muscle_group_extension.dart';
import 'package:fio_fut/core/widgets/fade_in.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:model/model.dart';

// Definición de grupos de músculos
class _MuscleCategory {
  const _MuscleCategory({required this.label, required this.muscles});
  final String label;
  final List<MuscleGroup> muscles;
}

const _categories = [
  _MuscleCategory(
    label: 'ABDOMINALES',
    muscles: [MuscleGroup.abs, MuscleGroup.obliques],
  ),
  _MuscleCategory(
    label: 'PECHO',
    muscles: [MuscleGroup.chest],
  ),
  _MuscleCategory(
    label: 'HOMBROS',
    muscles: [
      MuscleGroup.frontDeltoid,
      MuscleGroup.lateralDeltoid,
      MuscleGroup.rearDeltoid,
    ],
  ),
];

// Músculos que pertenecen a algún grupo
final _groupedMuscles = _categories.expand((c) => c.muscles).toSet();

// Músculos individuales (sin grupo)
final _individualMuscles = MuscleGroup.values
    .where((m) => !_groupedMuscles.contains(m))
    .toList();

class MuscleFilterModal extends StatefulWidget {
  const MuscleFilterModal._({required this.selected});

  final Set<MuscleGroup> selected;

  static Future<Set<MuscleGroup>?> show(
    BuildContext context, {
    required Set<MuscleGroup> selected,
  }) {
    return showModalBottomSheet<Set<MuscleGroup>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MuscleFilterModal._(selected: Set.from(selected)),
    );
  }

  @override
  State<MuscleFilterModal> createState() => _MuscleFilterModalState();
}

class _MuscleFilterModalState extends State<MuscleFilterModal> {
  late final Set<MuscleGroup> _selected;
  final Set<String> _expanded = {};

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.selected);
    // Expandir categorías que tienen seleccionados
    for (final cat in _categories) {
      if (cat.muscles.any(_selected.contains)) {
        _expanded.add(cat.label);
      }
    }
  }

  void _close() => Navigator.pop(context, Set<MuscleGroup>.from(_selected));

  bool get _isAllSelected => _selected.isEmpty;

  void _toggleMuscle(MuscleGroup muscle) {
    setState(() {
      if (_selected.contains(muscle)) {
        _selected.remove(muscle);
      } else {
        _selected.add(muscle);
      }
    });
  }

  void _toggleCategory(String label) {
    setState(() {
      if (_expanded.contains(label)) {
        _expanded.remove(label);
      } else {
        _expanded.add(label);
      }
    });
  }

  void _selectAll() => setState(() => _selected.clear());

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.85;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _close();
      },
      child: ConstrainedBox(
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
              Flexible(
                child: ListView(
                  padding: EdgeInsets.all(0),
                  children: _buildAllItems(),
                ),
              ),
              SizedBox(
                height:
                    MediaQuery.of(context).viewPadding.bottom + AppSpacing.xs,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAllItems() {
    const gap = SizedBox(height: AppSpacing.xs);
    final widgets = <Widget>[];

    // Categorías con más de 1 músculo → expandibles
    final expandable = _categories.where((c) => c.muscles.length > 1).toList();

    // Músculo único de categorías de 1 item + los individuales normales
    final individuals = [
      ..._categories.where((c) => c.muscles.length == 1).expand((c) => c.muscles),
      ..._individualMuscles,
    ];

    widgets.add(_buildTodosItem());

    // Intercalar: antes de cada individual, insertar el próximo expandible
    // → expandibles quedan en posiciones 2, 4 (no consecutivos)
    var catIndex = 0;
    for (var i = 0; i < individuals.length; i++) {
      // Insertar un expandible cada 3 individuales (posiciones 2, 6, 10…)
      if (i % 3 == 0 && catIndex < expandable.length) {
        final cat = expandable[catIndex++];
        final isExpanded = _expanded.contains(cat.label);
        final selectedCount = cat.muscles.where(_selected.contains).length;
        widgets.add(gap);
        widgets.add(_buildCategoryItem(cat, isExpanded, selectedCount));
      }
      widgets.add(gap);
      widgets.add(_buildMuscleRow(individuals[i]));
    }

    // Expandibles sobrantes (si hay más categorías que individuales)
    while (catIndex < expandable.length) {
      final cat = expandable[catIndex++];
      final isExpanded = _expanded.contains(cat.label);
      final selectedCount = cat.muscles.where(_selected.contains).length;
      widgets.add(gap);
      widgets.add(_buildCategoryItem(cat, isExpanded, selectedCount));
    }

    return widgets;
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
            child: Text('Seleccionar Músculos', style: AppTextStyles.h2),
          ),
          CustomGestureDetector(
            onTap: _close,
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

  Widget _buildTodosItem() {
    return CustomGestureDetector(
      onTap: _selectAll,
      child: SizedBox(
        height: 48,
        child: ColoredBox(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Todos',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.32,
                    ),
                  ),
                ),
                _buildCheckbox(_isAllSelected),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(
    _MuscleCategory cat,
    bool isExpanded,
    int selectedCount,
  ) {
    return CustomGestureDetector(
      onTap: () => _toggleCategory(cat.label),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 0),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            // Header del grupo
            Row(
              children: [
                Expanded(
                  child: Text(
                    selectedCount > 0
                        ? '${cat.label} ($selectedCount)'
                        : cat.label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textDescription,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Icon(
                  isExpanded ? LucideIcons.chevronUp : LucideIcons.chevronDown,
                  color: AppColors.textDescription,
                  size: 18,
                ),
              ],
            ),
      
            // Items expandidos
            if (isExpanded)
              FadeIn(
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.md),
                    Column(
                      spacing: AppSpacing.md,
                      children: cat.muscles
                          .map((m) => _buildGroupMuscleRow(m))
                          .toList(),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Item dentro de un grupo (sin borde)
  Widget _buildGroupMuscleRow(MuscleGroup muscle) {
    final isSelected = _selected.contains(muscle);
    return CustomGestureDetector(
      onTap: () => _toggleMuscle(muscle),
      child: Row(
        children: [
          Expanded(
            child: Text(
              muscle.getLabel,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.32,
              ),
            ),
          ),
          _buildCheckbox(isSelected),
        ],
      ),
    );
  }

  Widget _buildMuscleRow(MuscleGroup muscle) {
    final isSelected = _selected.contains(muscle);
    return FadeIn(
      key: ValueKey(muscle),
      child: CustomGestureDetector(
        onTap: () => _toggleMuscle(muscle),
        child: ColoredBox(
          color: Colors.transparent,
          child: SizedBox(
            height: 48,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      muscle.getLabel,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.32,
                      ),
                    ),
                  ),
                  _buildCheckbox(isSelected),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox(bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.card,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(
          color: isSelected ? AppColors.primary : const Color(0xFF43454D),
        ),
      ),
      child: isSelected
          ? const Icon(LucideIcons.check, color: AppColors.white, size: 12)
          : null,
    );
  }
}
