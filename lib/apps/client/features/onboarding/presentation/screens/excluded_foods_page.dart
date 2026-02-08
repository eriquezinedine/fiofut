import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../domain/providers/providers.dart';
import '../widgets/widgets.dart';

/// Pantalla 9: Alimentos excluidos
class ExcludedFoodsPage extends ConsumerStatefulWidget {
  const ExcludedFoodsPage({super.key});

  @override
  ConsumerState<ExcludedFoodsPage> createState() => _ExcludedFoodsPageState();
}

class _ExcludedFoodsPageState extends ConsumerState<ExcludedFoodsPage>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  late TabController _tabController;
  String _searchQuery = '';

  final List<String> _categories = ['Todos', 'Verduras', 'Carne', 'Lácteos', 'Frutas'];

  // Base de datos de alimentos por categoría
  final Map<String, List<_FoodData>> _foodDatabase = {
    'Verduras': [
      // Verduras comunes
      _FoodData(emoji: '🥦', name: 'Brócoli'),
      _FoodData(emoji: '🥕', name: 'Zanahoria'),
      _FoodData(emoji: '🥬', name: 'Lechuga'),
      _FoodData(emoji: '🍅', name: 'Tomate'),
      _FoodData(emoji: '🧅', name: 'Cebolla'),
      _FoodData(emoji: '🥒', name: 'Pepino'),
      _FoodData(emoji: '🥔', name: 'Papa'),
      _FoodData(emoji: '🍆', name: 'Berenjena'),
      _FoodData(emoji: '🌽', name: 'Maíz'),
      _FoodData(emoji: '🥑', name: 'Aguacate'),
      _FoodData(emoji: '🫑', name: 'Pimiento'),
      _FoodData(emoji: '🧄', name: 'Ajo'),
      _FoodData(emoji: '🥗', name: 'Espinaca'),
      _FoodData(emoji: '🍄', name: 'Champiñón'),
      _FoodData(emoji: '🎃', name: 'Calabaza'),
      _FoodData(emoji: '🥦', name: 'Coliflor'),
      _FoodData(emoji: '🥬', name: 'Col'),
      _FoodData(emoji: '🥬', name: 'Apio'),
      _FoodData(emoji: '🥬', name: 'Acelga'),
      _FoodData(emoji: '🥬', name: 'Espárrago'),
      _FoodData(emoji: '🥬', name: 'Alcachofa'),
      _FoodData(emoji: '🥬', name: 'Kale'),
      _FoodData(emoji: '🥬', name: 'Arúgula'),
      _FoodData(emoji: '🥬', name: 'Berro'),
      _FoodData(emoji: '🥬', name: 'Endivia'),
      _FoodData(emoji: '🫛', name: 'Chícharo'),
      _FoodData(emoji: '🫛', name: 'Ejote'),
      _FoodData(emoji: '🥕', name: 'Betabel'),
      _FoodData(emoji: '🥕', name: 'Nabo'),
      _FoodData(emoji: '🥕', name: 'Rábano'),
      _FoodData(emoji: '🥒', name: 'Calabacín'),
      _FoodData(emoji: '🥒', name: 'Chayote'),
      _FoodData(emoji: '🥔', name: 'Camote'),
      _FoodData(emoji: '🥔', name: 'Yuca'),
      _FoodData(emoji: '🌶️', name: 'Chile'),
      _FoodData(emoji: '🌶️', name: 'Jalapeño'),
      _FoodData(emoji: '🌶️', name: 'Serrano'),
      _FoodData(emoji: '🌶️', name: 'Habanero'),
      _FoodData(emoji: '🌶️', name: 'Poblano'),
      _FoodData(emoji: '🌿', name: 'Cilantro'),
      _FoodData(emoji: '🌿', name: 'Perejil'),
      _FoodData(emoji: '🌿', name: 'Albahaca'),
      _FoodData(emoji: '🌿', name: 'Orégano'),
      _FoodData(emoji: '🌿', name: 'Menta'),
      _FoodData(emoji: '🌿', name: 'Romero'),
      _FoodData(emoji: '🌿', name: 'Tomillo'),
      _FoodData(emoji: '🫚', name: 'Jengibre'),
      _FoodData(emoji: '🌵', name: 'Nopal'),
      _FoodData(emoji: '🥔', name: 'Jícama'),
    ],
    'Carne': [
      // Carnes rojas
      _FoodData(emoji: '🥩', name: 'Res'),
      _FoodData(emoji: '🥩', name: 'Bistec'),
      _FoodData(emoji: '🥩', name: 'Filete'),
      _FoodData(emoji: '🥩', name: 'Costilla'),
      _FoodData(emoji: '🥩', name: 'Carne molida'),
      _FoodData(emoji: '🍖', name: 'Cerdo'),
      _FoodData(emoji: '🍖', name: 'Chuleta'),
      _FoodData(emoji: '🍖', name: 'Costilla de cerdo'),
      _FoodData(emoji: '🍖', name: 'Cordero'),
      _FoodData(emoji: '🍖', name: 'Cabrito'),
      // Aves
      _FoodData(emoji: '🍗', name: 'Pollo'),
      _FoodData(emoji: '🍗', name: 'Pechuga'),
      _FoodData(emoji: '🍗', name: 'Muslo'),
      _FoodData(emoji: '🍗', name: 'Alitas'),
      _FoodData(emoji: '🦃', name: 'Pavo'),
      _FoodData(emoji: '🦆', name: 'Pato'),
      _FoodData(emoji: '🐔', name: 'Gallina'),
      // Pescados
      _FoodData(emoji: '🐟', name: 'Pescado'),
      _FoodData(emoji: '🐟', name: 'Salmón'),
      _FoodData(emoji: '🐟', name: 'Atún'),
      _FoodData(emoji: '🐟', name: 'Trucha'),
      _FoodData(emoji: '🐟', name: 'Tilapia'),
      _FoodData(emoji: '🐟', name: 'Bacalao'),
      _FoodData(emoji: '🐟', name: 'Róbalo'),
      _FoodData(emoji: '🐟', name: 'Mojarra'),
      _FoodData(emoji: '🐟', name: 'Sardina'),
      _FoodData(emoji: '🐟', name: 'Anchoa'),
      _FoodData(emoji: '🐟', name: 'Bagre'),
      _FoodData(emoji: '🐟', name: 'Huachinango'),
      _FoodData(emoji: '🐟', name: 'Mero'),
      // Mariscos
      _FoodData(emoji: '🦐', name: 'Camarón'),
      _FoodData(emoji: '🦞', name: 'Langosta'),
      _FoodData(emoji: '🦀', name: 'Cangrejo'),
      _FoodData(emoji: '🦑', name: 'Calamar'),
      _FoodData(emoji: '🐙', name: 'Pulpo'),
      _FoodData(emoji: '🦪', name: 'Ostión'),
      _FoodData(emoji: '🦪', name: 'Almeja'),
      _FoodData(emoji: '🦪', name: 'Mejillón'),
      _FoodData(emoji: '🦐', name: 'Langostino'),
      _FoodData(emoji: '🦀', name: 'Jaiba'),
      // Embutidos y procesados
      _FoodData(emoji: '🥓', name: 'Tocino'),
      _FoodData(emoji: '🥓', name: 'Jamón'),
      _FoodData(emoji: '🌭', name: 'Salchicha'),
      _FoodData(emoji: '🍖', name: 'Chorizo'),
      _FoodData(emoji: '🍖', name: 'Longaniza'),
      _FoodData(emoji: '🥩', name: 'Salami'),
      _FoodData(emoji: '🥩', name: 'Pepperoni'),
      _FoodData(emoji: '🥩', name: 'Mortadela'),
      _FoodData(emoji: '🥩', name: 'Prosciutto'),
      // Vísceras y otros
      _FoodData(emoji: '🫀', name: 'Hígado'),
      _FoodData(emoji: '🫀', name: 'Riñón'),
      _FoodData(emoji: '🫀', name: 'Corazón'),
      _FoodData(emoji: '👅', name: 'Lengua'),
      _FoodData(emoji: '🥩', name: 'Tripas'),
      _FoodData(emoji: '🥓', name: 'Chicharrón'),
      // Huevos
      _FoodData(emoji: '🥚', name: 'Huevo'),
      _FoodData(emoji: '🥚', name: 'Huevo de codorniz'),
    ],
    'Lácteos': [
      // Leches
      _FoodData(emoji: '🥛', name: 'Leche'),
      _FoodData(emoji: '🥛', name: 'Leche entera'),
      _FoodData(emoji: '🥛', name: 'Leche descremada'),
      _FoodData(emoji: '🥛', name: 'Leche deslactosada'),
      _FoodData(emoji: '🥛', name: 'Leche de almendra'),
      _FoodData(emoji: '🥛', name: 'Leche de soya'),
      _FoodData(emoji: '🥛', name: 'Leche de coco'),
      _FoodData(emoji: '🥛', name: 'Leche de avena'),
      _FoodData(emoji: '🥛', name: 'Leche condensada'),
      _FoodData(emoji: '🥛', name: 'Leche evaporada'),
      // Quesos
      _FoodData(emoji: '🧀', name: 'Queso'),
      _FoodData(emoji: '🧀', name: 'Queso fresco'),
      _FoodData(emoji: '🧀', name: 'Queso panela'),
      _FoodData(emoji: '🧀', name: 'Queso Oaxaca'),
      _FoodData(emoji: '🧀', name: 'Queso manchego'),
      _FoodData(emoji: '🧀', name: 'Queso cheddar'),
      _FoodData(emoji: '🧀', name: 'Queso mozzarella'),
      _FoodData(emoji: '🧀', name: 'Queso parmesano'),
      _FoodData(emoji: '🧀', name: 'Queso azul'),
      _FoodData(emoji: '🧀', name: 'Queso feta'),
      _FoodData(emoji: '🧀', name: 'Queso gouda'),
      _FoodData(emoji: '🧀', name: 'Queso brie'),
      _FoodData(emoji: '🧀', name: 'Queso crema'),
      _FoodData(emoji: '🧀', name: 'Queso cottage'),
      _FoodData(emoji: '🧀', name: 'Queso ricotta'),
      _FoodData(emoji: '🧀', name: 'Queso mascarpone'),
      // Yogurts y cremas
      _FoodData(emoji: '🥣', name: 'Yogurt'),
      _FoodData(emoji: '🥣', name: 'Yogurt griego'),
      _FoodData(emoji: '🥣', name: 'Kéfir'),
      _FoodData(emoji: '🥛', name: 'Crema'),
      _FoodData(emoji: '🥛', name: 'Crema ácida'),
      _FoodData(emoji: '🥛', name: 'Crema batida'),
      _FoodData(emoji: '🥛', name: 'Media crema'),
      _FoodData(emoji: '🥛', name: 'Nata'),
      _FoodData(emoji: '🥛', name: 'Suero de leche'),
      // Mantequillas
      _FoodData(emoji: '🧈', name: 'Mantequilla'),
      _FoodData(emoji: '🧈', name: 'Mantequilla sin sal'),
      _FoodData(emoji: '🧈', name: 'Ghee'),
      _FoodData(emoji: '🧈', name: 'Margarina'),
      // Helados
      _FoodData(emoji: '🍦', name: 'Helado'),
      _FoodData(emoji: '🍦', name: 'Helado de vainilla'),
      _FoodData(emoji: '🍦', name: 'Helado de chocolate'),
      _FoodData(emoji: '🍨', name: 'Nieve'),
    ],
    'Frutas': [
      // Frutas comunes
      _FoodData(emoji: '🍎', name: 'Manzana'),
      _FoodData(emoji: '🍏', name: 'Manzana verde'),
      _FoodData(emoji: '🍌', name: 'Plátano'),
      _FoodData(emoji: '🍊', name: 'Naranja'),
      _FoodData(emoji: '🍋', name: 'Limón'),
      _FoodData(emoji: '🍋‍🟩', name: 'Lima'),
      _FoodData(emoji: '🍊', name: 'Mandarina'),
      _FoodData(emoji: '🍊', name: 'Toronja'),
      _FoodData(emoji: '🍊', name: 'Clementina'),
      _FoodData(emoji: '🍇', name: 'Uvas'),
      _FoodData(emoji: '🍇', name: 'Uvas verdes'),
      _FoodData(emoji: '🍓', name: 'Fresa'),
      _FoodData(emoji: '🫐', name: 'Arándano'),
      _FoodData(emoji: '🫐', name: 'Mora'),
      _FoodData(emoji: '🫐', name: 'Frambuesa'),
      _FoodData(emoji: '🫐', name: 'Zarzamora'),
      _FoodData(emoji: '🍒', name: 'Cereza'),
      _FoodData(emoji: '🍑', name: 'Durazno'),
      _FoodData(emoji: '🍑', name: 'Nectarina'),
      _FoodData(emoji: '🍑', name: 'Chabacano'),
      _FoodData(emoji: '🍐', name: 'Pera'),
      _FoodData(emoji: '🥝', name: 'Kiwi'),
      // Frutas tropicales
      _FoodData(emoji: '🍍', name: 'Piña'),
      _FoodData(emoji: '🥭', name: 'Mango'),
      _FoodData(emoji: '🍉', name: 'Sandía'),
      _FoodData(emoji: '🍈', name: 'Melón'),
      _FoodData(emoji: '🥥', name: 'Coco'),
      _FoodData(emoji: '🍌', name: 'Papaya'),
      _FoodData(emoji: '🥭', name: 'Maracuyá'),
      _FoodData(emoji: '🥭', name: 'Guayaba'),
      _FoodData(emoji: '🥭', name: 'Guanábana'),
      _FoodData(emoji: '🥭', name: 'Chirimoya'),
      _FoodData(emoji: '🥭', name: 'Lichi'),
      _FoodData(emoji: '🥭', name: 'Pitahaya'),
      _FoodData(emoji: '🥭', name: 'Tamarindo'),
      _FoodData(emoji: '🥭', name: 'Mamey'),
      _FoodData(emoji: '🥭', name: 'Zapote'),
      _FoodData(emoji: '🍈', name: 'Tuna'),
      // Frutas secas y otros
      _FoodData(emoji: '🫒', name: 'Aceituna'),
      _FoodData(emoji: '🍇', name: 'Ciruela'),
      _FoodData(emoji: '🍇', name: 'Ciruela pasa'),
      _FoodData(emoji: '🫐', name: 'Higo'),
      _FoodData(emoji: '🫐', name: 'Dátil'),
      _FoodData(emoji: '🫐', name: 'Granada'),
      _FoodData(emoji: '⭐', name: 'Carambola'),
      // Nueces y semillas
      _FoodData(emoji: '🥜', name: 'Cacahuate'),
      _FoodData(emoji: '🌰', name: 'Nuez'),
      _FoodData(emoji: '🌰', name: 'Almendra'),
      _FoodData(emoji: '🌰', name: 'Avellana'),
      _FoodData(emoji: '🌰', name: 'Pistache'),
      _FoodData(emoji: '🌰', name: 'Castaña'),
      _FoodData(emoji: '🌰', name: 'Nuez de la India'),
      _FoodData(emoji: '🌰', name: 'Nuez pecana'),
      _FoodData(emoji: '🌰', name: 'Macadamia'),
      _FoodData(emoji: '🌻', name: 'Semilla de girasol'),
      _FoodData(emoji: '🎃', name: 'Pepita'),
      _FoodData(emoji: '🌱', name: 'Chía'),
      _FoodData(emoji: '🌱', name: 'Linaza'),
      _FoodData(emoji: '🌱', name: 'Ajonjolí'),
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  String get _selectedCategory => _categories[_tabController.index];

  // Emoji por defecto para alimentos personalizados
  static const String _defaultEmoji = '🍽️';

  // Obtener todos los nombres de alimentos en la base de datos
  Set<String> get _allDatabaseFoodNames {
    final names = <String>{};
    for (final category in _foodDatabase.values) {
      for (final food in category) {
        names.add(food.name);
      }
    }
    return names;
  }

  List<_FoodData> _getFilteredFoods(List<String> excludedFoods) {
    List<_FoodData> foods = [];

    if (_selectedCategory == 'Todos') {
      // Agregar todos los alimentos de todas las categorías
      for (final category in _foodDatabase.values) {
        foods.addAll(category);
      }

      // Agregar alimentos personalizados (excluidos que no están en la base de datos)
      final databaseNames = _allDatabaseFoodNames;
      for (final excludedFood in excludedFoods) {
        if (!databaseNames.contains(excludedFood)) {
          foods.add(_FoodData(emoji: _defaultEmoji, name: excludedFood));
        }
      }
    } else {
      foods = List.from(_foodDatabase[_selectedCategory] ?? []);
    }

    // Filtrar por búsqueda
    if (_searchQuery.isNotEmpty) {
      foods = foods
          .where((food) => food.name.toLowerCase().contains(_searchQuery))
          .toList();
    }

    // Ordenar: excluidos primero
    foods.sort((a, b) {
      final aExcluded = excludedFoods.contains(a.name);
      final bExcluded = excludedFoods.contains(b.name);
      if (aExcluded && !bExcluded) return -1;
      if (!aExcluded && bExcluded) return 1;
      return 0;
    });

    return foods;
  }

  bool _showAddButton(List<String> excludedFoods) {
    return _searchQuery.isNotEmpty && _getFilteredFoods(excludedFoods).isEmpty;
  }

  void _showAddFoodModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.transparent,
      isScrollControlled: true,
      builder: (context) => _AddFoodModal(
        initialText: _searchQuery,
        onAddFood: (food) {
          ref.read(onboardingProvider.notifier).addExcludedFood(food);
          Navigator.pop(context);
          _searchController.clear();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);
    final excludedFoods = state.data.excludedFoods;

    return OnboardingScaffold(
      progress: state.progress,
      title: '¿Cuál es la comida que\nno te gusta o te hace mal?',
      onBack: () => notifier.previousStep(),
      bottomSection: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_showAddButton(excludedFoods)) ...[
            OnboardingSecondaryButton(
              text: 'Agregar',
              icon: LucideIcons.plus,
              onPressed: _showAddFoodModal,
            ),
            const SizedBox(height: 12),
          ],
          OnboardingContinueButton(
            onPressed: () => notifier.nextStep(),
            text: 'Continuar',
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          AppTextField(
            controller: _searchController,
            hint: 'Buscar...',
            prefixIcon: LucideIcons.search,
          ),
          const SizedBox(height: 20),
          // TabBar de categorías
          Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              padding: const EdgeInsets.all(4),
              labelPadding: const EdgeInsets.symmetric(horizontal: 4),
              indicator: BoxDecoration(
                color: AppColors.green,
                borderRadius: BorderRadius.circular(10),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: AppColors.transparent,
              labelColor: AppColors.black,
              unselectedLabelColor: AppColors.white,
              labelStyle: AppTextStyles.labelMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: AppTextStyles.labelMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
              tabs: _categories.map((category) {
                return Tab(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(category),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          // Lista de alimentos o estado vacío
          Builder(
            builder: (context) {
              final filteredFoods = _getFilteredFoods(excludedFoods);
              if (filteredFoods.isEmpty) {
                return SizedBox(
                  height: 150,
                  child: AppEmptyState(
                    icon: LucideIcons.searchX,
                    title: 'No se encontró resultados',
                    iconSize: 48,
                    iconColor: AppColors.textMuted,
                  ),
                );
              }
              return Column(
                children: filteredFoods.map((food) {
                  final isExcluded = excludedFoods.contains(food.name);
                  return _FoodListItem(
                    emoji: food.emoji,
                    name: food.name,
                    isExcluded: isExcluded,
                    onTap: () {
                      if (isExcluded) {
                        notifier.removeExcludedFood(food.name);
                      } else {
                        notifier.addExcludedFood(food.name);
                      }
                    },
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Item de alimento en la lista
class _FoodListItem extends StatelessWidget {
  const _FoodListItem({
    required this.emoji,
    required this.name,
    required this.isExcluded,
    required this.onTap,
  });

  final String emoji;
  final String name;
  final bool isExcluded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomGestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isExcluded ? AppColors.green : AppColors.card,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isExcluded ? AppColors.black : AppColors.white,
                  fontWeight: isExcluded ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
            if (isExcluded)
              const Icon(
                LucideIcons.check,
                color: AppColors.black,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

/// Datos de un alimento
class _FoodData {
  final String emoji;
  final String name;

  const _FoodData({required this.emoji, required this.name});
}

/// Modal para agregar alimentos personalizados
class _AddFoodModal extends StatefulWidget {
  const _AddFoodModal({
    required this.onAddFood,
    this.initialText = '',
  });

  final ValueChanged<String> onAddFood;
  final String initialText;

  @override
  State<_AddFoodModal> createState() => _AddFoodModalState();
}

class _AddFoodModalState extends State<_AddFoodModal> {
  late TextEditingController _inputController;

  final List<_FoodData> _suggestions = [
    _FoodData(emoji: '🍕', name: 'Pizza'),
    _FoodData(emoji: '🍔', name: 'Hamburguesa'),
    _FoodData(emoji: '🍟', name: 'Papas'),
    _FoodData(emoji: '🌮', name: 'Tacos'),
    _FoodData(emoji: '🧀', name: 'Queso'),
    _FoodData(emoji: '🥚', name: 'Huevo'),
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

  void _addFood() {
    final text = _inputController.text.trim();
    if (text.isNotEmpty) {
      widget.onAddFood(text);
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
          // Handle bar
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
          // Modal header
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
          // Modal content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Input container
                AppTextField(
                  controller: _inputController,
                  hint: 'Escribe el nombre del alimento...',
                  prefixIcon: LucideIcons.utensils,
                  onSubmitted: (_) => _addFood(),
                ),
                const SizedBox(height: 20),
                // Suggestions label
                Text(
                  'Sugerencias populares',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                // Suggestions grid
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
                // Add button
                AppButton(
                  text: 'Agregar',
                  icon: LucideIcons.plus,
                  onPressed: _addFood,
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
