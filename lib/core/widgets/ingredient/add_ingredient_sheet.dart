import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class _Suggestion {
  final String emoji;
  final String name;
  const _Suggestion({required this.emoji, required this.name});
}

class AddIngredientSheet extends StatefulWidget {
  const AddIngredientSheet({
    super.key,
    required this.onAdd,
    this.initialText = '',
  });

  final ValueChanged<String> onAdd;
  final String initialText;

  static Future<void> show(
    BuildContext context, {
    required ValueChanged<String> onAdd,
    String initialText = '',
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.transparent,
      isScrollControlled: true,
      builder: (context) => AddIngredientSheet(
        onAdd: (name) {
          onAdd(name);
          Navigator.pop(context);
        },
        initialText: initialText,
      ),
    );
  }

  @override
  State<AddIngredientSheet> createState() => _AddIngredientSheetState();
}

class _AddIngredientSheetState extends State<AddIngredientSheet> {
  late TextEditingController _inputController;

  static const _suggestions = [
    _Suggestion(emoji: '🍕', name: 'Pizza'),
    _Suggestion(emoji: '🍔', name: 'Hamburguesa'),
    _Suggestion(emoji: '🍟', name: 'Papas'),
    _Suggestion(emoji: '🌮', name: 'Tacos'),
    _Suggestion(emoji: '🧀', name: 'Queso'),
    _Suggestion(emoji: '🥚', name: 'Huevo'),
  ];

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _inputController.text.trim();
    if (text.isNotEmpty) {
      widget.onAdd(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.only(bottom: 34),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Agregar alimento',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                CustomGestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceAlt,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      LucideIcons.x,
                      color: AppColors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  controller: _inputController,
                  hint: 'Escribe el nombre del alimento...',
                  prefixIcon: LucideIcons.utensils,
                  onSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 20),
                Text(
                  'Sugerencias populares',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _suggestions.map((suggestion) {
                    return CustomGestureDetector(
                      onTap: () {
                        _inputController.text = suggestion.name;
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              suggestion.emoji,
                              style: AppTextStyles.caption,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              suggestion.name,
                              style: AppTextStyles.labelMedium.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),
                AppButton(
                  text: 'Agregar',
                  icon: LucideIcons.plus,
                  onPressed: _submit,
                  size: AppButtonSize.large,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
