import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../ingredients/domain/models/ingredient.dart';

class IngredientQuantitySheet extends StatefulWidget {
  const IngredientQuantitySheet._({required this.ingredient});

  final Ingredient ingredient;

  static Future<double?> show(
    BuildContext context, {
    required Ingredient ingredient,
  }) {
    return showModalBottomSheet<double>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => IngredientQuantitySheet._(ingredient: ingredient),
    );
  }

  @override
  State<IngredientQuantitySheet> createState() =>
      _IngredientQuantitySheetState();
}

class _IngredientQuantitySheetState extends State<IngredientQuantitySheet> {
  late final TextEditingController _qtyController;

  @override
  void initState() {
    super.initState();
    _qtyController = TextEditingController(text: '100');
  }

  @override
  void dispose() {
    _qtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Cantidad',
              style: AppTextStyles.h3.copyWith(color: AppColors.white),
            ),
            const SizedBox(height: 4),
            Text(
              widget.ingredient.name,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _qtyController,
              label: 'Cantidad (${widget.ingredient.unit.abbreviation})',
              hint: 'Ej: 100',
              isRequired: true,
              autofocus: true,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'Cancelar',
                    type: AppButtonType.secondary,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    text: 'Agregar',
                    onPressed: () {
                      final qty =
                          double.tryParse(_qtyController.text) ?? 100;
                      Navigator.pop(context, qty);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
