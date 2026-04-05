import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'filter_food.dart';

const _kOrangeAccent = Color(0xFFF97316);

class SearchFoodPage extends StatefulWidget {
  const SearchFoodPage({super.key});

  static const String name = 'search-food';
  static const String path = '/search-food';

  @override
  State<SearchFoodPage> createState() => _SearchFoodPageState();
}

class _SearchFoodPageState extends State<SearchFoodPage> {
  int _selectedCategory = 0;

  static const _categories = [
    ('🍳', 'Desayuno'),
    ('🥗', 'Almuerzo'),
    ('🍖', 'Cena'),
    ('🥪', 'Aperitivos'),
    ('🍰', 'Postres'),
  ];

  static const _recipes = [
    _Recipe(
      name: 'Avena con platano',
      kcal: '321 kcal',
      imageUrl:
          'https://images.unsplash.com/photo-1653617748420-1fbe33fd6fdf?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=600',
    ),
    _Recipe(
      name: 'Tostada con aguacate',
      kcal: '322 kcal',
      imageUrl:
          'https://images.unsplash.com/photo-1611255154360-b86b81cfad4b?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=600',
    ),
    _Recipe(
      name: 'Pollo con arroz',
      kcal: '418 kcal',
      imageUrl:
          'https://images.unsplash.com/photo-1573403707306-a29ab9b24686?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=600',
    ),
    _Recipe(
      name: 'Batido yogur platano',
      kcal: '325 kcal',
      imageUrl:
          'https://images.unsplash.com/photo-1638176067000-924231101b88?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=600',
    ),
    _Recipe(
      name: 'Sandwich integral',
      kcal: '380 kcal',
      imageUrl:
          'https://images.unsplash.com/photo-1667925132898-d3fd2b77c172?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=600',
    ),
    _Recipe(
      name: 'Huevos con tomate',
      kcal: '295 kcal',
      imageUrl:
          'https://images.unsplash.com/photo-1658661521700-bf10d02ef04b?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=600',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildCategories(),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _CircleButton(
            icon: LucideIcons.arrowLeft,
            onTap: () => Navigator.pop(context),
          ),
          Text(
            'Recetas',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          _CircleButton(
            icon: LucideIcons.slidersHorizontal,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const FilterFoodPage(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_categories.length, (index) {
          final (emoji, label) = _categories[index];
          final isSelected = _selectedCategory == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = index),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _kOrangeAccent.withValues(alpha: 0.12)
                        : AppColors.card,
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: _kOrangeAccent, width: 2)
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(emoji, style: const TextStyle(fontSize: 24)),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 11,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? _kOrangeAccent : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.md),
          Text(
            'Popular',
            style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.md),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _recipes.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
              childAspectRatio: 0.78,
            ),
            itemBuilder: (context, index) =>
                _RecipeCard(recipe: _recipes[index]),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: AppColors.card,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: AppColors.white, size: AppSpacing.iconSm),
      ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  const _RecipeCard({required this.recipe});

  final _Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppSpacing.borderRadiusLg,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCachedImage(
            imageUrl: recipe.imageUrl,
            width: double.infinity,
            height: 120,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.name,
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Row(
                  children: [
                    const Icon(
                      LucideIcons.flame,
                      color: _kOrangeAccent,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      recipe.kcal,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Recipe {
  const _Recipe({
    required this.name,
    required this.kcal,
    required this.imageUrl,
  });

  final String name;
  final String kcal;
  final String imageUrl;
}
