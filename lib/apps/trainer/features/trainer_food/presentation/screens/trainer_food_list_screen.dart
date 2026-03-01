import 'dart:io';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:fio_fut/apps/admin/features/meals/domain/models/food.dart';
import 'package:fio_fut/apps/admin/features/meals/presentation/screens/food_form_screen.dart';
import 'package:fio_fut/apps/admin/features/meals/presentation/widgets/food_card.dart';
import 'package:fio_fut/apps/client/features/register_food/pages/food_detail_page.dart';

import '../../domain/providers/trainer_food_creation_provider.dart';
import '../../domain/providers/trainer_food_provider.dart';
import '../widgets/food_creation_options_sheet.dart';
import 'youtube_food_screen.dart';

class TrainerFoodListScreen extends ConsumerStatefulWidget {
  const TrainerFoodListScreen({super.key});

  @override
  ConsumerState<TrainerFoodListScreen> createState() =>
      _TrainerFoodListScreenState();
}

class _TrainerFoodListScreenState extends ConsumerState<TrainerFoodListScreen>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  final _picker = ImagePicker();
  late TabController _tabController;
  TrainerFoodTab _currentTab = TrainerFoodTab.app;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _currentTab = TrainerFoodTab.values[_tabController.index];
        });
        if (_searchController.text.isNotEmpty) {
          _searchController.clear();
          ref.read(trainerFoodProvider.notifier).loadAll();
        }
      }
    });
    Future.microtask(() {
      ref.read(trainerFoodProvider.notifier).loadAll();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final foodState = ref.watch(trainerFoodProvider);

    ref.listen(trainerFoodCreationProvider, (prev, next) {
      if (next is TrainerFoodCreationSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${next.foodTitle} registrada'),
            backgroundColor: AppColors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      } else if (next is TrainerFoodCreationError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: _showCreationOptions,
        child: const Icon(LucideIcons.plus, color: AppColors.black),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Row(
                children: [
                  Text(
                    'Comidas',
                    style: AppTextStyles.h2.copyWith(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Container(
                height: 48,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: AppColors.black,
                  unselectedLabelColor: AppColors.textMuted,
                  labelStyle: AppTextStyles.titleSmall,
                  unselectedLabelStyle: AppTextStyles.labelLarge,
                  tabs: const [
                    Tab(text: 'App'),
                    Tab(text: 'Mi lista'),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AppSearchField(
                controller: _searchController,
                hint: 'Buscar comidas...',
                onChanged: (query) {
                  ref
                      .read(trainerFoodProvider.notifier)
                      .search(query, _currentTab);
                },
                onClear: () {
                  _searchController.clear();
                  ref.read(trainerFoodProvider.notifier).loadAll();
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: foodState.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primary),
                    )
                  : foodState.error != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(LucideIcons.alertTriangle,
                                  color: AppColors.error, size: 48),
                              const SizedBox(height: 12),
                              Text(
                                foodState.error!,
                                style: AppTextStyles.body
                                    .copyWith(color: AppColors.error),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : TabBarView(
                          controller: _tabController,
                          children: [
                            _FoodList(
                              foods: foodState.appFoods,
                              emptyMessage: 'No hay comidas de la app',
                              emptySubMessage:
                                  'Los administradores aun no han registrado comidas',
                              canDelete: false,
                              onTap: _openFoodDetail,
                              onRefresh: () => ref
                                  .read(trainerFoodProvider.notifier)
                                  .loadAll(),
                            ),
                            _FoodList(
                              foods: foodState.myFoods,
                              emptyMessage: 'No tienes comidas',
                              emptySubMessage:
                                  'Las comidas que crees apareceran aqui',
                              canDelete: true,
                              onTap: _openFoodDetail,
                              onDelete: (id) => _confirmDelete(context, id),
                              onRefresh: () => ref
                                  .read(trainerFoodProvider.notifier)
                                  .loadAll(),
                            ),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreationOptions() {
    showModalBottomSheet<FoodCreationOption>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const FoodCreationOptionsSheet(),
    ).then((option) {
      if (option == null || !mounted) return;
      switch (option) {
        case FoodCreationOption.photo:
          _createFromPhoto();
        case FoodCreationOption.youtube:
          _createFromYouTube();
        case FoodCreationOption.manual:
          _createManual();
      }
    });
  }

  Future<void> _createFromPhoto() async {
    final xFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 60,
      maxWidth: 1024,
    );
    if (xFile == null || !mounted) return;
    ref
        .read(trainerFoodCreationProvider.notifier)
        .createFromPhoto(File(xFile.path));
  }

  void _createFromYouTube() {
    Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const YouTubeFoodScreen()),
    ).then((created) {
      if (created == true && mounted) {
        ref.read(trainerFoodProvider.notifier).loadAll();
      }
    });
  }

  void _createManual() {
    Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => const FoodFormScreen(creatorRole: 'trainer'),
      ),
    ).then((_) {
      if (mounted) {
        ref.read(trainerFoodProvider.notifier).loadAll();
      }
    });
  }

  void _openFoodDetail(Food food) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FoodDetailPage(foodId: food.id),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Eliminar comida',
          style: AppTextStyles.h3.copyWith(color: AppColors.white),
        ),
        content: Text(
          'Esta accion no se puede deshacer.',
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancelar',
              style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(trainerFoodProvider.notifier).deleteFood(id);
            },
            child: Text(
              'Eliminar',
              style: AppTextStyles.body.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _FoodList extends StatelessWidget {
  const _FoodList({
    required this.foods,
    required this.emptyMessage,
    required this.emptySubMessage,
    required this.canDelete,
    required this.onTap,
    required this.onRefresh,
    this.onDelete,
  });

  final List<Food> foods;
  final String emptyMessage;
  final String emptySubMessage;
  final bool canDelete;
  final void Function(Food food) onTap;
  final void Function(String id)? onDelete;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    if (foods.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.utensilsCrossed,
                color: AppColors.textMuted, size: 56),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style:
                  AppTextStyles.h3.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              emptySubMessage,
              style:
                  AppTextStyles.caption.copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: AppColors.card,
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: foods.length,
        itemBuilder: (context, index) {
          final food = foods[index];
          return FoodCard(
            food: food,
            onTap: () => onTap(food),
            onDelete: canDelete && onDelete != null
                ? () => onDelete!(food.id)
                : null,
          );
        },
      ),
    );
  }
}
