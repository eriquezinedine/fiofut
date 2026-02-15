import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';

class EditIngredientModal extends StatefulWidget {
  const EditIngredientModal._({
    required this.ingredientName,
    required this.currentQuantity,
    required this.unit,
  });

  final String ingredientName;
  final double currentQuantity;
  final String unit;

  /// Muestra el modal para editar la cantidad de un ingrediente.
  ///
  /// Retorna la nueva cantidad como [double], o `null` si se cancela.
  static Future<double?> show(
    BuildContext context, {
    required String ingredientName,
    required double currentQuantity,
    required String unit,
  }) {
    return showModalBottomSheet<double>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditIngredientModal._(
        ingredientName: ingredientName,
        currentQuantity: currentQuantity,
        unit: unit,
      ),
    );
  }

  @override
  State<EditIngredientModal> createState() => _EditIngredientModalState();
}

class _EditIngredientModalState extends State<EditIngredientModal> {
  late final TextEditingController _controller;

  String get _unitAbbreviation => switch (widget.unit) {
        'grams' => 'g',
        'milliliters' => 'ml',
        'units' => 'uds',
        _ => widget.unit,
      };

  @override
  void initState() {
    super.initState();
    final qty = widget.currentQuantity;
    _controller = TextEditingController(
      text: qty == qty.roundToDouble() ? qty.toInt().toString() : qty.toString(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
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
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.xl),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.xs,
          AppSpacing.lg,
          0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDragHandle(),
            const SizedBox(height: AppSpacing.md),
            _buildHeader(),
            const SizedBox(height: AppSpacing.lg),
            _buildQuantityInput(),
            const SizedBox(height: AppSpacing.lg),
            _buildButton(),
            SizedBox(
              height:
                  MediaQuery.of(context).viewPadding.bottom + AppSpacing.md,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.ingredientName, style: AppTextStyles.h3),
              const SizedBox(height: AppSpacing.xxxs),
              Text(
                'Editar cantidad',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
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
    );
  }

  Widget _buildQuantityInput() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppSpacing.borderRadiusXl,
      ),
      child: Row(
        children: [
          _buildIncrementButton(
            icon: LucideIcons.minus,
            onTap: () {
              final current = double.tryParse(_controller.text) ?? 0;
              if (current > 1) {
                _updateQuantity(current - _stepForUnit());
              }
            },
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: TextField(
              controller: _controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              textAlign: TextAlign.center,
              style: AppTextStyles.h2.copyWith(
                color: AppColors.primary,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                suffixText: _unitAbbreviation,
                suffixStyle: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          _buildIncrementButton(
            icon: LucideIcons.plus,
            onTap: () {
              final current = double.tryParse(_controller.text) ?? 0;
              _updateQuantity(current + _stepForUnit());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIncrementButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppSpacing.borderRadiusMd,
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 22),
      ),
    );
  }

  Widget _buildButton() {
    return AppButton(
      text: 'Guardar',
      onPressed: () {
        final value = double.tryParse(_controller.text);
        if (value != null && value > 0) {
          Navigator.pop(context, value);
        }
      },
      fullWidth: true,
    );
  }

  double _stepForUnit() {
    return switch (widget.unit) {
      'units' => 1,
      _ => 10,
    };
  }

  void _updateQuantity(double value) {
    if (value < 0) value = 0;
    setState(() {
      _controller.text =
          value == value.roundToDouble() ? value.toInt().toString() : value.toStringAsFixed(1);
    });
  }
}
