import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/widgets/ingredient/ingredient.dart';
import '../../../../../core/widgets/modal/edit_ingredient_modal.dart';
import '../../../../client/features/onboarding/data/repositories/ingredient_repository.dart';
import '../domain/providers/food_provider_detail.dart';

/// Pagina para buscar y seleccionar un ingrediente para agregar a una comida.
class SelectIngredientPage extends ConsumerWidget {
  const SelectIngredientPage({
    super.key,
    required this.foodId,
  });

  final String foodId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Buscar ingrediente',
          style: AppTextStyles.titleMedium.copyWith(color: AppColors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: IngredientSearchBody(
          onIngredientTap: (item) =>
              _onIngredientSelected(context, ref, item),
          selectedNames: const {},
          onAddNew: (name) => _onAddNew(context, ref, name),
        ),
      ),
    );
  }

  Future<void> _onIngredientSelected(
    BuildContext context,
    WidgetRef ref,
    IngredientItem item,
  ) async {
    // Pedir cantidad
    final quantity = await EditIngredientModal.show(
      context,
      ingredientName: item.name,
      currentQuantity: 100,
      unit: 'g',
    );

    if (quantity == null || !context.mounted) return;

    // Insertar en detail_food_ingredient
    final error = await ref.read(foodDetailProvider.notifier).addIngredient(
          foodId: foodId,
          ingredientId: item.id,
          quantity: quantity,
        );

    if (!context.mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppColors.error),
      );
    } else {
      Navigator.pop(context, true);
    }
  }

  Future<void> _onAddNew(
    BuildContext context,
    WidgetRef ref,
    String name,
  ) async {
    AddIngredientSheet.show(
      context,
      initialText: name,
      onAdd: (ingredientName) async {
        if (!context.mounted) return;

        try {
          // Insertar nuevo ingrediente en la tabla ingredient
          final supabase = Supabase.instance.client;
          final userId = supabase.auth.currentUser?.id;

          final result = await supabase.from('ingredient').insert({
            'name': ingredientName,
            'created_by_role': 'student',
            'created_by': userId,
          }).select('id').single();

          if (!context.mounted) return;

          final newId = result['id'] as String;

          // Pedir cantidad
          final quantity = await EditIngredientModal.show(
            context,
            ingredientName: ingredientName,
            currentQuantity: 100,
            unit: 'g',
          );

          if (quantity == null || !context.mounted) return;

          // Insertar en detail_food_ingredient
          final error =
              await ref.read(foodDetailProvider.notifier).addIngredient(
                    foodId: foodId,
                    ingredientId: newId,
                    quantity: quantity,
                  );

          if (!context.mounted) return;

          if (error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error), backgroundColor: AppColors.error),
            );
          } else {
            Navigator.pop(context, true);
          }
        } catch (e) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al crear ingrediente: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
    );
  }
}
