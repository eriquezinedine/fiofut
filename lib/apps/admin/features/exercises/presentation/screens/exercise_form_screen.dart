import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/exercises_repository.dart';
import '../../domain/models/exercise.dart';
import '../../domain/providers/exercise_form_provider.dart';
import '../../domain/providers/exercises_provider.dart';

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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _imageUrlController = TextEditingController();

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
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(exerciseFormProvider);

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
            AppTextField(
              controller: _nameController,
              label: 'Nombre',
              hint: 'Ej: Press de banca',
              onChanged: ref.read(exerciseFormProvider.notifier).updateName,
            ),
            const SizedBox(height: 16),

            // Description
            AppTextField(
              controller: _descriptionController,
              label: 'Descripcion',
              hint: 'Describe el ejercicio...',
              maxLines: 3,
              onChanged:
                  ref.read(exerciseFormProvider.notifier).updateDescription,
            ),
            const SizedBox(height: 16),

            // Image URL
            AppTextField(
              controller: _imageUrlController,
              label: 'URL de imagen (opcional)',
              hint: 'https://...',
              onChanged:
                  ref.read(exerciseFormProvider.notifier).updateImageUrl,
            ),
            const SizedBox(height: 24),

            // Muscle Group
            Text(
              'Grupo Muscular',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: MuscleGroup.values.map((group) {
                final isSelected = formState.muscleGroup == group;
                return GestureDetector(
                  onTap: () => ref
                      .read(exerciseFormProvider.notifier)
                      .updateMuscleGroup(group),
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
                      group.displayName,
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

            // Exercise Type
            Text(
              'Tipo de Ejercicio',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
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
              onPressed: formState.isLoading ? null : _save,
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
