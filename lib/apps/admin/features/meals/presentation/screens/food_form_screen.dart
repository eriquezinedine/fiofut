import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../ingredients/domain/models/ingredient.dart';
import '../../../ingredients/domain/providers/ingredients_provider.dart';
import '../../data/repositories/food_repository.dart';
import '../../domain/models/food.dart';
import '../../domain/providers/food_form_provider.dart';
import '../../domain/providers/food_provider.dart';
import '../widgets/ingredient_selector_sheet.dart';

class FoodFormScreen extends ConsumerStatefulWidget {
  const FoodFormScreen({this.foodId, super.key});

  final String? foodId;

  @override
  ConsumerState<FoodFormScreen> createState() => _FoodFormScreenState();
}

class _FoodFormScreenState extends ConsumerState<FoodFormScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();

    Future.microtask(() async {
      final notifier = ref.read(foodFormProvider.notifier);
      notifier.reset();

      if (widget.foodId != null) {
        final repo = ref.read(foodRepositoryProvider);
        final food = await repo.getFoodById(widget.foodId!);
        notifier.loadFood(food);
        _titleController.text = food.title;
        _descriptionController.text = food.description ?? '';
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(foodFormProvider);

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
            // Title
            AppTextField(
              controller: _titleController,
              label: 'Titulo',
              hint: 'Ej: Ensalada Cesar',
              isRequired: true,
              onChanged: ref.read(foodFormProvider.notifier).updateTitle,
            ),
            const SizedBox(height: 16),

            // Description
            AppTextField(
              controller: _descriptionController,
              label: 'Descripcion (opcional)',
              hint: 'Describe la comida...',
              maxLines: 3,
              onChanged:
                  ref.read(foodFormProvider.notifier).updateDescription,
            ),
            const SizedBox(height: 24),

            // Food type
            Text.rich(
              TextSpan(
                text: 'Tipo de Comida',
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
              children: FoodType.values.map((type) {
                final isSelected = formState.typeFood == type;
                return GestureDetector(
                  onTap: () => ref
                      .read(foodFormProvider.notifier)
                      .updateFoodType(type),
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
            const SizedBox(height: 24),

            // Ingredients section
            Row(
              children: [
                Text.rich(
                  TextSpan(
                    text: 'Ingredientes',
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
                const Spacer(),
                GestureDetector(
                  onTap: () => _showIngredientSelector(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(LucideIcons.plus,
                            color: AppColors.primary, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'Agregar',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Selected ingredients list
            if (formState.selectedIngredients.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.surface,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(LucideIcons.egg,
                        color: AppColors.textMuted, size: 32),
                    const SizedBox(height: 8),
                    Text(
                      'Sin ingredientes',
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              )
            else
              ...formState.selectedIngredients.map((si) {
                return _SelectedIngredientTile(
                  selectedIngredient: si,
                  onQuantityChanged: (qty) {
                    ref
                        .read(foodFormProvider.notifier)
                        .updateIngredientQuantity(si.ingredient.id, qty);
                  },
                  onRemove: () {
                    ref
                        .read(foodFormProvider.notifier)
                        .removeIngredient(si.ingredient.id);
                  },
                );
              }),

            const SizedBox(height: 20),

            // Nutritional totals
            if (formState.selectedIngredients.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Totales Nutricionales',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _TotalChip(
                          label: 'Calorias',
                          value:
                              '${formState.totalCalories.toStringAsFixed(0)} kcal',
                          color: AppColors.orange,
                        ),
                        const SizedBox(width: 8),
                        _TotalChip(
                          label: 'Proteinas',
                          value:
                              '${formState.totalProtein.toStringAsFixed(1)}g',
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _TotalChip(
                          label: 'Carbos',
                          value:
                              '${formState.totalCarbohydrates.toStringAsFixed(1)}g',
                          color: AppColors.info,
                        ),
                        const SizedBox(width: 8),
                        _TotalChip(
                          label: 'Grasas',
                          value:
                              '${formState.totalFat.toStringAsFixed(1)}g',
                          color: AppColors.warning,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

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

            // Save button
            AppButton(
              text: formState.isEditing
                  ? 'Guardar Cambios'
                  : 'Crear Comida',
              onPressed: formState.isValid && !formState.isLoading
                  ? _showConfirmation
                  : null,
              isLoading: formState.isLoading,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showIngredientSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => IngredientSelectorSheet(
        onIngredientSelected: (ingredient, quantity) {
          ref.read(foodFormProvider.notifier).addIngredient(
                ingredient,
                quantity,
              );
        },
        onCreateIngredient: () async {
          Navigator.pop(ctx);
          final result = await _showCreateIngredientDialog();
          if (result != null) {
            ref.read(foodFormProvider.notifier).addIngredient(result, 100);
            ref.read(ingredientsProvider.notifier).loadIngredients();
          }
        },
      ),
    );
  }

  Future<Ingredient?> _showCreateIngredientDialog() async {
    final nameController = TextEditingController();
    final caloriesController = TextEditingController(text: '0');
    final proteinController = TextEditingController(text: '0');
    final fatController = TextEditingController(text: '0');
    final carbsController = TextEditingController(text: '0');

    final numericFormatters = [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
    ];

    final result = await showDialog<Ingredient>(
      context: context,
      builder: (ctx) {
        var canCreate = false;
        return StatefulBuilder(
          builder: (ctx, setDialogState) => AlertDialog(
            backgroundColor: AppColors.card,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Nuevo Ingrediente',
              style: AppTextStyles.h3.copyWith(color: AppColors.white),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppTextField(
                    controller: nameController,
                    label: 'Nombre',
                    hint: 'Ej: Pechuga de pollo',
                    isRequired: true,
                    onChanged: (val) {
                      setDialogState(() {
                        canCreate = val.trim().isNotEmpty;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: caloriesController,
                          label: 'Kcal',
                          hint: 'Ej: 165',
                          isRequired: true,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: numericFormatters,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppTextField(
                          controller: proteinController,
                          label: 'Prot (g)',
                          hint: 'Ej: 31',
                          isRequired: true,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: numericFormatters,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: carbsController,
                          label: 'Carbs (g)',
                          hint: 'Ej: 0',
                          isRequired: true,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: numericFormatters,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppTextField(
                          controller: fatController,
                          label: 'Grasas (g)',
                          hint: 'Ej: 3.6',
                          isRequired: true,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: numericFormatters,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  'Cancelar',
                  style:
                      AppTextStyles.body.copyWith(color: AppColors.textMuted),
                ),
              ),
              TextButton(
                onPressed: canCreate
                    ? () async {
                        final ingredient = await ref
                            .read(foodFormProvider.notifier)
                            .createIngredientInline(
                              name: nameController.text.trim(),
                              calories:
                                  double.tryParse(caloriesController.text) ?? 0,
                              protein:
                                  double.tryParse(proteinController.text) ?? 0,
                              fat: double.tryParse(fatController.text) ?? 0,
                              carbohydrates:
                                  double.tryParse(carbsController.text) ?? 0,
                            );
                        if (ctx.mounted && ingredient != null) {
                          Navigator.pop(ctx, ingredient);
                        }
                      }
                    : null,
                child: Text(
                  'Crear',
                  style: AppTextStyles.body.copyWith(
                    color: canCreate ? AppColors.primary : AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    nameController.dispose();
    caloriesController.dispose();
    proteinController.dispose();
    fatController.dispose();
    carbsController.dispose();

    return result;
  }

  void _showConfirmation() {
    final formState = ref.read(foodFormProvider);

    if (!formState.isValid) {
      _save();
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Confirmar',
          style: AppTextStyles.h3.copyWith(color: AppColors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formState.title,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              formState.typeFood.displayName,
              style: AppTextStyles.caption
                  .copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            Text(
              '${formState.selectedIngredients.length} ingrediente(s)',
              style: AppTextStyles.caption
                  .copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            const Divider(color: AppColors.surface),
            const SizedBox(height: 8),
            _ConfirmRow(
                label: 'Calorias',
                value:
                    '${formState.totalCalories.toStringAsFixed(0)} kcal'),
            _ConfirmRow(
                label: 'Proteinas',
                value:
                    '${formState.totalProtein.toStringAsFixed(1)}g'),
            _ConfirmRow(
                label: 'Carbohidratos',
                value:
                    '${formState.totalCarbohydrates.toStringAsFixed(1)}g'),
            _ConfirmRow(
                label: 'Grasas',
                value: '${formState.totalFat.toStringAsFixed(1)}g'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancelar',
              style:
                  AppTextStyles.body.copyWith(color: AppColors.textMuted),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _save();
            },
            child: Text(
              formState.isEditing ? 'Guardar' : 'Crear',
              style: AppTextStyles.body.copyWith(
                  color: AppColors.primary, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final success = await ref.read(foodFormProvider.notifier).save();
    if (success && mounted) {
      ref.read(foodProvider.notifier).loadFoods();
      Navigator.of(context).pop();
    }
  }
}

class _SelectedIngredientTile extends StatelessWidget {
  const _SelectedIngredientTile({
    required this.selectedIngredient,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  final SelectedIngredient selectedIngredient;
  final ValueChanged<double> onQuantityChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedIngredient.ingredient.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${selectedIngredient.calories.toStringAsFixed(0)} kcal | '
                  '${selectedIngredient.protein.toStringAsFixed(1)}g P | '
                  '${selectedIngredient.carbohydrates.toStringAsFixed(1)}g C | '
                  '${selectedIngredient.fat.toStringAsFixed(1)}g G',
                  style: AppTextStyles.small.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 70,
            child: _QuantityField(
              initialValue: selectedIngredient.quantity,
              unit: selectedIngredient.ingredient.unit.abbreviation,
              onChanged: onQuantityChanged,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onRemove,
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(
                LucideIcons.x,
                color: AppColors.error,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityField extends StatefulWidget {
  const _QuantityField({
    required this.initialValue,
    required this.unit,
    required this.onChanged,
  });

  final double initialValue;
  final String unit;
  final ValueChanged<double> onChanged;

  @override
  State<_QuantityField> createState() => _QuantityFieldState();
}

class _QuantityFieldState extends State<_QuantityField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: widget.initialValue.toStringAsFixed(0));
  }

  @override
  void didUpdateWidget(covariant _QuantityField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _controller.text = widget.initialValue.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
      ],
      textAlign: TextAlign.center,
      style: AppTextStyles.caption.copyWith(color: AppColors.white),
      decoration: InputDecoration(
        suffixText: widget.unit,
        suffixStyle:
            AppTextStyles.small.copyWith(color: AppColors.textMuted),
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.surface),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
      onChanged: (val) {
        final qty = double.tryParse(val) ?? 0;
        widget.onChanged(qty);
      },
    );
  }
}

class _TotalChip extends StatelessWidget {
  const _TotalChip({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: color.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfirmRow extends StatelessWidget {
  const _ConfirmRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.caption
                .copyWith(color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
