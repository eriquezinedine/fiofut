import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/ingredients_repository.dart';
import '../../domain/models/ingredient.dart';
import '../../domain/providers/ingredient_form_provider.dart';
import '../../domain/providers/ingredients_provider.dart';

class IngredientFormScreen extends ConsumerStatefulWidget {
  const IngredientFormScreen({this.ingredientId, super.key});

  final String? ingredientId;

  @override
  ConsumerState<IngredientFormScreen> createState() =>
      _IngredientFormScreenState();
}

class _IngredientFormScreenState extends ConsumerState<IngredientFormScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _caloriesController;
  late final TextEditingController _proteinController;
  late final TextEditingController _fatController;
  late final TextEditingController _carbsController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _caloriesController = TextEditingController(text: '0');
    _proteinController = TextEditingController(text: '0');
    _fatController = TextEditingController(text: '0');
    _carbsController = TextEditingController(text: '0');

    Future.microtask(() async {
      final notifier = ref.read(ingredientFormProvider.notifier);
      notifier.reset();

      if (widget.ingredientId != null) {
        final repo = ref.read(ingredientsRepositoryProvider);
        final ingredient =
            await repo.getIngredientById(widget.ingredientId!);
        notifier.loadIngredient(ingredient);
        _nameController.text = ingredient.name;
        _caloriesController.text = ingredient.calories.toStringAsFixed(0);
        _proteinController.text = ingredient.protein.toStringAsFixed(0);
        _fatController.text = ingredient.fat.toStringAsFixed(0);
        _carbsController.text = ingredient.carbohydrates.toStringAsFixed(0);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _fatController.dispose();
    _carbsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(ingredientFormProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          formState.isEditing ? 'Editar Ingrediente' : 'Nuevo Ingrediente',
          style: AppTextStyles.h3.copyWith(color: AppColors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              controller: _nameController,
              label: 'Nombre',
              hint: 'Ej: Pechuga de pollo',
              isRequired: true,
              onChanged: ref.read(ingredientFormProvider.notifier).updateName,
            ),
            const SizedBox(height: 16),

            // Calorias - Proteinas
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _caloriesController,
                    label: 'Calorias (kcal)',
                    hint: 'Ej: 165',
                    isRequired: true,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    onChanged: (val) {
                      final v = double.tryParse(val) ?? 0;
                      ref.read(ingredientFormProvider.notifier).updateCalories(v);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppTextField(
                    controller: _proteinController,
                    label: 'Proteinas (g)',
                    hint: 'Ej: 31',
                    isRequired: true,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    onChanged: (val) {
                      final v = double.tryParse(val) ?? 0;
                      ref.read(ingredientFormProvider.notifier).updateProtein(v);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Carbohidratos - Grasas
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _carbsController,
                    label: 'Carbohidratos (g)',
                    hint: 'Ej: 0',
                    isRequired: true,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    onChanged: (val) {
                      final v = double.tryParse(val) ?? 0;
                      ref
                          .read(ingredientFormProvider.notifier)
                          .updateCarbohydrates(v);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppTextField(
                    controller: _fatController,
                    label: 'Grasas (g)',
                    hint: 'Ej: 3.6',
                    isRequired: true,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    onChanged: (val) {
                      final v = double.tryParse(val) ?? 0;
                      ref.read(ingredientFormProvider.notifier).updateFat(v);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Unit selector (for ingredient quantity)
            Text.rich(
              TextSpan(
                text: 'Unidad de medida',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
                children: const [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: AppColors.error),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: IngredientUnit.values.map((unit) {
                final isSelected = formState.unit == unit;
                return GestureDetector(
                  onTap: () => ref
                      .read(ingredientFormProvider.notifier)
                      .updateUnit(unit),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
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
                      unit.displayName,
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

            if (formState.errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  formState.errorMessage!,
                  style:
                      AppTextStyles.caption.copyWith(color: AppColors.error),
                ),
              ),
              const SizedBox(height: 16),
            ],

            AppButton(
              text: formState.isEditing
                  ? 'Guardar Cambios'
                  : 'Crear Ingrediente',
              onPressed: formState.isValid && !formState.isLoading ? _save : null,
              isLoading: formState.isLoading,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final success = await ref.read(ingredientFormProvider.notifier).save();
    if (success && mounted) {
      ref.read(ingredientsProvider.notifier).loadIngredients();
      Navigator.of(context).pop();
    }
  }
}
