import 'dart:ui';

import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/repose/presentation/widgets/muscle_custom_painter/back_body_custom_paint.dart';
import 'package:fio_fut/apps/client/features/repose/presentation/widgets/muscle_custom_painter/front_body_custom_paint.dart';
import 'package:fio_fut/core/extension/muscle_group_extension.dart';
import 'package:flutter/material.dart';
import 'package:model/model.dart';
import 'package:zentoast/zentoast.dart';

class AnimationColorMuscle extends StatefulWidget {
  const AnimationColorMuscle({
    super.key,
    this.selectedMuscles = const {},
    this.onMuscleTap,
    this.onSelectionChanged,
  });

  final Set<MuscleGroup> selectedMuscles;
  final void Function(MuscleGroup muscle)? onMuscleTap;
  final ValueChanged<Set<MuscleGroup>>? onSelectionChanged;

  @override
  State<AnimationColorMuscle> createState() => _AnimationColorMuscleState();
}

class _AnimationColorMuscleState extends State<AnimationColorMuscle>
    with TickerProviderStateMixin {
  late final AnimationController _shimmerController;
  late final Animation<double> _shimmer;
  late final TabController _tabController;
  late final Set<MuscleGroup> _selected;

  // Color transition controllers per muscle
  final Map<MuscleGroup, AnimationController> _colorControllers = {};
  final Map<MuscleGroup, Animation<Color?>> _colorAnimations = {};


  @override
  void initState() {
    super.initState();
    _selected = {...widget.selectedMuscles};
    _tabController = TabController(length: 2, vsync: this);
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _shimmer = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    // Init color controllers for already selected muscles
    for (final muscle in _selected) {
      _createColorController(muscle, selected: true, animate: false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _shimmerController.dispose();
    for (final c in _colorControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _createColorController(
    MuscleGroup muscle, {
    required bool selected,
    bool animate = true,
  }) {
    _colorControllers[muscle]?.dispose();

    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _colorControllers[muscle] = controller;

    final shimmerColor = Color.lerp(
      AppColors.muscleDefaultColor.withValues(alpha: 0.45),
      AppColors.white.withValues(alpha: 0.8),
      _shimmer.value,
    )!;

    if (selected) {
      _colorAnimations[muscle] = ColorTween(
        begin: shimmerColor,
        end: AppColors.primary,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
    } else {
      _colorAnimations[muscle] = ColorTween(
        begin: AppColors.primary,
        end: shimmerColor,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
      controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _colorControllers[muscle]?.dispose();
          _colorControllers.remove(muscle);
          _colorAnimations.remove(muscle);
        }
      });
    }

    if (animate) {
      controller.forward();
    } else {
      controller.value = 1;
    }
  }

  Color _color(MuscleGroup muscle) {
    final anim = _colorAnimations[muscle];
    if (anim != null) {
      final controller = _colorControllers[muscle];
      if (controller != null && controller.isAnimating) {
        return anim.value ?? AppColors.muscleDefaultColor;
      }
      if (_selected.contains(muscle)) return AppColors.primary;
    }
    if (_selected.contains(muscle)) return AppColors.primary;

    return Color.lerp(
      AppColors.muscleDefaultColor.withValues(alpha: 0.45),
      AppColors.white.withValues(alpha: 0.8),
      _shimmer.value,
    )!;
  }

  void _onTap(MuscleGroup muscle) {
    final wasSelected = _selected.contains(muscle);
    setState(() {
      if (wasSelected) {
        _selected.remove(muscle);
        _createColorController(muscle, selected: false);
      } else {
        _selected.add(muscle);
        _createColorController(muscle, selected: true);
      }
    });
    _showToast(muscle, selected: !wasSelected);
    widget.onMuscleTap?.call(muscle);
    widget.onSelectionChanged?.call(Set.unmodifiable(_selected));
  }

  void _showToast(MuscleGroup muscle, {required bool selected}) {
    final color = selected ? AppColors.primary : AppColors.error;
    final icon = selected
        ? Icons.check_circle_rounded
        : Icons.remove_circle_rounded;

    Toast(
      height: 40,
      category: selected ? ToastCategory.success : ToastCategory.error,
      builder: (toast) => Material(
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: color, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    muscle.getLabel,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _shimmer,
        ..._colorControllers.values,
      ]),
      builder: (context, _) {
        return Column(
          children: [
            // Tab bar pill style
            Container(
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(4),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: AppColors.white,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: AppTextStyles.bodySmall,
                tabs: const [
                  Tab(text: 'Frontal', height: 36),
                  Tab(text: 'Espalda', height: 36),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Body views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _Item(
                    child: FrontBodyCustomPaint(
                      colors: FrontMuscleColors(
                        chest: _color(MuscleGroup.chest),
                        abs: _color(MuscleGroup.abs),
                        biceps: _color(MuscleGroup.biceps),
                        obliques: _color(MuscleGroup.obliques),
                        forearms: _color(MuscleGroup.forearms),
                        quadriceps: _color(MuscleGroup.quadriceps),
                        adductors: _color(MuscleGroup.adductors),
                        abductors: _color(MuscleGroup.abductors),
                        lateralDeltoid: _color(MuscleGroup.lateralDeltoid),
                        frontDeltoid: _color(MuscleGroup.frontDeltoid),
                      ),
                      width: 170,
                      onChestTap: () => _onTap(MuscleGroup.chest),
                      onAbsTap: () => _onTap(MuscleGroup.abs),
                      onBicepsTap: () => _onTap(MuscleGroup.biceps),
                      onObliquesTap: () => _onTap(MuscleGroup.obliques),
                      onForearmsTap: () => _onTap(MuscleGroup.forearms),
                      onQuadricepsTap: () => _onTap(MuscleGroup.quadriceps),
                      onAdductorsTap: () => _onTap(MuscleGroup.adductors),
                      onAbductorsTap: () => _onTap(MuscleGroup.abductors),
                      onLateralDeltoidTap: () => _onTap(MuscleGroup.lateralDeltoid),
                      onFrontDeltoidTap: () => _onTap(MuscleGroup.frontDeltoid),
                    ),
                  ),
                  _Item(
                    child: BackBodyCustomPaint(
                      colors: BackMuscleColors(
                        back: _color(MuscleGroup.back),
                        traps: _color(MuscleGroup.traps),
                        lowerBack: _color(MuscleGroup.lowerBack),
                        glutes: _color(MuscleGroup.glutes),
                        triceps: _color(MuscleGroup.triceps),
                        rearDeltoid: _color(MuscleGroup.rearDeltoid),
                        hamstrings: _color(MuscleGroup.hamstrings),
                        calves: _color(MuscleGroup.calves),
                      ),
                      width: 170,
                      onBackTap: () => _onTap(MuscleGroup.back),
                      onTrapsTap: () => _onTap(MuscleGroup.traps),
                      onLowerBackTap: () => _onTap(MuscleGroup.lowerBack),
                      onGlutesTap: () => _onTap(MuscleGroup.glutes),
                      onTricepsTap: () => _onTap(MuscleGroup.triceps),
                      onRearDeltoidTap: () => _onTap(MuscleGroup.rearDeltoid),
                      onHamstringsTap: () => _onTap(MuscleGroup.hamstrings),
                      onCalvesTap: () => _onTap(MuscleGroup.calves),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Center(
        child: SizedBox(
          width: 200,
          child: child,
        ),
      ),
    );
  }
}
