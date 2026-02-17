import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise.dart';
import 'package:fio_fut/core/extension/muscle_group_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:model/model.dart';

class ExerciseInstructionModal extends StatelessWidget {
  const ExerciseInstructionModal._({
    required this.exercise,
  });

  final Exercise exercise;

  /// Muestra el modal de instrucciones del ejercicio.
  ///
  /// [exercise] es el objeto Exercise con toda la información necesaria.
  static Future<void> show(
    BuildContext context, {
    required Exercise exercise,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ExerciseInstructionModal._(
        exercise: exercise,
      ),
    );
  }

  List<String> get _instructions {
    // Dividir las instrucciones por saltos de línea
    return exercise.instruccion
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInstructionsSection(),
                  const SizedBox(height: AppSpacing.xl),
                  _buildTargetMuscleSection(),
                ],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).viewPadding.bottom + AppSpacing.xs,
          ),
        ],
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
        AppSpacing.lg,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              exercise.title,
              style: AppTextStyles.h2,
            ),
          ),
          GestureDetector(
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

  Widget _buildInstructionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Instrucciones',
          style: AppTextStyles.h3,
        ),
        const SizedBox(height: AppSpacing.lg),
        ..._instructions.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final instruction = entry.value;

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$index. ',
                  style: AppTextStyles.caption.copyWith(
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                Expanded(
                  child: Text(
                    instruction,
                    style: AppTextStyles.caption.copyWith(
                      height: 1.5,
                      color: AppColors.white
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTargetMuscleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Musculo Objetivo',
          style: AppTextStyles.h3,
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: AppSpacing.borderRadiusMd,
              ),
              child: SizedBox.square(
                dimension: 56,
                child: SvgPicture.asset(exercise.muscleMain.muscleGroup.getIcon),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            MainMuscleWidget(exercise: exercise),
          ],
        ),
        if (exercise.muscleSecundaries.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Músculos Secundarios',
            style: AppTextStyles.h3,
          ),
          const SizedBox(height: AppSpacing.lg),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: AppSpacing.md,
              children: exercise.muscleSecundaries
                  .map((muscle) => _SecondaryMuscleItem(muscle: muscle))
                  .toList(),
            ),
          ),
        ],
      ],
    );
  }
}

class MainMuscleWidget extends StatelessWidget {
  const MainMuscleWidget({
    super.key,
    required this.exercise,
  });

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            exercise.muscleMain.name,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xxxs),
          Text(
            'Músculo Principal',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}

class _SecondaryMuscleItem extends StatelessWidget {
  const _SecondaryMuscleItem({required this.muscle});

  final Muscle muscle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox.square(
          dimension: 56,
          child: SvgPicture.asset(muscle.muscleGroup.getIcon),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          muscle.name,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.white,
          ),
        ),
      ],
    );
  }
}
