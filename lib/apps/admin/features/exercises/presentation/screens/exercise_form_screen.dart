import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/exercises_repository.dart';
import 'package:model/model.dart';

import '../../domain/models/exercise.dart';
import '../../domain/providers/exercise_form_provider.dart';
import '../../domain/providers/exercises_provider.dart';
import '../../domain/providers/muscles_provider.dart';

class ExerciseFormScreen extends ConsumerStatefulWidget {
  const ExerciseFormScreen({this.exerciseId, super.key});

  final String? exerciseId;

  @override
  ConsumerState<ExerciseFormScreen> createState() =>
      _ExerciseFormScreenState();
}

class _ExerciseFormScreenState extends ConsumerState<ExerciseFormScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _imageUrlController;
  late final TextEditingController _videoUrlController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _imageUrlController = TextEditingController();
    _videoUrlController = TextEditingController();

    Future.microtask(() async {
      final notifier = ref.read(exerciseFormProvider.notifier);
      notifier.reset();

      if (widget.exerciseId != null) {
        final repo = ref.read(exercisesRepositoryProvider);
        final exercise = await repo.getExerciseById(widget.exerciseId!);
        notifier.loadExercise(exercise);
        _nameController.text = exercise.name;
        _descriptionController.text = exercise.description ?? '';
        _imageUrlController.text = exercise.imageUrl ?? '';
        _videoUrlController.text = exercise.videoUrl ?? '';
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _videoUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(exerciseFormProvider);
    final musclesAsync = ref.watch(musclesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          formState.isEditing ? 'Editar Ejercicio' : 'Nuevo Ejercicio',
          style: AppTextStyles.h3.copyWith(color: AppColors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name
            _RequiredLabel(text: 'Nombre'),
            const SizedBox(height: 6),
            AppTextField(
              controller: _nameController,
              hint: 'Ej: Press de banca',
              onChanged: ref.read(exerciseFormProvider.notifier).updateName,
            ),
            const SizedBox(height: 16),

            // Description
            _RequiredLabel(text: 'Descripcion'),
            const SizedBox(height: 6),
            AppTextField(
              controller: _descriptionController,
              hint: 'Describe el ejercicio...',
              maxLines: 3,
              onChanged:
                  ref.read(exerciseFormProvider.notifier).updateDescription,
            ),
            const SizedBox(height: 16),

            // Image URL
            _RequiredLabel(text: 'URL de imagen'),
            const SizedBox(height: 6),
            AppTextField(
              controller: _imageUrlController,
              hint: 'https://...',
              onChanged:
                  ref.read(exerciseFormProvider.notifier).updateImageUrl,
            ),
            const SizedBox(height: 16),

            // Video URL
            _RequiredLabel(text: 'URL de video'),
            const SizedBox(height: 6),
            AppTextField(
              controller: _videoUrlController,
              hint: 'https://youtube.com/...',
              onChanged:
                  ref.read(exerciseFormProvider.notifier).updateVideoUrl,
            ),
            const SizedBox(height: 24),

            // Location
            _RequiredLabel(text: 'Ubicacion'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ExerciseLocation.values.map((loc) {
                final isSelected = formState.location == loc;
                return GestureDetector(
                  onTap: () => ref
                      .read(exerciseFormProvider.notifier)
                      .updateLocation(loc),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.15)
                          : AppColors.card,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      loc.displayName,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Primary Muscle
            _RequiredLabel(text: 'Musculo Principal'),
            const SizedBox(height: 10),
            musclesAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 2,
                  ),
                ),
              ),
              error: (e, _) => Text(
                'Error cargando musculos',
                style: AppTextStyles.caption.copyWith(color: AppColors.error),
              ),
              data: (muscles) => _MuscleChips(
                muscles: muscles,
                selectedId: formState.primaryMuscleId,
                disabledIds: const [],
                onTap: (id) => ref
                    .read(exerciseFormProvider.notifier)
                    .updatePrimaryMuscle(id),
              ),
            ),
            const SizedBox(height: 24),

            // Secondary Muscles
            Text(
              'Musculos Secundarios',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Selecciona los musculos que tambien trabaja este ejercicio',
              style: AppTextStyles.small.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 10),
            musclesAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (muscles) => _MuscleMultiChips(
                muscles: muscles,
                selectedIds: formState.secondaryMuscleIds,
                disabledId: formState.primaryMuscleId,
                onTap: (id) => ref
                    .read(exerciseFormProvider.notifier)
                    .toggleSecondaryMuscle(id),
              ),
            ),
            const SizedBox(height: 24),

            // Exercise Type
            _RequiredLabel(text: 'Tipo de Ejercicio'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ExerciseType.values.map((type) {
                final isSelected = formState.exerciseType == type;
                return GestureDetector(
                  onTap: () => ref
                      .read(exerciseFormProvider.notifier)
                      .updateExerciseType(type),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.15)
                          : AppColors.card,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      type.displayName,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            // Error
            if (formState.errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  formState.errorMessage!,
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.error),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Save button
            AppButton(
              text: formState.isEditing ? 'Guardar Cambios' : 'Crear Ejercicio',
              onPressed:
                  formState.isLoading || !formState.isValid ? null : _save,
              isLoading: formState.isLoading,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final success =
        await ref.read(exerciseFormProvider.notifier).save();
    if (success && mounted) {
      ref.read(exercisesProvider.notifier).loadExercises();
      Navigator.of(context).pop();
    }
  }
}

class _RequiredLabel extends StatelessWidget {
  const _RequiredLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: text,
            style: AppTextStyles.labelMedium,
          ),
          const TextSpan(
            text: ' *',
            style: TextStyle(
              color: AppColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Single-select muscle chips
class _MuscleChips extends StatelessWidget {
  const _MuscleChips({
    required this.muscles,
    required this.selectedId,
    required this.disabledIds,
    required this.onTap,
  });

  final List<Muscle> muscles;
  final String? selectedId;
  final List<String> disabledIds;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: muscles.map((muscle) {
        final isSelected = selectedId == muscle.id;
        final isDisabled = disabledIds.contains(muscle.id);
        return GestureDetector(
          onTap: isDisabled ? null : () => onTap(muscle.id),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : isDisabled
                      ? AppColors.surface
                      : AppColors.card,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Text(
              muscle.name,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? AppColors.primary
                    : isDisabled
                        ? AppColors.textMuted
                        : AppColors.textSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Multi-select muscle chips
class _MuscleMultiChips extends StatelessWidget {
  const _MuscleMultiChips({
    required this.muscles,
    required this.selectedIds,
    required this.disabledId,
    required this.onTap,
  });

  final List<Muscle> muscles;
  final List<String> selectedIds;
  final String? disabledId;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: muscles.map((muscle) {
        final isSelected = selectedIds.contains(muscle.id);
        final isDisabled = muscle.id == disabledId;
        return GestureDetector(
          onTap: isDisabled ? null : () => onTap(muscle.id),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : isDisabled
                      ? AppColors.surface
                      : AppColors.card,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected) ...[
                  Icon(
                    Icons.check,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                ],
                Text(
                  muscle.name,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.primary
                        : isDisabled
                            ? AppColors.textMuted
                            : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
