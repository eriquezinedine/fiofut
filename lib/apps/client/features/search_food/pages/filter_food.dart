import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

const _kOrangeAccent = Color(0xFFF97316);

class FilterFoodPage extends StatefulWidget {
  const FilterFoodPage({super.key});

  static const String name = 'filter-food';
  static const String path = '/filter-food';

  @override
  State<FilterFoodPage> createState() => _FilterFoodPageState();
}

class _FilterFoodPageState extends State<FilterFoodPage> {
  final List<_ExcludedItem> _excludedItems = [
    const _ExcludedItem(emoji: '🐟', name: 'Salmon'),
    const _ExcludedItem(emoji: '🧀', name: 'Queso'),
    const _ExcludedItem(emoji: '🐟', name: 'Pescado'),
  ];

  static const _allergens = [
    // Row 1
    [
      ('🌾', 'Gluten'),
      ('🥛', 'Leche'),
      ('🦪', 'Mariscos'),
    ],
    // Row 2
    [
      ('🥚', 'Huevos'),
      ('🌰', 'Frutos secos'),
    ],
    // Row 3
    [
      ('🌿', 'Sesamo'),
      ('🥜', 'Mani'),
      ('🌱', 'Soja'),
    ],
  ];

  void _removeItem(int index) {
    setState(() => _excludedItems.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.xs),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppSpacing.lg),
                    topRight: Radius.circular(AppSpacing.lg),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderButtons(),
                      const SizedBox(height: AppSpacing.md),
                      _buildTitle(),
                      const SizedBox(height: AppSpacing.md),
                      _buildExcludedItems(),
                      const SizedBox(height: AppSpacing.md),
                      _buildSearchInput(),
                      const SizedBox(height: AppSpacing.lg),
                      _buildAllergenSection(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              LucideIcons.x,
              color: AppColors.white,
              size: AppSpacing.iconSm,
            ),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context, _excludedItems),
          child: Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: _kOrangeAccent,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              LucideIcons.check,
              color: AppColors.white,
              size: AppSpacing.iconMd,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Que dejar fuera',
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Alergias y aversiones',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildExcludedItems() {
    return Column(
      children: List.generate(_excludedItems.length, (index) {
        final item = _excludedItems[index];
        return Padding(
          padding: EdgeInsets.only(
            bottom: index < _excludedItems.length - 1 ? AppSpacing.sm : 0,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    item.emoji,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    item.name,
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _removeItem(index),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      LucideIcons.x,
                      color: AppColors.textSecondary,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSearchInput() {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.centerLeft,
      child: TextField(
        style: AppTextStyles.input,
        decoration: InputDecoration(
          hintText: 'Escriba los alimentos a excluir',
          hintStyle: AppTextStyles.caption.copyWith(
            color: AppColors.textMuted,
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildAllergenSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alergenos comunes',
          style: AppTextStyles.titleSmall.copyWith(
            color: _kOrangeAccent,
          ),
        ),
        const SizedBox(height: 14),
        ..._allergens.map(
          (row) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Row(
              children: row
                  .map(
                    (chip) => Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.xs),
                      child: _AllergenChip(
                        emoji: chip.$1,
                        label: chip.$2,
                        onTap: () {
                          final exists = _excludedItems
                              .any((item) => item.name == chip.$2);
                          if (!exists) {
                            setState(() {
                              _excludedItems.add(
                                _ExcludedItem(
                                  emoji: chip.$1,
                                  name: chip.$2,
                                ),
                              );
                            });
                          }
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _AllergenChip extends StatelessWidget {
  const _AllergenChip({
    required this.emoji,
    required this.label,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          border: Border.all(color: AppColors.surface),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.labelLarge.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExcludedItem {
  const _ExcludedItem({required this.emoji, required this.name});

  final String emoji;
  final String name;
}
