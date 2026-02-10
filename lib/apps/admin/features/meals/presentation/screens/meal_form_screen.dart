import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/meals_repository.dart';
import '../../domain/models/meal.dart';
import '../../domain/providers/meal_form_provider.dart';
import '../../domain/providers/meals_provider.dart';

class MealFormScreen extends ConsumerStatefulWidget {
  const MealFormScreen({this.mealId, super.key});

  final String? mealId;

  @override
  ConsumerState<MealFormScreen> createState() => _MealFormScreenState();
}

class _MealFormScreenState extends ConsumerState<MealFormScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _imageUrlController;
  late final TextEditingController _caloriesController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _imageUrlController = TextEditingController();
    _caloriesController = TextEditingController(text: '0');

    Future.microtask(() async {
      final notifier = ref.read(mealFormProvider.notifier);
      notifier.reset();

      if (widget.mealId != null) {
        final repo = ref.read(mealsRepositoryProvider);
        final meal = await repo.getMealById(widget.mealId!);
        notifier.loadMeal(meal);
        _nameController.text = meal.name;
        _descriptionController.text = meal.description ?? '';
        _imageUrlController.text = meal.imageUrl ?? '';
        _caloriesController.text = '${meal.calories}';
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(mealFormProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          formState.isEditing ? 'Editar Comida' : 'Nueva Comida',
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
              hint: 'Ej: Ensalada Cesar',
              onChanged: ref.read(mealFormProvider.notifier).updateName,
            ),
            const SizedBox(height: 16),

            // Description
            AppTextField(
              controller: _descriptionController,
              label: 'Descripcion',
              hint: 'Describe la comida...',
              maxLines: 3,
              onChanged:
                  ref.read(mealFormProvider.notifier).updateDescription,
            ),
            const SizedBox(height: 16),

            // Calories
            AppTextField(
              controller: _caloriesController,
              label: 'Calorias',
              hint: '0',
              keyboardType: TextInputType.number,
              onChanged: (val) {
                final calories = int.tryParse(val) ?? 0;
                ref.read(mealFormProvider.notifier).updateCalories(calories);
              },
            ),
            const SizedBox(height: 16),

            // Image URL
            AppTextField(
              controller: _imageUrlController,
              label: 'URL de imagen (opcional)',
              hint: 'https://...',
              onChanged:
                  ref.read(mealFormProvider.notifier).updateImageUrl,
            ),
            const SizedBox(height: 24),

            // Meal Type
            Text(
              'Tipo de Comida',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: MealType.values.map((type) {
                final isSelected = formState.mealType == type;
                return GestureDetector(
                  onTap: () => ref
                      .read(mealFormProvider.notifier)
                      .updateMealType(type),
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
              text: formState.isEditing ? 'Guardar Cambios' : 'Crear Comida',
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
    final success = await ref.read(mealFormProvider.notifier).save();
    if (success && mounted) {
      ref.read(mealsProvider.notifier).loadMeals();
      Navigator.of(context).pop();
    }
  }
}
